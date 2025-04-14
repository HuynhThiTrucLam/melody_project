import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:MELODY/data/models/UI/music_data.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Notification_screen/notification_screen.dart';
import 'package:MELODY/views/widgets/custom_button/goBack_button.dart';
import 'package:MELODY/views/widgets/notification/notification_button.dart';

class MockSongDetailService {
  static Future<MusicData> getSongDetail(String songId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return MusicData(
      id: '1',
      name: 'Đừng làm trái tim anh đau',
      artist: 'Sơn Tùng M-TP',
      albumArt: 'https://i.ytimg.com/vi/7u4g483WTzw/hq720.jpg',
      audioUrl: 'https://example.com/audio/dung_lam_trai_tim_anh_dau.mp3',
      lyrics: 'Thấy thế thôi vui hơn có quà...',
      duration: Duration(minutes: 3, seconds: 20),
      listener: 1580000,
      isFavorite: true,
      genre: 'Synthwave',
      releaseDate: DateTime(2020, 11, 29),
    );
  }
}

class DetailSong extends StatefulWidget {
  final String songId;
  const DetailSong({super.key, required this.songId});

  @override
  State<DetailSong> createState() => _DetailSongState();
}

class _DetailSongState extends State<DetailSong>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Future<MusicData> songDetailFuture;
  Timer? _progressTimer;
  bool isPlaying = false;
  double currentPosition = 0.0;

  @override
  void initState() {
    super.initState();
    songDetailFuture = MockSongDetailService.getSongDetail(widget.songId);
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
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

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
              _buildBottomDetailContainer(song, screenWidth),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackgroundImage(String albumArt, double height) {
    return Image.network(
      albumArt,
      height: 0.7 * height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder:
          (_, __, ___) => Container(height: 250, color: Colors.grey[300]),
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
          colors: [Colors.black.withOpacity(0.5), Colors.transparent],
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
    final lyrics = [
      'Hằng đêm anh nằm thao thức suy tư chẳng nhớ ai ngoài em đâu đâu',
      'Vậy nên không cần nói nữa yêu mà đôi lời nói trong vài ba câu',
    ];
    return Positioned(
      top: 400,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children:
              lyrics
                  .map(
                    (line) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        line,
                        textAlign: TextAlign.center,
                        style: LightTextTheme.paragraph3.copyWith(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.7),
                              blurRadius: 6,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
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
