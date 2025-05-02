import 'package:MELODY/data/models/BE/artist_data.dart';
import 'package:MELODY/data/services/artist_service.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Notification_screen/notification_screen.dart';
import 'package:MELODY/views/widgets/custom_button/goBack_button.dart';
import 'package:MELODY/views/widgets/not_found/not_found.dart';
import 'package:MELODY/views/widgets/notification/notification_button.dart';
import 'package:MELODY/views/widgets/top_bar/top_bar.dart';
import 'package:flutter/material.dart';

class ArtistProfile extends StatefulWidget {
  final String artistId;
  const ArtistProfile({super.key, required this.artistId});

  @override
  State<ArtistProfile> createState() => _ArtistProfileState();
}

class _ArtistProfileState extends State<ArtistProfile> {
  final ArtistService _musicService = ArtistService();
  late Future<ArtistData> artistProfilelFuture;

  @override
  void initState() {
    super.initState();
    // Fetch artist data when the widget is initialized
    artistProfilelFuture = _musicService.getArtistById(widget.artistId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ArtistData>(
      future: artistProfilelFuture,
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
          print("Error loading artist: ${snapshot.error}");
          return NotFound(
            title: 'Không tìm thấy bài hát',
            message: 'Có lỗi xảy ra khi tải bài hát này.',
          );
        }

        // If we have data, proceed normally
        final artist = snapshot.data!;
        print("Artist loaded: ${artist.name}, avatar: ${artist.avatarUrl}");

        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: Stack(
              fit: StackFit.expand, // Make stack take full space
              children: [
                // Background color in case image fails
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: screenHeight * 0.7,
                  child: Container(color: Colors.grey[200]),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: screenHeight * 0.7,
                  child: _buildBackgroundImage(artist.avatarUrl),
                ),
                _buildTopBar(),
                _buildBottomDetailContainer(artist, screenWidth),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackgroundImage(String albumArt) {
    return albumArt.isNotEmpty
        ? Image.network(
          albumArt,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                color: LightColorTheme.mainColor,
              ),
            );
          },
          errorBuilder: (_, error, __) {
            print("Error loading image: $error");
            return Container(
              color: Colors.grey[400],
              child: Center(
                child: Icon(Icons.broken_image, size: 50, color: Colors.white),
              ),
            );
          },
        )
        : Center(
          child: Icon(Icons.image_not_supported, size: 50, color: Colors.white),
        );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget _buildBottomDetailContainer(ArtistData artist, double screenWidth) {
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
              artist.name,
              style: LightTextTheme.headding2.copyWith(
                fontSize: 22,
                color: LightColorTheme.black,
              ),
            ),
            const SizedBox(height: 4),
            Text('Ca sĩ: ${artist.name}', style: LightTextTheme.paragraph3),
            // const SizedBox(height: 20),
            // _buildActionIcons(screenWidth),
            // _buildSlider(artist, screenWidth),
            // const SizedBox(height: 24),
            // _buildartistControls(song),
          ],
        ),
      ),
    );
  }
}
