import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/colors/app_colors.dart';
import 'package:movies_app/features/movies/ui/movie_details/movie_details_screen.dart';

class MovieCard extends StatelessWidget {
  final String imageUrl;
  final double rating;
  final int movieId;

  const MovieCard({
    Key? key,
    required this.imageUrl,
    required this.rating,
    required this.movieId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailsScreen(movieId: movieId)));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.star, color: AppColors.yellow, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
