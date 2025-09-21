import 'package:client/features/home/models/song_model.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(HomeLocalRepositoryRef ref) {
  return HomeLocalRepository();
}
@riverpod
HomeLocalRepository2 homeLocalRepository2(HomeLocalRepository2Ref ref) {
  return HomeLocalRepository2();
}

class HomeLocalRepository {
  final Box box = Hive.box('Recently Played');

  void uploadLocalSong(SongModel song){
    box.put(song.id,song.toJson());
  }
  List<SongModel> loadSongs () {
    List<SongModel> songs = [];
    
    for (final key in box.keys) {
      songs.add(SongModel.fromJson(box.get(key)));
    }
    return songs;
    
  }
  Future<void> clearAllSongs() async{
    await box.clear();
  }
}


class HomeLocalRepository2 {
  final Box box = Hive.box('Recently Searched');

  void uploadLocalSong(SongModel song){
    box.put(song.id,song.toJson());
  }
  List<SongModel> loadSongs () {
    List<SongModel> songs = [];
    
    for (final key in box.keys) {
      songs.add(SongModel.fromJson(box.get(key)));
    }
    return songs;
    
  }
  Future<void> clearAllSongs() async{
    await box.clear();
  }

  Future<void> deleteSong({required id}) async{
    await box.delete(id);
  }
}