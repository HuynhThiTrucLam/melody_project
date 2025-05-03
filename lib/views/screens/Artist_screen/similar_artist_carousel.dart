import 'package:MELODY/data/models/BE/artist_data.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/views/screens/Artist_screen/artist_profile.dart';
import 'package:flutter/material.dart';

class SimilarArtistCarousel extends StatelessWidget {
  final String title;
  final List<ArtistData> artists;

  const SimilarArtistCarousel({
    super.key,
    required this.title,
    required this.artists,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: LightColorTheme.black,
          ),
        ),

        const SizedBox(height: 24),

        SizedBox(
          //height max content
          height: 160, // Slightly increased height to fix overflow
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: artists.length,
            // Add some padding to the left to align with title
            padding: const EdgeInsets.only(left: 0, right: 16),
            physics:
                const BouncingScrollPhysics(), // Adds bounce effect for better UX
            itemBuilder: (context, index) {
              final Artist = artists[index];
              // Fixed width for each item
              return Container(
                width: MediaQuery.of(context).size.width * 0.33,
                margin: const EdgeInsets.only(right: 16),
                child: ArtistCard(artistData: Artist),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ArtistCard extends StatelessWidget {
  final ArtistData artistData;

  const ArtistCard({super.key, required this.artistData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ArtistProfile(artistId: artistData.id),
          ),
        );
      },
      borderRadius: BorderRadius.circular(60), // Add a splash effect boundary
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width:
                MediaQuery.of(context).size.width * 0.22, // Responsive sizing
            height:
                MediaQuery.of(context).size.width * 0.22, // Same aspect ratio
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                artistData.avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: MediaQuery.of(context).size.width * 0.08,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 6),
          Column(
            children: [
              Text(
                artistData.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: LightColorTheme.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
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
                    artistData.comeFrom,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
