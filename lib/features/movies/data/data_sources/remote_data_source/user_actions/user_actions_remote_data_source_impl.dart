import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies_app/features/movies/data/data_sources/remote_data_source/user_actions/UserActionsRemoteDataSource.dart';
import 'package:movies_app/features/movies/domain/entity/movie_details_entity.dart';
import 'package:movies_app/features/movies/domain/entity/movie_entity.dart';

class UserActionsRemoteDataSourceImpl extends UserActionsRemoteDataSource{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User is not logged in");
    return user.uid;
  }

  @override
  Future<void> addToBookmark(MovieDetailsEntity movie) async{
    final movieData = {
      'id': movie.id,
      'title': movie.title,
      'image': movie.image,
      'rating': movie.rating,
      'year': movie.year,
    };

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('bookmarks')
        .doc(movie.id.toString())
        .set(movieData);
  }

  @override
  Future<void> addToFavorite(MovieDetailsEntity movie) async {
    final batch = _firestore.batch();

    final userFavoriteRef = _firestore.collection('users').doc(_userId).collection('favorites').doc(movie.id.toString());

    final movieCounterRef = _firestore.collection('movies').doc(movie.id.toString());

    final movieData = {
      'id': movie.id,
      'title': movie.title,
      'image': movie.image,
      'rating': movie.rating,
      'year': movie.year,
    };

    batch.set(userFavoriteRef, movieData);

    batch.set(movieCounterRef, {
      'favoriteCount': FieldValue.increment(1)
    }, SetOptions(merge: true));

    await batch.commit();
  }

  @override
  Future<int> getFavoriteCount(int movieId)async {
    final doc = await _firestore.collection('movies').doc(movieId.toString()).get();
    if (doc.exists && doc.data() != null) {
      return doc.data()!['favoriteCount'] ?? 0;
    }
    return 0;
  }

  @override
  Future<bool> isBookmarked(int movieId)async {
    final doc = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('bookmarks')
        .doc(movieId.toString())
        .get();

    return doc.exists;
  }

  @override
  Future<bool> isFavorite(int movieId)async {
    final doc = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('favorites')
        .doc(movieId.toString())
        .get();

    return doc.exists;
  }

  @override
  Future<void> removeFromBookmark(int movieId) async{
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('bookmarks')
        .doc(movieId.toString())
        .delete();
  }

  @override
  Future<void> removeFromFavorite(int movieId) async{
    final batch = _firestore.batch();

    final userFavoriteRef = _firestore.collection('users').doc(_userId).collection('favorites').doc(movieId.toString());

    final movieCounterRef = _firestore.collection('movies').doc(movieId.toString());

    batch.delete(userFavoriteRef);
    batch.set(movieCounterRef, {
      'favoriteCount': FieldValue.increment(-1)
    }, SetOptions(merge: true));

    await batch.commit();
  }

  @override
  Stream<List<MovieEntity>> getFavoriteMovies()  {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('favorites')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return MovieEntity(
          id: data['id'] ?? 0,
          image: data['image'] ?? '',
          rating: (data['rating'] ?? 0).toDouble(),
        );
      }).toList();
    });
  }

  @override
  Stream<List<MovieEntity>> getBookmarkedMovies()  {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('bookmarks')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return MovieEntity(
          id: data['id'] ?? 0,
          image: data['image'] ?? '',
          rating: (data['rating'] ?? 0).toDouble(),
        );
      }).toList();
    });;
  }
}


