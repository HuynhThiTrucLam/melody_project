import 'package:MELODY/core/utils/music_list_utils/number_format_helper.dart';
import 'package:MELODY/data/models/BE/album_data.dart';
import 'package:MELODY/data/services/album_service.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Artist_detail_screen/songs_carousel.dart';
import 'package:MELODY/views/screens/Notification_screen/notification_screen.dart';
import 'package:MELODY/views/widgets/custom_button/custom_button.dart';
import 'package:MELODY/views/widgets/custom_button/goBack_button.dart';
import 'package:MELODY/views/widgets/notification/notification_button.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class AlbumDetail extends StatefulWidget {
  final String albumId;
  const AlbumDetail({super.key, required this.albumId});

  @override
  State<AlbumDetail> createState() => _AlbumDetailState();
}

class _AlbumDetailState extends State<AlbumDetail> {
  final AlbumService _albumService = AlbumService();
  late Future<AlbumData> _albumDataFuture;

  @override
  void initState() {
    super.initState();
    _albumDataFuture = _albumService.getAlbumbyID(widget.albumId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<AlbumData>(
        future: _albumDataFuture,
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: Colors.black.withOpacity(0.6),
              body: Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            );
          }

          // Handle error state
          if (snapshot.hasError || snapshot.data == null) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: Text('Error loading album details')),
            );
          }

          // If we have data, proceed normally
          final album = snapshot.data!;

          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              fit: StackFit.expand, // Make stack take full space
              children: [
                // Background Image
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: _buildBackgroundImage(album.coverImage),
                ),
                _buildTopBar(),
                _buildBottomDetailContainer(
                  album,
                  MediaQuery.of(context).size.width,
                ),
              ],
            ),
          );
        },
      ),
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
                color: Colors.green,
              ),
            );
          },
          errorBuilder: (_, error, __) {
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

  Widget _buildBottomDetailContainer(AlbumData album, double screenWidth) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.height * 0.4,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                // boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),

                    // Album cover with badge
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green, width: 2),
                        image: DecorationImage(
                          image: NetworkImage(album.coverImage),
                          fit: BoxFit.cover,
                          onError:
                              (exception, stackTrace) => const AssetImage(
                                'assets/images/default_avatar.png',
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Album name
                    Text(
                      album.title,
                      style: LightTextTheme.headding2.copyWith(
                        fontSize: 22,
                        color: LightColorTheme.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Album artist name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 2),
                        Text(
                          album.region.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    // Stats
                    const SizedBox(height: 24),
                    _buildStatsRow(album),

                    // Action buttons
                    const SizedBox(height: 30),
                    _buildActionButtons(album),

                    // About section
                    const SizedBox(height: 32),
                    _buildAboutSection(album),

                    const SizedBox(height: 32),
                    // List of songs
                    _buildPopularSongsSection(album),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(AlbumData album) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Align items to both ends
      children: [
        // Artist
        Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                album.artistImage,
              ), // assuming album.artistImage exists
              radius: 20,
            ),
            const SizedBox(width: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  album.artist,
                  style: LightTextTheme.headding3.copyWith(
                    fontSize: 16,
                    color: LightColorTheme.black,
                    fontWeight: LightTextTheme.semibold.fontWeight,
                  ),
                ),
                Text(
                  'Nghệ sĩ',
                  style: LightTextTheme.paragraph2.copyWith(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),

        // Divider
        Container(height: 40, width: 1, color: Colors.grey[300]),

        // Listeners
        Column(
          children: [
            Text(
              formatListenerCount(album.totalListens),
              style: LightTextTheme.headding3.copyWith(
                fontSize: 16,
                color: LightColorTheme.black,
                fontWeight: LightTextTheme.semibold.fontWeight,
              ),
            ),
            Text(
              'Lượt nghe',
              style: LightTextTheme.paragraph2.copyWith(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),

        // Divider
        Container(height: 40, width: 1, color: Colors.grey[300]),

        // Listeners
        Column(
          children: [
            Text(
              formatListenerCount(album.totalListens),
              style: LightTextTheme.headding3.copyWith(
                fontSize: 16,
                color: LightColorTheme.black,
                fontWeight: LightTextTheme.semibold.fontWeight,
              ),
            ),
            Text(
              'Lượt nghe',
              style: LightTextTheme.paragraph2.copyWith(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(AlbumData album) {
    return Center(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              // print("Share button pressed");

              // Customize the share message
              final shareMessage =
                  'Check out this album: "${album.title}" by ${album.artist}. '
                  'Listen to it now: ${album.coverImage}';

              // Share the message
              Share.share(shareMessage, subject: 'Album Details');
              // print("Share button pressed 2");
            },
            icon: Icon(Icons.share, color: LightColorTheme.black, size: 24),
          ),
          SizedBox(width: 8),
          Expanded(
            child: CustomButton(
              hintText: "Phát Albums",
              isPrimary: true,
              onPressed: () {},
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite, color: LightColorTheme.black, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(AlbumData artist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin chi tiết',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: LightColorTheme.black,
          ),
        ),
        const SizedBox(height: 16),
        // Song count
        Row(
          children: [
            Text(
              "Số lượng bài hát: ",
              style: TextStyle(
                fontSize: 14,
                fontWeight: LightTextTheme.semibold.fontWeight,
                color: LightColorTheme.grey,
              ),
            ),
            Text(
              artist.songCount.toString(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Release date
        Row(
          children: [
            Text(
              "Ngày phát hành: ",
              style: TextStyle(
                fontSize: 14,
                fontWeight: LightTextTheme.semibold.fontWeight,
                color: LightColorTheme.grey,
              ),
            ),
            Text(
              artist.releaseDate,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        const SizedBox(height: 8),
        Text(
          artist.description ?? 'Chưa có thông tin',
          style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildPopularSongsSection(AlbumData album) {
    return SongsCarousel(title: "Danh sách bài hát", songs: album.songs);
  }
}
