import 'dart:async';
import 'dart:ui';

import 'package:MELODY/core/services/audio_player_service.dart';
import 'package:MELODY/data/models/BE/music_data.dart';
import 'package:MELODY/data/models/UI/lyric_line.dart';
import 'package:MELODY/data/services/music_service.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Music_player/library_tab.dart';
import 'package:MELODY/views/screens/Notification_screen/notification_screen.dart';
import 'package:MELODY/views/widgets/custom_button/goBack_button.dart';
import 'package:MELODY/views/widgets/notification/notification_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class MusicPlayer extends StatefulWidget {
  final String musicId;
  const MusicPlayer({super.key, required this.musicId});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Future<MusicData> songDetailFuture;
  Timer? _progressTimer;
  bool isPlaying = false;
  bool isLyricsExpanded = false;
  double currentPosition = 0.0;
  late TimestampedLyrics _timestampedLyrics;
  int _activeLyricIndex = -1;
  final MusicService _musicService = MusicService();
  final AudioPlayerService _audioPlayerService = AudioPlayerService();

  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _localAudioPath;

  // ScrollController to handle automatic scrolling of lyrics
  final ScrollController _lyricsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch the song details using the service
    songDetailFuture = _musicService.getMusicById(widget.musicId);

    // Initialize audio player
    _audioPlayerService.init();

    // Listen to position stream
    _audioPlayerService.positionStream.listen((position) {
      setState(() {
        currentPosition = position.inSeconds.toDouble();

        // Update active lyric index
        final currentDuration = position;
        final newActiveIndex = _timestampedLyrics.getActiveLineIndex(
          currentDuration,
        );

        // Only update and scroll if the active index has changed
        if (newActiveIndex != _activeLyricIndex) {
          _activeLyricIndex = newActiveIndex;

          // Get the song data and scroll to active lyric
          songDetailFuture.then((song) {
            Future.delayed(Duration(milliseconds: 50), () {
              _scrollToActiveLyric(song);
            });
          });
        }
      });
    });

    // Listen to player state
    _audioPlayerService.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          isPlaying = false;
          _rotationController.stop();
        });
      }
    });

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    // Initialize timestamped lyrics and check for cached audio
    songDetailFuture
        .then((song) async {
          _initTimestampedLyrics(song);

          // Check if audio is already downloaded
          final cachedPath = await _musicService.getCachedAudioPath(
            widget.musicId,
          );
          if (cachedPath != null) {
            setState(() {
              _localAudioPath = cachedPath;
            });
            await _audioPlayerService.loadAudio(cachedPath);
          } else {
            // Automatically download audio without showing progress
            _downloadAudioInBackground(song);
          }
        })
        .catchError((error) {
          debugPrint('Error initializing lyrics: $error');
        });
  }

  // Initialize timestamped lyrics when song data is available
  void _initTimestampedLyrics(MusicData song) {
    _timestampedLyrics = TimestampedLyrics.fromPlainText(
      song.lyrics,
      song.duration ?? Duration.zero,
    );
  }

  // Download audio file in background
  Future<void> _downloadAudioInBackground(MusicData song) async {
    if (_localAudioPath != null || _isDownloading) return;

    // Set downloading flag
    setState(() {
      _isDownloading = true;
    });

    try {
      final localPath = await _musicService.downloadMusicFile(
        song.id,
        song.audioUrl,
        onProgress: (progress) {
          // Don't update UI with progress
          _downloadProgress = progress;
        },
      );

      // Update path and load audio when download completes
      await _audioPlayerService.loadAudio(localPath);

      // Update UI once download is complete
      if (mounted) {
        setState(() {
          _localAudioPath = localPath;
          _isDownloading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
      debugPrint('Error downloading audio: $e');
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _rotationController.dispose();
    _audioPlayerService.dispose();
    super.dispose();
  }

  void startProgress(MusicData song) async {
    // If audio is already downloaded, play it
    if (_localAudioPath != null) {
      _audioPlayerService.play();
      _rotationController.repeat();
    } else if (!_isDownloading) {
      // If not downloaded and not currently downloading, show loading indicator
      // The download should have already started in initState, but just in case
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10),
              Text('Preparing audio...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void stopProgress() {
    _audioPlayerService.pause();
    _rotationController.stop();
  }

  // Method to scroll to the active lyric
  void _scrollToActiveLyric(MusicData song) {
    if (_activeLyricIndex < 0 || !_lyricsScrollController.hasClients) return;

    final lines =
        song.lyrics
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .toList();
    if (_activeLyricIndex >= lines.length) return;

    // Calculate the position to scroll to
    double position = 0;
    // Define line height based on view state
    final double lineHeight = isLyricsExpanded ? 40.0 : 30.0;

    // Calculate visible area height
    double visibleAreaHeight = 100; // Default for unexpanded lyrics
    if (isLyricsExpanded) {
      // For expanded view, use a larger portion of the screen
      visibleAreaHeight = MediaQuery.of(context).size.height * 0.6;
    }

    // Center the active lyric if possible
    if (isLyricsExpanded) {
      // In expanded view, calculate position to center the active lyric
      position = _activeLyricIndex * lineHeight;
      // Subtract half the visible area to center
      position = position - (visibleAreaHeight / 2) + (lineHeight / 2);
    } else {
      // For non-expanded lyrics, keep it simpler - keep active line in the top portion
      position = _activeLyricIndex * lineHeight;
      // Add a small offset to ensure it's not at the very top
      position = position - lineHeight;
    }

    // Ensure we don't scroll beyond bounds
    position = position.clamp(
      0,
      _lyricsScrollController.position.maxScrollExtent,
    );

    // Smooth scroll to the position with slight delay to ensure UI is updated
    _lyricsScrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void getPreviousMusic(String currentId) async {
    try {
      setState(() {
        // Show loading state
        isPlaying = false;
        stopProgress();
      });

      final previousMusic = await _musicService.getPreviousMusic(currentId);
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) =>
                  MusicPlayer(musicId: previousMusic.id),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    } catch (e) {
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not load previous song: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void getNextMusic(String currentId) async {
    try {
      setState(() {
        // Show loading state
        isPlaying = false;
        stopProgress();
      });

      final nextMusic = await _musicService.getNextMusic(currentId);
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) =>
                  MusicPlayer(musicId: nextMusic.id),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    } catch (e) {
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not load next song: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Build a single lyric line with active/inactive styling
  Widget _buildLyricLine(String line, int index, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          vertical: isActive ? 8.0 : 4.0,
          horizontal: isActive ? 16.0 : 4.0,
        ),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style:
              isActive
                  ? LightTextTheme.paragraph2.copyWith(
                    color: Colors.white,
                    fontSize: isLyricsExpanded ? 18 : 16,
                    height: 1.5,
                    fontWeight: LightTextTheme.semibold.fontWeight,
                  )
                  : LightTextTheme.paragraph2.copyWith(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.normal,
                  ),
          child: Text(line, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  // Build download button or progress indicator
  Widget _buildDownloadButton(MusicData song) {
    if (_localAudioPath != null) {
      return Container(); // Already downloaded
    }

    if (_isDownloading) {
      return Container(); // Hide download progress
    }

    return Container(); // No download button
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MusicData>(
      future: songDetailFuture,
      builder: (context, snapshot) {
        // Handle loading state for song data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen('Loading song information...');
        }

        // Handle error state
        if (snapshot.hasError) {
          return _buildErrorScreen(snapshot.error.toString());
        }

        // Handle data loaded successfully
        final song = snapshot.data!;

        // Initialize timestamped lyrics if not already initialized
        if (_activeLyricIndex == -1) {
          _timestampedLyrics = TimestampedLyrics.fromPlainText(
            song.lyrics,
            song.duration,
          );
        }

        // If the audio file is downloading or not yet available, show loading screen
        if (_isDownloading || (_localAudioPath == null && !_isDownloading)) {
          // Start the download if it hasn't started yet
          if (_localAudioPath == null && !_isDownloading) {
            // Use Future.microtask to avoid calling setState during build
            Future.microtask(() => _downloadAudioInBackground(song));
          }
          return _buildLoadingScreen('Preparing audio...');
        }

        // Audio is downloaded and ready to play
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;

        return Scaffold(
          body: Stack(
            children: [
              _buildBackgroundImage(song.albumArt, screenHeight),
              _buildGradientOverlay(),
              _buildTopBar(),
              _buildRotatingDisc(song.albumArt, screenWidth),
              _buildLyrics(song),
              if (!isLyricsExpanded)
                _buildBottomDetailContainer(song, screenWidth),
            ],
          ),
        );
      },
    );
  }

  // Loading screen with animation
  Widget _buildLoadingScreen(String message) {
    return Scaffold(
      backgroundColor: LightColorTheme.black.withOpacity(0.6),
      body: Center(
        child:
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     // Album art placeholder with pulse animation
        //     Container(
        //       width: 200,
        //       height: 200,
        //       decoration: BoxDecoration(
        //         color: LightColorTheme.grey.withOpacity(0.3),
        //         borderRadius: BorderRadius.circular(20),
        //         boxShadow: [
        //           BoxShadow(
        //             color: Colors.black.withOpacity(0.2),
        //             blurRadius: 15,
        //             spreadRadius: 5,
        //           ),
        //         ],
        //       ),
        //       child: Center(
        //         child: Icon(
        //           Icons.music_note,
        //           size: 80,
        //           color: LightColorTheme.white.withOpacity(0.7),
        //         ),
        //       ),
        //     ),
        //     const SizedBox(height: 40),
        CircularProgressIndicator(color: LightColorTheme.mainColor),
        //       const SizedBox(height: 20),
        //       Text(
        //         message,
        //         style: const TextStyle(
        //           color: Colors.white,
        //           fontWeight: FontWeight.w500,
        //           fontSize: 16,
        //         ),
        //       ),
        //     ],
        //   ),
      ),
    );
  }

  // Error screen
  Widget _buildErrorScreen(String errorMessage) {
    return Scaffold(
      backgroundColor: LightColorTheme.black.withOpacity(0.6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GoBackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 20),
            Text(
              'Error loading song',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Retry loading the music
                  songDetailFuture = _musicService.getMusicById(widget.musicId);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: LightColorTheme.mainColor,
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage(String albumArt, double height) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      height:
          isLyricsExpanded ? MediaQuery.of(context).size.height : 0.7 * height,
      width: double.infinity,
      child: Image.network(
        albumArt,
        fit: BoxFit.cover,
        errorBuilder:
            (_, __, ___) => Container(
              height:
                  isLyricsExpanded
                      ? MediaQuery.of(context).size.height
                      : 0.7 * height,
              color: Colors.grey[300],
            ),
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GoBackButton(onPressed: () => Navigator.pop(context)),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child: NotificationButton(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationScreen(),
                      ),
                    ),
                hasNewNotification: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black.withOpacity(0.9), Colors.transparent],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
    );
  }

  Widget _buildRotatingDisc(String albumArt, double screenWidth) {
    return Positioned(
      top: 120,
      left: screenWidth / 2 - 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                width: 260,
                height: 260,
                decoration: const BoxDecoration(
                  color: Colors.white10,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _rotationController,
            builder:
                (_, child) => Transform.rotate(
                  angle: _rotationController.value * 2 * 3.1415926,
                  child: child,
                ),
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: LightColorTheme.white, width: 1),
                image: DecorationImage(
                  image: NetworkImage(albumArt),
                  fit: BoxFit.cover,
                ),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLyrics(MusicData song) {
    if (isLyricsExpanded) {
      // Show full lyrics when expanded
      return Stack(
        children: [
          // Full screen overlay
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                // Ignore taps on background
              },
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          ),

          // Lyrics container with the same position as when not expanded
          Positioned(
            top:
                MediaQuery.of(context).size.height *
                0.25, // Position lower in expanded view
            left: 0,
            right: 0,
            bottom:
                80, // Add bottom constraint to make space for the close button
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SingleChildScrollView(
                    controller: _lyricsScrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      children: [
                        ...song.lyrics
                            .split('\n')
                            .map(
                              (line) => _buildLyricLine(
                                line,
                                song.lyrics.split('\n').indexOf(line),
                                song.lyrics.split('\n').indexOf(line) ==
                                    _activeLyricIndex,
                              ),
                            ),
                        const SizedBox(
                          height: 80,
                        ), // Extra padding at the bottom
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  // If the user drags up with some velocity, close the expanded view
                  if (details.velocity.pixelsPerSecond.dy < -300) {
                    setState(() {
                      isLyricsExpanded = false;
                    });
                  }
                },
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLyricsExpanded = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LightColorTheme.white,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: const CircleBorder(),
                    minimumSize: const Size(50, 50),
                  ),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Center(
                      child: SvgPicture.asset(
                        ImageTheme.topArrowIcon,
                        width: 24,
                        height: 24,
                        color: LightColorTheme.mainColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // Show preview lyrics with more content but in the same position
      return Positioned(
        top: 420, // Position it below the album art
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: () {
            setState(() {
              isLyricsExpanded = true;
            });
          },
          child: Container(
            height: 120, // Fixed height for lyrics container
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
            ),
            child: SingleChildScrollView(
              controller: _lyricsScrollController,
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  // Using consistent padding to avoid uneven line spacing
                  ...song.lyrics
                      .split('\n')
                      .map(
                        (line) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style:
                                song.lyrics.split('\n').indexOf(line) ==
                                        _activeLyricIndex
                                    ? LightTextTheme.paragraph2.copyWith(
                                      color: Colors.white,
                                      fontSize: 16,
                                      height: 1.5,
                                      fontWeight:
                                          LightTextTheme.semibold.fontWeight,
                                    )
                                    : LightTextTheme.paragraph2.copyWith(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 16,
                                      height: 1.5,
                                      fontWeight: FontWeight.normal,
                                    ),
                            child: Text(line, textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                  SizedBox(height: 30), // Extra spacing at bottom
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildBottomDetailContainer(MusicData song, double screenWidth) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 0.4 * MediaQuery.of(context).size.height,
      child: Container(
        padding: const EdgeInsets.only(left: 32, right: 32, top: 35),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              song.name,
              style: LightTextTheme.headding2.copyWith(
                fontSize: 22,
                color: LightColorTheme.black,
              ),
            ),
            const SizedBox(height: 4),
            Text('Ca sĩ: ${song.artist}', style: LightTextTheme.paragraph3),
            const SizedBox(height: 20),
            _buildActionIcons(screenWidth),
            _buildSlider(song, screenWidth),
            const SizedBox(height: 24),
            _buildSongControls(song),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcons(double screenWidth) {
    return SizedBox(
      width: 0.6 * screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _icon(ImageTheme.heartIcon),
          _icon(ImageTheme.downloadIcon),
          IconButton(
            onPressed: () {
              print(" Share button pressed");
              Share.share(
                'Check out this song: ${widget.musicId}',
                subject: 'Song Details',
              );
              print("Share button pressed 2");
            },
            icon: Icon(Icons.share, color: LightColorTheme.black, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _icon(String path) => Padding(
    padding: const EdgeInsets.all(14),
    child: SvgPicture.asset(path, width: 26, height: 26),
  );

  Widget _buildSlider(MusicData song, double screenWidth) {
    return Container(
      width: 0.8 * MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _formatTime(currentPosition.toInt()),
            style: LightTextTheme.paragraph3,
          ),
          SizedBox(
            width: 0.65 * screenWidth,
            child: SfSlider(
              min: 0.0,
              max: song.duration.inSeconds.toDouble(),
              value: currentPosition,
              activeColor: LightColorTheme.mainColor,
              showTicks: true,
              thumbIcon: Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: LightColorTheme.mainColor,
                  shape: BoxShape.circle,
                ),
              ),

              //custom slide
              onChanged: (value) => _updateSliderPosition(song, value),
            ),
          ),
          Text(
            _formatTime(song.duration.inSeconds),
            style: LightTextTheme.paragraph3,
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  Widget _buildSongControls(MusicData song) {
    return Container(
      width: 0.8 * MediaQuery.of(context).size.width,
      // width:
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Replay song button
          GestureDetector(
            onTap: () {
              // Handle replay button tap
              setState(() {
                // Reset song position to beginning
                currentPosition = 0.0;
                if (isPlaying) {
                  // If already playing, restart from beginning
                  stopProgress();
                  startProgress(song);
                }
              });
            },
            child: SvgPicture.asset(ImageTheme.replayIcon, width: 30),
          ),

          // Previous song button
          GestureDetector(
            onTap: () {
              // Handle previous song button tap
              // In a real app, you would navigate to the previous song
              getPreviousMusic(song.id);
            },
            child: SvgPicture.asset(ImageTheme.prevSongIcon, width: 30),
          ),

          // Play/Pause button
          GestureDetector(
            onTap: () {
              // Handle play/pause button tap
              setState(() {
                if (isPlaying) {
                  stopProgress();
                  _rotationController.stop();
                } else {
                  startProgress(song);
                  _rotationController.repeat();
                }
                isPlaying = !isPlaying;
              });
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: LightColorTheme.mainColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: SvgPicture.asset(
                  isPlaying ? ImageTheme.playIcon : ImageTheme.stopIcon,
                  width: 22,
                  height: 22,
                ),
              ),
            ),
          ),

          // Next song button
          GestureDetector(
            onTap: () {
              // Handle next song button tap
              // In a real app, you would navigate to the next song
              // For demo purposes, let's just finish the current song
              getNextMusic(song.id);
            },
            child: SvgPicture.asset(ImageTheme.nextSongIcon, width: 30),
          ),

          // Library button
          GestureDetector(
            onTap: () {
              // Handle library button tap
              // For example, show a modal with song playlist or library options
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder:
                    (context) => LibraryTab(
                      name: song.name,
                      imageUrl: song.albumArt,
                      singer: song.artist,
                      musicId: song.id,
                    ),
              );
            },
            child: SvgPicture.asset(
              ImageTheme.libraryIcon,
              width: 30,
              color: LightColorTheme.black,
            ),
          ),
        ],
      ),
    );
  }

  // Slider update to seek audio
  void _updateSliderPosition(MusicData song, double value) {
    setState(() => currentPosition = value);
    final seekPosition = Duration(seconds: value.toInt());
    _audioPlayerService.seek(seekPosition);
  }
}
