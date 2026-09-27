import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/utils/assets/app_assets.dart';
import 'package:movies_app/core/utils/colors/app_colors.dart';
import 'package:movies_app/core/widgets/movie_card.dart';
import 'package:movies_app/features/movies/domain/usecases/get_movies_list_use_case.dart';
import 'package:movies_app/features/movies/ui/home/home_cubit/home_cubit.dart';
import 'package:movies_app/features/movies/ui/home/home_cubit/home_state.dart';
import 'package:movies_app/injection_container.dart';
import 'package:movies_app/network/resource.dart';

import '../browse/browse_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentCarouselIndex = 0;
  late final HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _homeCubit = HomeCubit(GetMoviesListUseCase(sl()))..getHomeData();
  }

  @override
  void dispose() {
    _homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeCubit,
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          String bgImage = '';
          if (state.availableNowMovies.status == ResourceStatus.success) {
            final movies = state.availableNowMovies.data ?? [];
            if (movies.isNotEmpty && _currentCarouselIndex < movies.length) {
              bgImage = movies[_currentCarouselIndex].image;
            }
          }

          return Scaffold(
            backgroundColor: AppColors.black,
            body: Stack(
              children: [
                // Dynamic Background Image
                if (bgImage.isNotEmpty)
                  Positioned.fill(
                    child: Image.network(
                      bgImage,
                      fit: BoxFit.fill,
                    ),
                  ),

                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.black,
                          AppColors.black.withValues(alpha: .95),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                ),

                // Foreground Content
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        // Available Now Section
                        Image.asset(AppAssets.availableNow, height: 90),
                        const SizedBox(height: 16),
                        _buildAvailableNowSection(state),

                        const SizedBox(height: 24),
                        // Watch Now Section
                        Image.asset(AppAssets.watchNow, height: 140),
                        const SizedBox(height: 16),
                        _buildActionMoviesSection(state),
                        const SizedBox(height: 24),
                        _buildComedyMoviesSection(state),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvailableNowSection(HomeState state) {
    if (state.availableNowMovies.status == ResourceStatus.loading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: const Center(child: CircularProgressIndicator(color: AppColors.yellow)),
      );
    } else if (state.availableNowMovies.status == ResourceStatus.error) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: Center(
          child: Text(
            state.availableNowMovies.errorMessage ?? 'Error loading movies',
            style: const TextStyle(color: AppColors.white),
          ),
        ),
      );
    } else if (state.availableNowMovies.status == ResourceStatus.success) {
      final movies = state.availableNowMovies.data ?? [];
      if (movies.isEmpty) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: const Center(child: Text("No movies available", style: TextStyle(color: AppColors.white))),
        );
      }

      return CarouselSlider.builder(
        itemCount: movies.length,
        itemBuilder: (context, index, realIndex) {
          final movie = movies[index];
          return MovieCard(
            imageUrl: movie.image,
            rating: movie.rating,
            movieId: movie.id ?? 0,
          );
        },
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.45,
          enlargeCenterPage: true,
          viewportFraction: 0.65,
          onPageChanged: (index, reason) {
            setState(() {
              _currentCarouselIndex = index;
            });
          },
        ),
      );
    }
    
    return SizedBox(height: MediaQuery.of(context).size.height * 0.45);
  }

  Widget _buildActionMoviesSection(HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Action',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BrowseScreen(seeMoreGenre: 'Action'),
                    ),
                  );
                },
                child: const Text(
                  'See More >',
                  style: TextStyle(
                    color: AppColors.yellow,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (state.actionMovies.status == ResourceStatus.loading)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: const Center(child: CircularProgressIndicator(color: AppColors.yellow)),
          )
        else if (state.actionMovies.status == ResourceStatus.error)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Center(
              child: Text(
                state.actionMovies.errorMessage ?? 'Error loading action movies',
                style: const TextStyle(color: AppColors.white),
              ),
            ),
          )
        else if (state.actionMovies.status == ResourceStatus.success)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: (state.actionMovies.data ?? []).length,
              itemBuilder: (context, index) {
                final movie = state.actionMovies.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child: MovieCard(
                      imageUrl: movie.image,
                      rating: movie.rating,
                      movieId: movie.id ?? 0,
                    ),
                  ),
                );
              },
            ),
          )
      ],
    );
  }

  Widget _buildComedyMoviesSection(HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Comedy',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BrowseScreen(seeMoreGenre: 'Comedy'),
                    ),
                  );
                },
                child: const Text(
                  'See More >',
                  style: TextStyle(
                    color: AppColors.yellow,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (state.comedyMovies.status == ResourceStatus.loading)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: const Center(child: CircularProgressIndicator(color: AppColors.yellow)),
          )
        else if (state.comedyMovies.status == ResourceStatus.error)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Center(
              child: Text(
                state.comedyMovies.errorMessage ?? 'Error loading action movies',
                style: const TextStyle(color: AppColors.white),
              ),
            ),
          )
        else if (state.comedyMovies.status == ResourceStatus.success)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemCount: (state.comedyMovies.data ?? []).length,
                itemBuilder: (context, index) {
                  final movie = state.comedyMovies.data![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: AspectRatio(
                      aspectRatio: 2 / 3,
                      child: MovieCard(
                        imageUrl: movie.image,
                        rating: movie.rating,
                        movieId: movie.id ?? 0,
                      ),
                    ),
                  );
                },
              ),
            )
      ],
    );
  }
}
