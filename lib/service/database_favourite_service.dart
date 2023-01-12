import 'dart:async';

import 'package:my_movie/domain/movie.dart';
import 'package:my_movie/domain/movie_preview.dart';
import 'package:my_movie/service/favourite_service.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseFavouriteService implements FavouriteService {
  static final DatabaseFavouriteService _singleton =
      DatabaseFavouriteService._internal();

  factory DatabaseFavouriteService() {
    return _singleton;
  }

  DatabaseFavouriteService._internal();

  static const String _databaseName = 'my_movie.db';
  static const String _tableName = 'favourites';

  Future<Database> _getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $_tableName(id TEXT PRIMARY KEY, imagePath TEXT, title TEXT, overview TEXT, averageGrade REAL, voteCount INTEGER)",
        );
      },
      version: 1,
    );
  }

  @override
  Future<void> addFavourite(Movie movie) async {
    final Database db = await _getDatabase();
    await db.insert(
      _tableName,
      MoviePreview.fromMovie(movie).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> clearFavourites() async {
    final Database db = await _getDatabase();
    await db.delete(_tableName);
  }

  @override
  Future<List<MoviePreview>> getFavourites() async {
    final Database db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return MoviePreview(
        maps[i]['imagePath'],
        maps[i]['id'],
        maps[i]['title'],
        maps[i]['overview'],
        maps[i]['averageGrade'],
        maps[i]['voteCount'],
      );
    });
  }

  @override
  Future<bool> isFavourite(String movieId) async {
    final Database db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [movieId],
    );
    return maps.isNotEmpty;
  }

  @override
  Future<void> removeFavourite(Movie movie) async {
    final Database db = await _getDatabase();
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  @override
  Future<void> toggleFavourite(Movie movie) async {
    if (await isFavourite(movie.id)) {
      await removeFavourite(movie);
    } else {
      await addFavourite(movie);
    }
  }
}
