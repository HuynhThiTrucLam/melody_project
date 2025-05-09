import 'package:MELODY/auth/auth_service.dart';
import 'package:MELODY/data/models/BE/playlist_data.dart';
import 'package:MELODY/data/models/BE/music_data.dart';
import 'package:MELODY/data/models/UI/album_display.dart';
import 'package:MELODY/data/services/playlist_service.dart';
import 'package:MELODY/data/services/music_service.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/views/screens/Library_screen/create_playlist.dart';
import 'package:MELODY/views/widgets/component_block/component_block.dart';
import 'package:MELODY/views/widgets/custom_button/custom_button.dart';
import 'package:MELODY/views/widgets/music_list/music_item.dart';
import 'package:MELODY/views/widgets/tag_button/tag_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final PlaylistService _playlistService = PlaylistService();
  final MusicService _musicService = MusicService();
  final AuthService _authService = AuthService();
  List<dynamic> _items = [];
  bool _isLoading = true;
  String _activeTab = 'playlist'; // Default active tab

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the user ID from token
      final userInfo = await _authService.getUserTokenInfo();
      final userId =
          userInfo?['id'] ?? userInfo?['user_id'] ?? userInfo?['sub'];

      if (userId == null) {
        debugPrint('No user ID found in token');
        setState(() {
          _items = [];
          _isLoading = false;
        });
        return;
      }

      final playlists = await _playlistService.getPlaylists(userId);
      debugPrint('Loaded ${playlists.length} playlists');

      setState(() {
        _items = playlists;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading playlists: $e');
      setState(() {
        _items = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFavoriteSongs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // For demonstration, return empty list instead of mock data
      // final favoriteSongs = await _musicService.getFavoriteMusics();
      final List<MusicData> favoriteSongs = [];
      setState(() {
        _items = favoriteSongs;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading favorite songs: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFavoriteAlbums() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // This is a placeholder - in a real app, you'd call a service
      // final favoriteAlbums = await albumService.getFavoriteAlbums();
      final List<AlbumDisplay> favoriteAlbums = [];
      setState(() {
        _items = favoriteAlbums;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading favorite albums: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleTabChange(String tab) {
    if (tab == _activeTab) return;

    setState(() {
      _activeTab = tab;
    });

    switch (tab) {
      case 'playlist':
        _loadPlaylists();
        break;
      case 'favorites':
        _loadFavoriteSongs();
        break;
      case 'albums':
        _loadFavoriteAlbums();
        break;
    }
  }

  // Create a new function to handle playlist creation
  Future<void> _createPlaylist(String playlistName) async {
    try {
      // Get the user ID from token
      final userInfo = await _authService.getUserTokenInfo();
      final userId = userInfo?['user_id'];

      if (userId == null) {
        debugPrint('No user ID found in token');
        return;
      }

      final createdPlaylist = await _playlistService.createPlaylist(
        userId,
        playlistName,
        null, // No tracks for initial creation
      );

      if (createdPlaylist != null) {
        debugPrint('Playlist created successfully: ${createdPlaylist.name}');
        // Reload playlists to show the newly created one
        _loadPlaylists();
      } else {
        debugPrint('Failed to create playlist');
      }
    } catch (e) {
      debugPrint('Error in creating playlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildTab(),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTab() {
    return Row(
      children: [
        TagButton(
          label: 'Playlist',
          backgroundColor:
              _activeTab == 'playlist'
                  ? LightColorTheme.mainColor
                  : LightColorTheme.white,
          textColor:
              _activeTab == 'playlist' ? Colors.white : LightColorTheme.black,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          borderRadius: BorderRadius.circular(60),
          textSize: 14,
          fontWeight: 600,
          onClick: (_) => _handleTabChange('playlist'),
        ),
        SizedBox(width: 8),
        TagButton(
          label: 'Bài hát yêu thích',
          backgroundColor:
              _activeTab == 'favorites'
                  ? LightColorTheme.mainColor
                  : LightColorTheme.white,
          textColor:
              _activeTab == 'favorites' ? Colors.white : LightColorTheme.black,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          borderRadius: BorderRadius.circular(60),
          textSize: 14,
          onClick: (_) => _handleTabChange('favorites'),
        ),
        SizedBox(width: 10),
        TagButton(
          label: 'Albums',
          backgroundColor:
              _activeTab == 'albums'
                  ? LightColorTheme.mainColor
                  : LightColorTheme.white,
          textColor:
              _activeTab == 'albums' ? Colors.white : LightColorTheme.black,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          borderRadius: BorderRadius.circular(60),
          textSize: 14,
          onClick: (_) => _handleTabChange('albums'),
        ),
      ],
    );
  }

  Widget _buildContent() {
    Widget createPlaylistButton = GestureDetector(
      onTap: () {
        // Only show the dialog, don't pass the creation function
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return CreatePlaylistDialog(onCreatePlaylist: _createPlaylist);
          },
        );
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.075,
        margin: const EdgeInsets.only(top: 8, bottom: 16),
        decoration: BoxDecoration(
          color: LightColorTheme.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: LightColorTheme.mainColor,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'Tạo Playlist',
              style: TextStyle(
                color: LightColorTheme.mainColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    // If empty items with playlists tab, show only the create button
    if (_items.isEmpty) {
      if (_activeTab == 'playlist') {
        return createPlaylistButton;
      } else if (_activeTab == 'favorites') {
        return const Expanded(
          child: Center(child: Text('Không tìm thấy kết quả')),
        );
      } else {
        return const Expanded(
          child: Center(child: Text('Không tìm thấy kết quả')),
        );
      }
    }

    // Render items based on active tab
    if (_activeTab == 'playlist') {
      return Expanded(
        child: Column(
          children: [
            // Always show create playlist button for playlist tab
            createPlaylistButton,

            // Then show the list of playlists
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final playlist = _items[index] as PlaylistData;
                  final imageUrl =
                      playlist.imageUrl.isNotEmpty
                          ? playlist.imageUrl
                          : 'https://i.pinimg.com/736x/41/27/50/412750a66a2acf2bf9bca02120f17186.jpg';
                  final songCount = playlist.favoriteSongs.length;
                  final subtext = '$songCount bài hát';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: BlockItem(
                      id: playlist.id,
                      imageUrl: imageUrl,
                      title: playlist.name,
                      subtext: subtext,
                      shapeOfImage: 'square',
                      showButton: true,
                      onButtonPressed: () {
                        print('Navigate to playlist: ${playlist.id}');
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else if (_activeTab == 'favorites') {
      return Expanded(
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final song = _items[index] as MusicData;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: BlockItem(
                id: song.id,
                imageUrl: song.albumArt,
                title: song.name,
                subtext: song.artist,
                shapeOfImage: 'square',
                showButton: false,
                showPlayButton: true,
                onPlayPressed: () {
                  print('Play song: ${song.id}');
                },
              ),
            );
          },
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final album = _items[index] as AlbumDisplay;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: BlockItem(
                id: album.id,
                imageUrl: album.coverImage,
                title: album.title,
                subtext: album.artist,
                shapeOfImage: 'square',
                showButton: true,
                onButtonPressed: () {
                  print('View album: ${album.id}');
                },
              ),
            );
          },
        ),
      );
    }
  }
}
