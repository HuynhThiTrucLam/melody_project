import 'dart:async';
import 'dart:ui';
import 'package:MELODY/data/models/UI/lyric_line.dart';
import 'package:MELODY/views/screens/Music_player/library_tab.dart';
import 'package:MELODY/views/widgets/not_found/not_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:MELODY/data/models/BE/music_data.dart';
import 'package:MELODY/data/services/music_service.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Notification_screen/notification_screen.dart';
import 'package:MELODY/views/widgets/custom_button/goBack_button.dart';
import 'package:MELODY/views/widgets/notification/notification_button.dart';

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

  // ScrollController to handle automatic scrolling of lyrics
  final ScrollController _lyricsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    songDetailFuture = _musicService.getMusicById(widget.musicId);
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
  }

  // Initialize timestamped lyrics when song data is available
  void _initTimestampedLyrics(MusicData song) {
    _timestampedLyrics = TimestampedLyrics.fromPlainText(
      song.lyrics,
      song.duration,
    );
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _rotationController.dispose();
    super.dispose();
  }

  void startProgress(MusicData song) {
    // Initialize timestamped lyrics if needed
    if (!this._timestampedLyrics.lines.isNotEmpty) {
      _initTimestampedLyrics(song);
    }

    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (currentPosition < song.duration.inSeconds) {
        setState(() {
          currentPosition += 0.1;
          // Use the timestamped lyrics to find the active lyric line
          final currentDuration = Duration(
            milliseconds: (currentPosition * 1000).toInt(),
          );
          final newActiveIndex = _timestampedLyrics.getActiveLineIndex(
            currentDuration,
          );

          // Only update and scroll if the active index has changed
          if (newActiveIndex != _activeLyricIndex) {
            _activeLyricIndex = newActiveIndex;

            // Scroll to the active lyric line with a small delay to ensure UI is updated
            Future.delayed(Duration(milliseconds: 50), () {
              _scrollToActiveLyric(song);
            });
          }
        });
      } else {
        timer.cancel();
        setState(() => isPlaying = false);
      }
    });
  }

  void stopProgress() {
    _progressTimer?.cancel();
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
    // Define line height based on view state and include padding
    final double lineHeight = isLyricsExpanded ? 40.0 : 30.0;
    const double paddingBetweenLines =
        6.0; // Fixed padding between lines in unexpanded view

    // For unexpanded view, calculate position more precisely
    if (!isLyricsExpanded) {
      // Calculate position based on active lyric index
      position = _activeLyricIndex * (lineHeight);

      // Don't use negative padding in unexpanded mode to ensure lyric stays at top
      position = position.clamp(
        0,
        _lyricsScrollController.position.maxScrollExtent,
      );
    } else {
      // For expanded view, use existing calculation
      position = _activeLyricIndex * lineHeight;
      final topPadding = 20.0; // Padding for expanded view
      position = position - topPadding;
      position = position.clamp(
        0,
        _lyricsScrollController.position.maxScrollExtent,
      );
    }

    // Smooth scroll to the position
    _lyricsScrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Method to update the active lyric index based on song progress
  void updateActiveLyricIndex(MusicData song) {
    // This is a simplified implementation
    // In a real app, you would need timestamps for each lyric line
    // For now, we'll use a simple approach based on song progress
    final lyricsLines =
        song.lyrics
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .toList();
    if (lyricsLines.isEmpty) return;

    final songProgress = currentPosition / song.duration.inSeconds;
    final newIndex = (songProgress * lyricsLines.length).floor();

    // Ensure the index is within bounds
    if (newIndex != _activeLyricIndex && newIndex < lyricsLines.length) {
      setState(() {
        _activeLyricIndex = newIndex;
      });
    }
  }

  void getPreviousMusic(String presentId) async {
    try {
      final previousMusic = await _musicService.getPreviousMusic(presentId);
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
      // Handle error (e.g., show a message)
    }
  }

  void getNextMusic(String presentId) async {
    try {
      final nextMusic = await _musicService.getNextMusic(presentId);
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
      // Handle error (e.g., show a message)
    }
  }

  // Build a single lyric line with active/inactive styling
  Widget _buildLyricLine(String line, int index, bool isActive) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        style:
            isActive
                ? LightTextTheme.paragraph2.copyWith(
                  color: Colors.white,
                  fontSize: 16,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MusicData>(
      future: songDetailFuture,
      builder: (context, snapshot) {
        // Handle loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: LightColorTheme.black.withOpacity(0.6),
            body: Center(
              child: CircularProgressIndicator(
                color: LightColorTheme.mainColor,
              ),
            ),
          );
        }

        // Handle error state
        if (snapshot.hasError || snapshot.data == null) {
          return NotFound(
            title: 'Không tìm thấy bài hát',
            message: 'Có lỗi xảy ra khi tải bài hát này.',
          );
        }

        // If we have data, proceed normally
        final song = snapshot.data!;

        // Initialize timestamped lyrics if not already initialized
        if (_activeLyricIndex == -1) {
          _timestampedLyrics = TimestampedLyrics.fromPlainText(
            song.lyrics,
            song.duration,
          );
        }

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
            top: 400,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              // Using intrinsic height widget to get max-content behavior
              child: IntrinsicHeight(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 250, // Maximum height constraint
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    // border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: OverflowBox(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                    alignment: Alignment.topCenter,
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
                              height: 40,
                            ), // Extra padding at the bottom
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            bottom: 64,
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
        top: 400,
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: () {
            setState(() {
              isLyricsExpanded = true;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 100, // Fixed height for lyrics container
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
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
                                                LightTextTheme
                                                    .semibold
                                                    .fontWeight,
                                          )
                                          : LightTextTheme.paragraph2.copyWith(
                                            color: Colors.white.withOpacity(
                                              0.5,
                                            ),
                                            fontSize: 16,
                                            height: 1.5,
                                            fontWeight: FontWeight.normal,
                                          ),
                                  child: Text(
                                    line,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ],
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
          _icon(ImageTheme.shareIcon),
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
              onChanged: (value) => setState(() => currentPosition = value),
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
}
