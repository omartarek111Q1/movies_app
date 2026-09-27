import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/utils/colors/app_colors.dart';
import 'package:movies_app/core/widgets/movie_card.dart';
import 'package:movies_app/features/movies/ui/browse/cubit/browse_cubit.dart';
import 'package:movies_app/features/movies/ui/browse/cubit/browse_state.dart';
import 'package:movies_app/network/resource.dart';

import '../../../../injection_container.dart';

class BrowseScreen extends StatefulWidget {
  final String? seeMoreGenre;
  const BrowseScreen({super.key , this.seeMoreGenre});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  late ScrollController _scrollController;
  late final BrowseCubit browseCubit;

  @override
  void initState() {
    super.initState();
    browseCubit = sl<BrowseCubit>();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    final genreToLoad = widget.seeMoreGenre ?? 'Action';
    browseCubit.getMovieByGenres(genreToLoad);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      browseCubit.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    browseCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: browseCubit,
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
              ),
              BlocBuilder<BrowseCubit, BrowseState>(
                builder: (context, state) {
                  return SizedBox(
                    height: 40,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: browseCubit.genres.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final genre = browseCubit.genres[index];
                        final isSelected = genre == state.selectedGenre;

                        return GestureDetector(
                          onTap: () {
                            if (!isSelected) {
                              browseCubit.getMovieByGenres(genre);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.yellow : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.yellow,
                              ),
                            ),
                            child: Text(
                              genre,
                              style: TextStyle(
                                color: isSelected ? AppColors.black : AppColors.yellow,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<BrowseCubit, BrowseState>(
                  builder: (context, state) {
                    final status = state.moviesResult.status;

                    if (status == ResourceStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.yellow,
                        ),
                      );
                    } else if (status == ResourceStatus.error) {
                      return Center(
                        child: Text(
                          state.moviesResult.errorMessage ?? 'An error occurred',
                          style: const TextStyle(color: AppColors.white),
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else if (status == ResourceStatus.success) {
                      final movies = state.moviesResult.data ?? [];
                      
                      return Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: movies.length,
                              itemBuilder: (context, index) {
                                final movie = movies[index];
                                return MovieCard(
                                  imageUrl: movie.image,
                                  rating: movie.rating,
                                  movieId: movie.id ?? 0,
                                );
                              },
                            ),
                          ),
                          if (state.isFetchingMore) ...[
                            const SizedBox(height: 16),
                            const CircularProgressIndicator(color: AppColors.yellow),
                            const SizedBox(height: 16),
                          ],
                        ],
                      );
                    }
                    
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
