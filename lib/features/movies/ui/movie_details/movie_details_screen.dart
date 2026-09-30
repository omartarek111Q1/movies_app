import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/utils/assets/app_assets.dart';
import 'package:movies_app/core/utils/build_context_extensions.dart';
import 'package:movies_app/core/utils/colors/app_colors.dart';
import 'package:movies_app/core/widgets/custom_btn.dart';
import 'package:movies_app/features/movies/ui/movie_details/cubit/movie_details_cubit.dart';
import 'package:movies_app/features/movies/ui/movie_details/cubit/movie_details_state.dart';
import 'package:movies_app/injection_container.dart';

import '../browse/browse_screen.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;
  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MovieDetailsCubit>()..fetchScreenData(movieId),
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
          builder: (context, state) {
            if (state.movieDetails.isLoading || state.movieDetails.isInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.red),
              );
            }

            if (state.movieDetails.isError) {
              return Center(
                child: Text(
                  state.movieDetails.errorMessage ?? "Error loading movie",
                  style: const TextStyle(color: AppColors.white),
                ),
              );
            }

            final movie = state.movieDetails.data;
            if (movie == null) {
              return const Center(
                child: Text(
                  "No data",
                  style: TextStyle(color: AppColors.white),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Image
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        movie.image,
                        width: double.infinity,
                        height: context.height * 0.55,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: context.height * 0.55,
                          color: AppColors.gray,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: context.height * 0.55,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black54,
                              AppColors.black,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            // stops: [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                      Image.asset(AppAssets.watch),
                      Positioned(
                        top: 40,
                        left: 16,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        right: 16,
                        child: Row(
                          children: [
                            IconButton(
                              icon:  Icon(
                                state.isFavorite ? Icons.favorite : Icons.favorite_border,
                                color:  state.isFavorite ? AppColors.yellow : AppColors.white,
                              ),
                              onPressed: () {
                                context.read<MovieDetailsCubit>().toggleFavorite();
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                state.isBookMarked ? Icons.bookmark : Icons.bookmark_border,
                                color: AppColors.white,
                              ),
                              onPressed: () {
                                context.read<MovieDetailsCubit>().toggleBookmark();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Title and Year
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Text(
                          movie.title,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie.year.toString(),
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.7),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Watch Button
                        CustomBtn(
                          inColor: AppColors.red,
                          title: 'Watch',
                          titleColor: AppColors.white,
                          borderColor: Colors.transparent,
                          onTap: () {
                            _showWatchDialog(context);
                          },
                        ),
                        const SizedBox(height: 16),

                        // Stats Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: _buildStatChip(
                                Icons.favorite,
                                AppColors.yellow,
                                state.favoriteCount.toString(),
                              ),
                            ),
                            SizedBox(width: 8,),
                            Expanded(
                              child: _buildStatChip(
                                Icons.access_time,
                                AppColors.yellow,
                                movie.runtime.toString(),
                              ),
                            ),
                            SizedBox(width: 8,),
                            Expanded(
                              child: _buildStatChip(
                                Icons.star,
                                AppColors.yellow,
                                movie.rating.toString(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Screenshots
                  if (movie.screenShots.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Screen Shots",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: movie.screenShots.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                movie.screenShots[index],
                                width: 160,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  SizedBox(height: 16),
                  // Similar Movies
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Similar",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (state.similarMovies.isLoading)
                    const Center(
                      child: CircularProgressIndicator(color: AppColors.red),
                    )
                  else if (state.similarMovies.isSuccess &&
                      state.similarMovies.data != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(vertical: 11),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                        itemCount: state.similarMovies.data!.length,
                        itemBuilder: (context, index) {
                          final similar = state.similarMovies.data![index];
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailsScreen(movieId: similar.id)));

                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  Image.network(
                                    similar.image,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.black.withValues(
                                          alpha: 0.54,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            similar.rating.toString(),
                                            style: TextStyle(
                                              color: AppColors.white.withValues(
                                                alpha: 0.7,
                                              ),
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.star,
                                            color: AppColors.yellow,
                                            size: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  // Summary
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Summary",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      movie.summary,
                      style: TextStyle(
                        color: AppColors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Cast
                  if (movie.cast.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Cast",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 11),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: movie.cast.length,
                      itemBuilder: (context, index) {
                        final cast = movie.cast[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.gray,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  cast.actorImage,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        width: 50,
                                        height: 50,
                                        color: AppColors.black,
                                      ),
                                ),
                              ),
                              title: Text(
                                "Name : ${cast.actorName}",
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Text(
                                "Character : ${cast.characterName}",
                                style: TextStyle(
                                  color: AppColors.white.withValues(alpha: 0.7),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],

                  // Genres
                  if (movie.genres.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Genres",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: movie.genres.map((genre) {
                          return InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BrowseScreen(seeMoreGenre: genre),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.gray,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                genre,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, Color iconColor, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.gray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: AppColors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _showWatchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.gray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.yellow,
                  size: 50,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Sorry!",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "You can't watch movies in this app now, wait for updates.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.8),
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                CustomBtn(
                  withLoading: false,
                  inColor: AppColors.yellow,
                  title: 'Got it',
                  titleColor: AppColors.black,
                  borderColor: Colors.transparent,
                  onTap: () {
                    Navigator.pop(context); // بيقفل الـ Dialog
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
