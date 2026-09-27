import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/utils/colors/app_colors.dart';
import 'package:movies_app/core/utils/assets/app_assets.dart';
import 'package:movies_app/core/widgets/movie_card.dart';
import 'package:movies_app/features/movies/ui/search/cubit/search_cubit.dart';
import 'package:movies_app/features/movies/ui/search/cubit/search_state.dart';
import 'package:movies_app/network/resource.dart';

import '../../../../injection_container.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late ScrollController _scrollController;
  late final SearchCubit searchCubit;

  @override
  void initState() {
    super.initState();
    searchCubit = sl<SearchCubit>();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      searchCubit.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: searchCubit,
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: BlocBuilder<SearchCubit , SearchState>(
          builder: (context , state){
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      textInputAction: TextInputAction.search,
                      style: const TextStyle(color: AppColors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.gray,
                        hintText: 'Search',
                        hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.5)),
                        prefixIcon: const Icon(Icons.search, color: AppColors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onSubmitted: (value) {
                        searchCubit.searchMovie(value);
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: BlocBuilder<SearchCubit, SearchState>(
                        builder: (context, state) {
                          final status = state.searchResult.status;

                          if (status == ResourceStatus.initial) {
                            return Center(
                              child: Image.asset(AppAssets.empty),
                            );
                          } else if (status == ResourceStatus.loading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.yellow,
                              ),
                            );
                          } else if (status == ResourceStatus.error) {
                            return Center(
                              child: Text(
                                state.searchResult.errorMessage ?? 'An error occurred',
                                style: const TextStyle(color: AppColors.white),
                                textAlign: TextAlign.center,
                              ),
                            );
                          } else if (status == ResourceStatus.success) {
                            final movies = state.searchResult.data ?? [];
                            if (movies.isEmpty) {
                              return Center(
                                child: Image.asset(AppAssets.empty),
                              );
                            }

                            return Column(
                              children: [
                                Expanded(
                                  child: GridView.builder(
                                    controller: _scrollController,
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
            );
          },

        ),
      ),
    );
  }
}
