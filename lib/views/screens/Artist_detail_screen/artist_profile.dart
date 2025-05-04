import 'package:MELODY/core/utils/music_list_utils/number_format_helper.dart';
import 'package:MELODY/data/models/BE/artist_data.dart';
import 'package:MELODY/data/services/artist_service.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Artist_detail_screen/albums_carousel.dart';
import 'package:MELODY/views/screens/Artist_detail_screen/similar_artist_carousel.dart';
import 'package:MELODY/views/screens/Artist_detail_screen/songs_carousel.dart';
import 'package:MELODY/views/screens/Notification_screen/notification_screen.dart';
import 'package:MELODY/views/widgets/custom_button/custom_button.dart';
import 'package:MELODY/views/widgets/custom_button/goBack_button.dart';
import 'package:MELODY/views/widgets/not_found/not_found.dart';
import 'package:MELODY/views/widgets/notification/notification_button.dart';
import 'package:flutter/material.dart';

class ArtistProfile extends StatefulWidget {
  final String artistId;
  const ArtistProfile({super.key, required this.artistId});

  @override
  State<ArtistProfile> createState() => _ArtistProfileState();
}

class _ArtistProfileState extends State<ArtistProfile> {
  final ArtistService _artistService = ArtistService();
  late Future<ArtistData> artistProfilelFuture;
  late Future<List<ArtistData>> artistsSimilarlFuture;
  //
  @override
  void initState() {
    super.initState();
    // Fetch artist data when the widget is initialized
    artistProfilelFuture = _artistService.getArtistById(widget.artistId);
    artistsSimilarlFuture = _artistService.getSimilarArtists(widget.artistId);
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: screenHeight * 0.6, // Make it a bit taller to allow more content
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          // You can add scroll animations or effects here if needed
          return false;
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),

                      // Artist avatar with badge
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // Avatar
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: LightColorTheme.mainColor,
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(artist.avatarUrl),
                                fit: BoxFit.cover,
                                onError:
                                    (exception, stackTrace) => const AssetImage(
                                      'assets/images/default_avatar.png',
                                    ),
                              ),
                            ),
                          ),
                          // Badge
                          Positioned(
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: LightColorTheme.mainColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Singer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Artist name
                      Text(
                        artist.name,
                        style: LightTextTheme.headding2.copyWith(
                          fontSize: 22,
                          color: LightColorTheme.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Artist location
                      const SizedBox(height: 6),
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
                            artist.comeFrom.name,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                      // Stats
                      const SizedBox(height: 24),
                      _buildStatsRow(artist),

                      // Action buttons
                      const SizedBox(height: 24),
                      _buildActionButtons(
                        artist,
                      ), // Pass the artist parameter here
                      // Additional section to demonstrate scrolling
                      if (artist.description != null) ...[
                        const SizedBox(height: 32),
                        _buildAboutSection(artist),
                      ],

                      // Additional artist content - sample sections
                      if (artist.songs.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        _buildPopularSongsSection(artist),
                      ],

                      // Show albums section only if the artist has albums
                      if (artist.albums.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        _buildAlbumsSection(artist),
                      ],
                    ],
                  ),
                ),
              ),

              Container(
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      // _buildDiscographySection(artist),
                      // const SizedBox(height: 32),
                      _buildSimilarArtistsSection(),
                      const SizedBox(height: 60), // Extra padding at the bottom
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

  Widget _buildStatsRow(ArtistData artist) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Songs count
        Column(
          children: [
            Text(
              formatListenerCount(artist.albums.length),
              style: LightTextTheme.headding3,
            ),
            Text(
              'Bài hát',
              style: LightTextTheme.paragraph2.copyWith(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),

        // Divider
        Container(height: 40, width: 1, color: Colors.grey[300]),

        // Followers
        Column(
          children: [
            Text(
              formatListenerCount(artist.followers),
              style: LightTextTheme.headding3,
            ),
            Text(
              'Lượt theo dõi',
              style: LightTextTheme.paragraph2.copyWith(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),

        // Divider
        Container(height: 40, width: 1, color: Colors.grey[300]),

        // Listens
        Column(
          children: [
            Text(
              formatListenerCount(artist.listeners),
              style: LightTextTheme.headding3,
            ),
            Text(
              'Lượt nghe',
              style: LightTextTheme.paragraph2.copyWith(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(ArtistData artist) {
    return Row(
      children: [
        // Follow button
        Expanded(
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(right: 8),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: LightColorTheme.mainColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                // backgroundColor:
                //     artist.isFollowed == true
                //         ? LightColorTheme.mainColor.withOpacity(0.1)
                //         : Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    artist.isFollowed == 'true' ? 'Đang theo dõi' : 'Theo dõi',
                    style: LightTextTheme.bold.copyWith(
                      color: LightColorTheme.mainColor,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Play Playlist button
        Expanded(
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(left: 8),
            child: CustomButton(
              hintText: 'Phát playlist',
              isPrimary: true,
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  // Sample additional content sections
  Widget _buildPopularSongsSection(ArtistData artist) {
    return SongsCarousel(title: "Bài hát nổi bật", songs: artist.songs);
  }

  Widget _buildAlbumsSection(ArtistData artist) {
    return AlbumCarousel(title: "Danh sách Albums", albums: artist.albums);
  }

  Widget _buildAboutSection(ArtistData artist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Về nghệ sĩ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: LightColorTheme.black,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          artist.description ?? 'Chưa có thông tin',
          style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildSimilarArtistsSection() {
    return FutureBuilder<List<ArtistData>>(
      future: artistsSimilarlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: LightColorTheme.mainColor),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Text(
            'Không tìm thấy nghệ sĩ tương tự',
            style: TextStyle(color: Colors.grey),
          );
        }

        return SimilarArtistCarousel(
          title: "Nghệ sĩ tương tự",
          artists: snapshot.data!,
        );
      },
    );
  }
}
