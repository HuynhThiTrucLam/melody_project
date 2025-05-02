import 'package:MELODY/data/models/UI/block_data.dart';

class ArtistData {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isVerified;
  final int followers;
  final int listeners;
  final String comeFrom;
  final List<BlockData> songs;
  final List<BlockData> albums;

  ArtistData({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.isVerified,
    required this.followers,
    required this.listeners,
    required this.comeFrom,
    required this.songs,
    required this.albums,
  });
}

class ArtistDataList {
  static List<ArtistData> mockArtists = [
    ArtistData(
      id: '2',
      name: 'Imagine Dragons',
      avatarUrl:
          'https://images2.thanhnien.vn/528068263637045248/2024/12/6/5-17334500783841194703426.jpeg',
      isVerified: true,
      followers: 12000000,
      listeners: 22000000,
      comeFrom: 'USA',
      songs: [
        BlockData(
          name: 'Believer',
          subText: 'Imagine Dragons',
          listener: '20000000',
          avatarUrl:
              'https://i.scdn.co/image/ab67616d0000b273b8e93a4f4372a81332927d47',
          isVerified: true,
        ),
        BlockData(
          name: 'Radioactive',
          subText: 'Imagine Dragons',
          listener: '18000000',
          avatarUrl:
              'https://i.scdn.co/image/ab67616d0000b2738e8a089a1bb24d4a5a1eb9a4',
          isVerified: true,
        ),
      ],
      albums: [
        BlockData(
          name: 'Evolve',
          subText: 'Album • Imagine Dragons',
          listener: '5000000',
          avatarUrl:
              'https://i.scdn.co/image/ab67616d0000b273f3d26e284b1d95e51211e418',
          isVerified: true,
        ),
      ],
    ),
    ArtistData(
      id: '3',
      name: 'Sơn Tùng M-TP',
      avatarUrl:
          'https://cdn2.tuoitre.vn/thumb_w/480/471584752817336320/2024/6/9/screenshot13-1717903327600897377640.jpg',
      isVerified: true,
      followers: 7500000,
      listeners: 12000000,
      comeFrom: 'Vietnam',
      songs: [
        BlockData(
          name: 'Hãy Trao Cho Anh',
          subText: 'Sơn Tùng M-TP',
          listener: '9000000',
          avatarUrl:
              'https://i.scdn.co/image/ab67616d0000b27354b85f71e89c7c6a343e4223',
          isVerified: true,
        ),
        BlockData(
          name: 'Chúng Ta Không Thuộc Về Nhau',
          subText: 'Sơn Tùng M-TP',
          listener: '7000000',
          avatarUrl:
              'https://i.scdn.co/image/ab67616d0000b273a0ccdfb7c52d194ce49b7650',
          isVerified: true,
        ),
      ],
      albums: [
        BlockData(
          name: 'M-TP M-TP',
          subText: 'Album • Sơn Tùng M-TP',
          listener: '3000000',
          avatarUrl:
              'https://i.scdn.co/image/ab67616d0000b273116993bc3a28b3e3644e84c7',
          isVerified: true,
        ),
      ],
    ),

    ArtistData(
      id: '4',
      name: 'IU',
      avatarUrl:
          'https://encrypted-tbn0.gstatic.com/licensed-image?q=tbn:ANd9GcQkYHvFuEJ2R5wCHkMLqh2Z3_qddB-R73IAexR5J59UBWRWmSqXgjwj1VtLbr61JaQ8tzbY2tiEhixx4qo',
      isVerified: true,
      followers: 8900000,
      listeners: 14500000,
      comeFrom: 'South Korea',
      songs: [
        BlockData(
          name: 'Blueming',
          subText: 'IU',
          listener: '10000000',
          avatarUrl:
              'https://i.scdn.co/image/ab67616d0000b2735e24525aeb46e0e5e933bb64',
          isVerified: true,
        ),
        BlockData(
          name: 'Celebrity',
          subText: 'IU',
          listener: '9500000',
          avatarUrl:
              'https://i.scdn.co/image/ab67616d0000b273f8c55b37b7fc84ef5b58e1c2',
          isVerified: true,
        ),
      ],
      albums: [
        BlockData(
          name: 'LILAC',
          subText: 'Album • IU',
          listener: '4000000',
          avatarUrl:
              'https://i.scdn.co/image/ab67616d0000b273ac403e18a4c5a9de3486aeb3',
          isVerified: true,
        ),
      ],
    ),
  ];
}
