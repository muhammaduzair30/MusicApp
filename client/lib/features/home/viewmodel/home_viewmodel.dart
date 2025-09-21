import 'dart:ui';

import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/core/uitils.dart';
import 'package:client/features/home/models/fav_song_model.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:io';

import 'package:tuple/tuple.dart';
part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(GetAllSongsRef ref) async {
  final token = ref.watch(currentUserNotifierProvider.select((user)=> user!.token));
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(
        token: token,
      );

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r
  };
}

@riverpod
Future<List<SongModel>> getFavSongs(GetFavSongsRef ref) async {
  final token = ref.watch(currentUserNotifierProvider.select((user)=> user!.token));
  final res = await ref.watch(homeRepositoryProvider).getFavSongs(
        token: token,
      );

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r
  };
}

@riverpod
Future<List<String>> getGenreList(GetGenreListRef ref) async {
  final res = await ref.watch(homeRepositoryProvider).getGenre();
  
  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r
  };
}

@riverpod
Future<List<SongModel>> getGenreSongList(GetGenreSongListRef ref, String genre) async {
  print("stringGenreFromHomeview:$genre");
  final res = await ref.watch(homeRepositoryProvider).get_GenreSongList(genre: genre);
  print('GetGenreListSon:  $res');
  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r
  };
}

@riverpod
Future<Tuple2<List<SongModel>, List<String>>> getSuggestions(GetSuggestionsRef ref,String words) async {
  final res = await ref.watch(homeRepositoryProvider).get_searchSuggestions(typedWords:words);
  print('RESPONSE:$res');
    return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r
  };
  
}




@riverpod
class HomeViewmodel extends _$HomeViewmodel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;
  late HomeLocalRepository2 _homeLocalRepository2;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    _homeLocalRepository2 =ref.watch(homeLocalRepository2Provider);
    return null;
  }

  Future<void> uploadSong(
      {required File selectAudio,
      required File selectedThumbnail,
      required String songName,
      required String genre,
      required String artist,
      required Color selectedColor}) async {
      print('Genre:$genre');
    state = const AsyncValue.loading();
    final res = await _homeRepository.uploadSong(
      selectAudio: selectAudio,
      selectedThumbnail: selectedThumbnail,
      songName: songName,
      genre: genre,
      artist: artist,
      hexCode: rgbToHex(selectedColor),
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };

    print(val);
  }

  List<SongModel> getRecentlyPlaySomgs() {
    return _homeLocalRepository.loadSongs();
  }
  List<SongModel> getRecentlySearchSongs() {
    return _homeLocalRepository2.loadSongs();
  }
  Future<void> ClearRecentSearches() async{
    await _homeLocalRepository2.clearAllSongs();
    state =  AsyncValue.data([]);
    ref.invalidate(homeLocalRepository2Provider);
  
    return;
  }

Future<void> Remov_recentSearchSong({required id}) async{
await _homeLocalRepository2.deleteSong(id: id);
state =  AsyncValue.data([]);
ref.invalidate(homeLocalRepository2Provider);

}
  Future<void> favSong({required String songId}) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.favSong(
      songId: songId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => _favSongSuccess(r, songId),
    };

    print('FavSongFunction: $val');
  }

  AsyncValue _favSongSuccess(bool isFavorited, String songId) {
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);
    if (isFavorited) {
      userNotifier
          .addUser(ref.read(currentUserNotifierProvider)!.copyWith(favorites: [
        ...ref.read(currentUserNotifierProvider)!.favorites,
        FavSongModel(
          id: '',
          song_id: songId,
          user_id: '',
        ),
      ]));
    } else {
      userNotifier.addUser(
        ref.read(currentUserNotifierProvider)!.copyWith(
              favorites: ref
                  .read(currentUserNotifierProvider)!
                  .favorites
                  .where(
                    (fav) => fav.song_id != songId,
                  )
                  .toList(),
            ),
      );
    }
    ref.invalidate(getFavSongsProvider);
    return state = AsyncValue.data(isFavorited);
  }
  
}
