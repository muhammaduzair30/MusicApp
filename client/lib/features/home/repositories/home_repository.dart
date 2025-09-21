import 'dart:convert';
import 'dart:io';

import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuple/tuple.dart';
part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong(
      {required File selectAudio,
      required File selectedThumbnail,
      required String songName,
      required String genre,
      required String artist,
      required String hexCode,
      required String token}) async {
    print('HomeRepositoryGenre: $genre');
    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse('${ServerConstants.serverURL}/song/upload'));

      request
        ..files.addAll(
          [
            await http.MultipartFile.fromPath('song', selectAudio.path),
            await http.MultipartFile.fromPath(
                'thumbnail', selectedThumbnail.path)
          ],
        )
        ..fields.addAll(
          {
            'genre': genre,
            'artist': artist,
            'song_name': songName,
            'hex_code': hexCode,
            
          },
        )
        ..headers.addAll(
          {'x-auth-token': token},
        );

      final res = await request.send();

      if (res.statusCode != 201) {
        return Left(AppFailure(await res.stream.bytesToString()));
      }

      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSongs({
    required String token,
  }) async {
    try {
      final res = await http
          .get(Uri.parse('${ServerConstants.serverURL}/song/list'), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      });
      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }
      resBodyMap = resBodyMap as List;

      List<SongModel> songs = [];

      for (final map in resBodyMap) {
        songs.add(SongModel.fromMap(map));
      }
  

      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favSong(
      {required String token, required String songId}) async {
    try {
      final res = await http.post(
          Uri.parse('${ServerConstants.serverURL}/song/favorite'),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          },
          body: jsonEncode(
            {"song_id": songId},
          ));
      var resBodyMap = jsonDecode(res.body);
      
      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(resBodyMap['message']);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getFavSongs({
    required String token,
  }) async {
    try {
      final res = await http.get(
          Uri.parse('${ServerConstants.serverURL}/song/list/favorites'),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          });
      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }
      resBodyMap = resBodyMap as List;

      List<SongModel> songs = [];

      for (final map in resBodyMap) {
        songs.add(SongModel.fromMap(map['song']));
      }

      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<String>>> getGenre () async {
    try{
    final res =await http.get(
          Uri.parse('${ServerConstants.serverURL}/song/genre'),
          headers: {
            'Content-Type': 'application/json',
          });
        var resBodyMap = jsonDecode(res.body);
        if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }
      print('Response body: $resBodyMap');

    

    List<String> genres = List<String>.from(resBodyMap['genre']);
    print(genres);
      return Right(genres);

    
  }catch(e){
    return Left(AppFailure(e.toString()));
  }
}

Future<Either<AppFailure, List<SongModel>>> get_GenreSongList({
  required String genre
}) async {
  try{
    final res = await http.get(Uri.parse('${ServerConstants.serverURL}/song/genre/Songlist?genre=$genre'), );
      var resBodyMap = jsonDecode(res.body);
      print('GENRESONGList Response:$res');
      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }
      final List<dynamic> songList = resBodyMap['songs'];

    List<SongModel> songs = songList.map((song) => SongModel.fromMap(song)).toList();

      return Right(songs);


  }catch(e) {
    return Left(AppFailure(e.toString()));
  }
  
}

Future<Either<AppFailure, Tuple2<List<SongModel>, List<String>>>> get_searchSuggestions ({required String typedWords}) async {
  try{
    final res = await http.get(Uri.parse('${ServerConstants.serverURL}/song/search?words=$typedWords'), );
    var resBodyMap = jsonDecode(res.body);
    print('RESBODYMAP: $resBodyMap');
    if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }
      
        
    final List<dynamic> songList = resBodyMap['song'];
    List<SongModel> songs = songList.map((song) => SongModel.fromMap(song)).toList();


    final List<dynamic> suggestionList = resBodyMap['suggestions'];
    List<String> suggestions = suggestionList.map((item) => item['name'] as String).toList();
    print('TUPLE2:${Tuple2(songs, suggestions)}');

    return Right(Tuple2(songs, suggestions));

  }catch (e) {
    return Left(AppFailure(e.toString()));
  }
  
}
}