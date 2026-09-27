import 'dart:convert';
import 'package:movies_app/features/movies/domain/entity/cast_entity.dart';

class CastDM {
  final String? name;
  final String? characterName;
  final String? urlSmallImage;

  CastDM({
    this.name,
    this.characterName,
    this.urlSmallImage,
  });

  factory CastDM.fromJson(Map<String, dynamic> json) => CastDM(
        name: json['name'] as String?,
        characterName: json['character_name'] as String?,
        urlSmallImage: json['url_small_image'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'character_name': characterName,
        'url_small_image': urlSmallImage,
      };

  CastDM copyWith({
    String? name,
    String? characterName,
    String? urlSmallImage,
  }) =>
      CastDM(
        name: name ?? this.name,
        characterName: characterName ?? this.characterName,
        urlSmallImage: urlSmallImage ?? this.urlSmallImage,
      );

  CastEntity toEntity() {
    return CastEntity(
      actorName: name ?? '',
      characterName: characterName ?? '',
      actorImage: urlSmallImage ?? '',
    );
  }
}


