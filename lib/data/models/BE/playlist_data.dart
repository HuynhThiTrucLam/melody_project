import 'package:MELODY/data/models/BE/album_data.dart';
import 'package:MELODY/data/models/BE/artist_data.dart';
import 'package:MELODY/data/models/UI/album_display.dart';
import 'package:MELODY/data/models/UI/artist_display.dart';
import 'package:MELODY/data/models/UI/music_display.dart';
import 'package:flutter/foundation.dart';

class UserInfo {
  final String id;
  final String username;
  final String email;
  final String? name;
  final String? picture;
  final String createdAt;
  final String updatedAt;

  UserInfo({
    required this.id,
    required this.username,
    required this.email,
    this.name,
    this.picture,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      picture: json['picture'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class PlaylistData {
  final String id;
  final String name;
  final String imageUrl;
  final List<MusicDisplay> favoriteSongs;
  final List<AlbumDisplay> favoriteAlbums;
  final List<ArtistDisplay> favoriteArtists;
  final UserInfo? user;
  final String? createdAt;
  final String? updatedAt;

  PlaylistData({
    required this.id,
    required this.name,
    this.imageUrl = '',
    required this.favoriteSongs,
    this.favoriteAlbums = const [],
    this.favoriteArtists = const [],
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  // Map from json to PlaylistData
  //   [
  //   {
  //     "id": "681e1fe5914030154d4dbef9",
  //     "name": "Mplylist",
  //     "image": null,
  //     "tracks": null,
  //     "user": {
  //       "id": "681d86b0faa78c6bcc336411",
  //       "username": "congsinh",
  //       "email": "sinh@melody.com",
  //       "name": null,
  //       "picture": null,
  //       "created_at": "2025-05-09T04:38:08.708000",
  //       "updated_at": "2025-05-09T04:38:08.708000"
  //     },
  //     "created_at": "2025-05-09T15:31:49.682000",
  //     "updated_at": "2025-05-09T15:31:49.682000"
  //   }
  // ]
  factory PlaylistData.fromJson(Map<String, dynamic> json) {
    debugPrint('PlaylistData.fromJson: $json');

    // Handle different image field names
    String imageUrl = '';
    if (json['image'] != null) {
      imageUrl = json['image'].toString();
    }

    // Handle tracks field which may be null or empty
    List<MusicDisplay> tracks = [];
    if (json['tracks'] != null && json['tracks'] is List) {
      try {
        tracks = List<MusicDisplay>.from(
          json['tracks'].map((x) => MusicDisplay.fromJson(x)),
        );
      } catch (e) {
        debugPrint('Error parsing tracks: $e');
      }
    }

    // Parse user data if available
    UserInfo? userInfo;
    if (json['user'] != null && json['user'] is Map<String, dynamic>) {
      try {
        userInfo = UserInfo.fromJson(json['user']);
      } catch (e) {
        debugPrint('Error parsing user info: $e');
      }
    }

    return PlaylistData(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unnamed Playlist',
      imageUrl: imageUrl,
      favoriteSongs: tracks,
      favoriteAlbums:
          json['favorite_albums'] != null
              ? List<AlbumDisplay>.from(
                json['favorite_albums'].map((x) => AlbumDisplay.fromJson(x)),
              )
              : [],
      favoriteArtists:
          json['favorite_artists'] != null
              ? List<ArtistDisplay>.from(
                json['favorite_artists'].map((x) => ArtistDisplay.fromJson(x)),
              )
              : [],
      user: userInfo,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

final List<String> albumBackground = [
  'https://i.pinimg.com/736x/41/27/50/412750a66a2acf2bf9bca02120f17186.jpg',
  'https://i.pinimg.com/736x/a3/54/b3/a354b30dc6c3200d52c947aa785a5e49.jpg',
  'https://i.pinimg.com/736x/62/85/a3/6285a33df275eed23bb0e1b4eb310f36.jpg',
];

// mock data
final List<PlaylistData> playlistData = [
  // PlaylistData(
  //   id: '1',
  //   name: 'Favorite Songs',
  //   imageUrl: '',
  //   favoriteSongs: [],
  //   favoriteAlbums: [],
  // ),
  // PlaylistData(
  //   id: '2',
  //   name: 'HIEUTHUHAI',
  //   imageUrl: '',
  //   favoriteSongs: [
  //     MusicDisplay(
  //       id: '1',
  //       title: 'Song 1',
  //       artists: 'Artist 1',
  //       imageUrl: albumBackground[0],
  //       rank: '1',
  //       listener: 100,
  //     ),
  //     MusicDisplay(
  //       id: '2',
  //       title: 'Song 2',
  //       artists: 'Artist 2',
  //       imageUrl: albumBackground[1],
  //       rank: '2',
  //       listener: 200,
  //     ),
  //   ],
  //   favoriteAlbums: [
  //     AlbumDisplay(
  //       id: '1',
  //       title: 'Album 1',
  //       artist: 'Artist 1',
  //       coverImage: albumBackground[0],
  //       songCount: 10,
  //       releaseDate: '2021-01-01',
  //     ),
  //   ],
  // ),
];
