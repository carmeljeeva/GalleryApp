import 'dart:convert';
import 'dart:math';

import 'package:project_gallery/features/gallery/data/models/image_response_model.dart';
import 'package:project_gallery/features/gallery/domain/entities/image_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesLocalDs {
  static const _key = 'favorites_key';
  final SharedPreferences _preferences;
  FavoritesLocalDs(this._preferences);

  List<ImageModel> read() {
    final data = _preferences.getStringList(_key) ?? [];
    return data
        .map(
          (imageData) => ImageResponseModel.fromJson(
            jsonDecode(imageData) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<void> write(List<ImageModel> items) {
    return _preferences.setStringList(
      _key,
      items
          .map((e) => jsonEncode(ImageResponseModel.fromEntity(e).toJson()))
          .toList(),
    );
  }
}
