import 'package:MELODY/auth/auth_service.dart';
import 'package:MELODY/data/models/BE/playlist_data.dart';
import 'package:MELODY/data/services/playlist_service.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Library_screen/create_playlist.dart';
import 'package:MELODY/views/widgets/artist_list/artist_item.dart';
import 'package:flutter/material.dart';

class LibraryTab extends StatefulWidget {
  final String? name;
  final String? imageUrl;
  final String? singer;
  final String musicId; // The ID of the music to add to playlist

  const LibraryTab({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.singer,
    required this.musicId,
  });

  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  final PlaylistService playlistService = PlaylistService();
  List<PlaylistData> playlists = [];
  final AuthService authService = AuthService();
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final tokenInfo = await authService.getUserTokenInfo();
      final userId =
          tokenInfo?['user_id'] ?? tokenInfo?['id'] ?? tokenInfo?['sub'];

      if (userId == null) {
        setState(() {
          _error = "Không thể xác thực người dùng";
          _isLoading = false;
        });
        return;
      }

      final loadedPlaylists = await playlistService.getPlaylists(userId);

      if (mounted) {
        setState(() {
          playlists = loadedPlaylists;
          _isLoading = false;
        });
      }

      debugPrint('Loaded ${playlists.length} playlists');
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = "Đã xảy ra lỗi khi tải danh sách playlist";
          _isLoading = false;
        });
      }
      debugPrint('Error loading playlists: $e');
    }
  }

  Future<void> _handleAddToPlaylist(PlaylistData playlist) async {
    try {
      final result = await playlistService.addTrackToPlaylist(
        playlist.id,
        widget.musicId,
      );

      // Close the bottom sheet first
      Navigator.pop(context);

      if (result == 200) {
        // Show success message
        _showCustomAlert(
          'Thành công',
          'Đã thêm bài hát vào "${playlist.name}"',
          LightColorTheme.mainColor,
        );
      } else if (result == 400) {
        // Show alert for track already exists in playlist
        _showCustomAlert(
          'Thông báo',
          'Bài hát đã tồn tại trong playlist này',
          Colors.orange,
        );
      } else if (result == 500) {
        // Show server error message
        _showCustomAlert('Lỗi', 'Đã xảy ra lỗi máy chủ', Colors.red);
      } else {
        // Handle other status codes
        _showCustomAlert(
          'Lỗi',
          'Không thể thêm bài hát: Lỗi không xác định',
          Colors.red,
        );
      }
    } catch (e) {
      // Close the bottom sheet
      Navigator.pop(context);

      // Handle exceptions
      _showCustomAlert(
        'Lỗi',
        'Không thể thêm bài hát: ${e.toString()}',
        Colors.red,
      );
    }
  }

  void _showCustomAlert(String title, String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          content: Text(message),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCreatePlaylistDialog() {
    showDialog(
      context: context,
      builder:
          (context) => CreatePlaylistDialog(
            onCreatePlaylist: (name) async {
              Navigator.pop(context); // Close dialog

              final tokenInfo = await authService.getUserTokenInfo();
              final userId =
                  tokenInfo?['user_id'] ??
                  tokenInfo?['id'] ??
                  tokenInfo?['sub'];

              if (userId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Không thể xác thực người dùng'),
                  ),
                );
                return;
              }

              try {
                final playlist = await playlistService.createPlaylist(
                  userId,
                  name,
                  [widget.musicId], // Add current song to the new playlist
                );

                if (playlist != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Đã tạo playlist "${name}" và thêm bài hát',
                      ),
                      backgroundColor: LightColorTheme.mainColor,
                    ),
                  );

                  Navigator.pop(context); // Close bottom sheet

                  // Reload playlists (if you keep the sheet open)
                  // _loadPlaylists();
                }
              } catch (e) {
                debugPrint('Error creating playlist: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xảy ra lỗi khi tạo playlist'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Currently playing song
          Text("Đang phát", style: LightTextTheme.headding3),
          const SizedBox(height: 8),
          ArtistItem(
            itemType: ItemType.song,
            name: widget.name ?? "Unknown Artist",
            subText: widget.singer ?? "Unknown Singer",
            avatarUrl: widget.imageUrl,
            isVerified: true,
          ),

          const SizedBox(height: 24),

          // Playlist section header with create button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Thêm bài hát vào Playlist",
                style: LightTextTheme.headding3,
              ),
              TextButton(
                onPressed: _showCreatePlaylistDialog,
                child: Text(
                  "Tạo mới",
                  style: TextStyle(
                    color: LightColorTheme.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Playlist list
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                    ? Center(child: Text(_error!))
                    : playlists.isEmpty
                    ? _buildEmptyState()
                    : _buildPlaylistList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Bạn chưa có playlist nào",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _showCreatePlaylistDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: LightColorTheme.mainColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("Tạo playlist mới"),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistList() {
    return RawScrollbar(
      thumbColor: LightColorTheme.grey.withOpacity(0.2),
      radius: const Radius.circular(20),
      thickness: 2,
      thumbVisibility: true,
      child: ListView.builder(
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return InkWell(
            onTap: () => _handleAddToPlaylist(playlist),
            child: ArtistItem(
              itemType: ItemType.playlist,
              name: playlist.name,
              subText: playlist.favoriteSongs.length.toString(),
              avatarUrl: playlist.imageUrl,
              isVerified: false,
            ),
          );
        },
      ),
    );
  }
}
