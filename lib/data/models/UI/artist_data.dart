class ArtistData {
  final String id;
  final String name;
  final String avatarUrl;
  final int followers;
  final bool isVerified;

  ArtistData({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.isVerified,
    required this.followers,
  });
}

final List<ArtistData> mockArtists = [
  ArtistData(
    id: '1',
    name: 'Ariana Grande',
    avatarUrl:
        'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcSvkfVc3qX1xVVO0Yu5Vi9L_v5aGy_tZon8uORJ9fetFaOTzdxsavRWhNAnZ2-yhcI2l045q1pM0zKrdInDEZQUow',
    isVerified: true,
    followers: 9845212,
  ),
  ArtistData(
    id: '2',
    name: 'The Weeknd',
    avatarUrl:
        'https://i.scdn.co/image/ab6761610000e5eb1c7c4dbfda2fbc4caa51c3f2',
    isVerified: true,
    followers: 15023211,
  ),
  ArtistData(
    id: '3',
    name: 'Billie Eilish',
    avatarUrl:
        'https://i.scdn.co/image/ab6761610000e5ebf7d13c749b640d50edcd9a7e',
    isVerified: true,
    followers: 13288945,
  ),
  ArtistData(
    id: '4',
    name: 'Drake',
    avatarUrl:
        'https://i.scdn.co/image/ab6761610000e5ebf81a0e8a60c59f9c02db43c4',
    isVerified: true,
    followers: 21345235,
  ),
  ArtistData(
    id: '5',
    name: 'Doja Cat',
    avatarUrl:
        'https://i.scdn.co/image/ab6761610000e5eb8a123abc123abcd456ef9876',
    isVerified: true,
    followers: 8765432,
  ),
  ArtistData(
    id: '6',
    name: 'Bruno Mars',
    avatarUrl:
        'https://i.scdn.co/image/ab6761610000e5eb7a8e4e4c12cd0cbad8b71fc5',
    isVerified: true,
    followers: 10293847,
  ),
];
