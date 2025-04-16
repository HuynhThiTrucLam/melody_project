import 'dart:async';
import 'dart:ui';
import 'package:MELODY/views/widgets/not_found/not_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:MELODY/data/models/UI/music_data.dart';
import 'package:MELODY/services/music_service.dart';
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
  bool isLyricsExpanded = false; // Add this line to track lyrics expanded state
  double currentPosition = 0.0;
  final MusicService _musicService = MusicService();

  // Full lyrics list (in a real app, this would come from a service or API)
  final List<String> fullLyrics = [
    'Hằng đêm anh nằm thao thức suy tư chẳng nhớ ai ngoài em đâu đâu',
    'Vậy nên không cần nói nữa yêu mà đôi lời nói trong vài ba câu',
    'Đêm nay sao em không đến thăm anh trong mơ',
    'Dù chỉ là phút giây thôi',
    'Mà nỗi nhớ cứ cuốn lấy trong tim anh',
    'Thôi em tồn tại như vậy thôi',
    'Dần dần thành thói quen',
    'Một khi anh đã mến',
    'Sẽ ở đó lâu bền',
    'Dù cho ta chẳng bước đi chung đường',
    'Ngày tháng cứ đi về phía trước',
    'Dù đời đôi lúc u buồn',
    'Có em còn cạnh anh luôn',
    'Niềm vui vơi đầy trong tim',
  ];

  @override
  void initState() {
    super.initState();
    songDetailFuture = _musicService.getMusicById(widget.musicId);
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _rotationController.dispose();
    super.dispose();
  }

  void startProgress(MusicData song) {
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentPosition < song.duration.inSeconds) {
        setState(() => currentPosition += 1);
      } else {
        timer.cancel();
        setState(() => isPlaying = false);
      }
    });
  }

  void stopProgress() => _progressTimer?.cancel();

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
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;

        return Scaffold(
          body: Stack(
            children: [
              _buildBackgroundImage(song.albumArt, screenHeight),
              _buildGradientOverlay(),
              _buildTopBar(),
              _buildRotatingDisc(song.albumArt, screenWidth),
              _buildLyrics(),
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

  Widget _buildLyrics() {
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 16.0,
                        ),
                        child: Column(
                          children: [
                            ...fullLyrics.map(
                              (line) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  line,
                                  textAlign: TextAlign.center,
                                  style: LightTextTheme.paragraph2.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
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
                    backgroundColor: LightColorTheme.mainColor,
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
                        color: Colors.white,
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
                    child: Column(
                      children: [
                        // Show first 4 lines from full lyrics for preview
                        ...fullLyrics
                            .take(4)
                            .map(
                              (line) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  line,
                                  textAlign: TextAlign.center,
                                  style: LightTextTheme.paragraph3.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nhấn để xem lời bài hát đầy đủ',
                  style: LightTextTheme.paragraph3.copyWith(
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
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
            const SizedBox(height: 16),
            _buildActionIcons(screenWidth),
            _buildSlider(song, screenWidth),
            const SizedBox(height: 30),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatTime(currentPosition.toInt()),
          style: LightTextTheme.paragraph3,
        ),
        SizedBox(
          width: 0.64 * screenWidth,
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
            onChanged: (value) => setState(() => currentPosition = value),
          ),
        ),
        Text(
          _formatTime(song.duration.inSeconds),
          style: LightTextTheme.paragraph3,
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  Widget _buildSongControls(MusicData song) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(ImageTheme.replayIcon, width: 30),
        SvgPicture.asset(ImageTheme.prevSongIcon, width: 30),
        GestureDetector(
          onTap: () {
            setState(() {
              isPlaying = !isPlaying;
              isPlaying ? startProgress(song) : stopProgress();
              isPlaying
                  ? _rotationController.repeat()
                  : _rotationController.stop();
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
        SvgPicture.asset(ImageTheme.nextSongIcon, width: 30),
        SvgPicture.asset(
          ImageTheme.libraryIcon,
          width: 30,
          color: LightColorTheme.black,
        ),
      ],
    );
  }
}
