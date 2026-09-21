import 'package:hive_flutter/adapters.dart';
import 'package:movies_app/features/movies/data/models/local/movie_local_model.dart';

class MovieLocalModelAdapter extends TypeAdapter<MovieLocalModel>{

  @override
  final int typeId = 0;

  @override
  MovieLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int , dynamic >{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieLocalModel(
        id: fields[0] as int,
        image: fields[1] as String,
        rating: fields[2] as double);
  }



  @override
  void write(BinaryWriter writer, MovieLocalModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.rating);
  }
}