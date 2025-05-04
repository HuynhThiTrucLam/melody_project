import 'package:MELODY/data/models/UI/block_data.dart';
import 'package:MELODY/data/models/UI/fiter_tab.dart';

class ArtistData {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isVerified;
  final int followers;
  final int listeners;
  final Filter comeFrom;
  bool isFollowed;
  final String? description;
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
    required this.isFollowed,
    this.description,
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
      comeFrom: Filter(code: 'usuk', name: 'US/UK'),
      isFollowed: true,
      songs: [
        BlockData(
          id: '1',
          name: 'Believer',
          subText: 'Imagine Dragons',
          listener: 20000000,
          avatarUrl:
              'https://i1.sndcdn.com/artworks-000570164507-8bew6z-t500x500.jpg',
          isVerified: true,
        ),
        BlockData(
          id: '2',
          name: 'Radioactive',
          subText: 'Imagine Dragons',
          listener: 18000000,
          avatarUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRohg4a3Qi8PCLAqt112qKhl1kocq0NzjtwPw&s',
          isVerified: true,
        ),
      ],
      albums: [
        BlockData(
          id: '3',
          name: 'Evolve',
          subText: 'Album • Imagine Dragons',
          listener: 5000000,
          avatarUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzSJhMBBueB_69bdpJ-q-PR9eS8ZRIJXmHzQ&s',
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
      comeFrom: Filter(code: 'vietnam', name: 'Vietnam'),
      isFollowed: true,
      description:
          'Sơn Tùng M-TP is a Vietnamese singer-songwriter and actor. He is known for his unique style and has a massive fan following in Vietnam and beyond. His music often blends pop, hip-hop, and R&B elements.',

      songs: [
        BlockData(
          id: '4',
          name: 'Hãy Trao Cho Anh',
          subText: 'Sơn Tùng M-TP',
          listener: 9000000,
          avatarUrl:
              'https://media-cdn-v2.laodong.vn/Storage/NewsPortal/2019/7/1/741911/Hay-Trao-Cho-Anh.jpg',
          isVerified: true,
        ),
        BlockData(
          id: '5',
          name: 'Chúng Ta Không Thuộc Về Nhau',
          subText: 'Sơn Tùng M-TP',
          listener: 7000000,
          avatarUrl:
              'https://avatar-ex-swe.nixcdn.com/mv/2016/08/04/c/e/1/9/1470277194346_640.jpg',
          isVerified: true,
        ),
      ],
      albums: [
        BlockData(
          id: '6',
          name: 'Đừng Làm Trái Tim Anh Đau',
          subText: 'Album • Sơn Tùng M-TP',
          listener: 3000000,
          avatarUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZZ_UkbdOdfppyfayhRU_0GOh4umJkXaAzYg&s',
          isVerified: true,
        ),
        BlockData(
          id: '7',
          name: 'Đừng Làm Trái Tim Anh Đau',
          subText: 'Album • Sơn Tùng M-TP',
          listener: 3000000,
          avatarUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZZ_UkbdOdfppyfayhRU_0GOh4umJkXaAzYg&s',
          isVerified: true,
        ),
        BlockData(
          id: '8',
          name: 'Đừng Làm Trái Tim Anh Đau',
          subText: 'Album • Sơn Tùng M-TP',
          listener: 3000000,
          avatarUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZZ_UkbdOdfppyfayhRU_0GOh4umJkXaAzYg&s',
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
      comeFrom: Filter(code: 'kpop', name: 'K-Pop'),
      isFollowed: false,
      songs: [
        BlockData(
          id: '9',
          name: 'Blueming',
          subText: 'IU',
          listener: 10000000,
          avatarUrl:
              'https://i.scdn.co/image/ab67616d0000b2735e24525aeb46e0e5e933bb64',
          isVerified: true,
        ),
        BlockData(
          id: '10',
          name: 'Celebrity',
          subText: 'IU',
          listener: 9500000,
          avatarUrl:
              'https://i.scdn.co/image/ab67616d0000b273f8c55b37b7fc84ef5b58e1c2',
          isVerified: true,
        ),
      ],
      albums: [
        BlockData(
          id: '5',
          name: 'LILAC',
          subText: 'Album • IU',
          listener: 4000000,
          avatarUrl:
              'https://i.scdn.co/image/ab67616d0000b273ac403e18a4c5a9de3486aeb3',
          isVerified: true,
        ),
      ],
    ),
  ];
}
