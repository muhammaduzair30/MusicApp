import 'package:client/features/home/models/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  late HomeLocalRepository _homeLocalRepository;
  AudioPlayer? audioPlayer;
  bool isPlaying = false;
  List<SongModel> songList = [];
  int currentIndex = 0;

  @override
  SongModel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  void updateSong(SongModel song,List<SongModel> Songs_list,int index) async {
    await audioPlayer?.stop();
    audioPlayer = AudioPlayer();
    songList = Songs_list;
    currentIndex = index;

    final audioSource = AudioSource.uri(
      Uri.parse(song.song_url),
      tag: MediaItem(
        id: song.id,
        title: song.song_name,
        artist: song.artist,
        artUri: Uri.parse(song.thumbnail_url),
      ),
    );
    await audioPlayer!.setAudioSource(audioSource);

    audioPlayer!.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        audioPlayer!.seek(Duration.zero);
        audioPlayer!.pause();
        isPlaying = false;
        this.state = this.state?.copyWith(hex_code: this.state?.hex_code);
      }
    });
    _homeLocalRepository.uploadLocalSong(song);
    audioPlayer!.play();
    isPlaying = true;
    state = song;
  }

  void playPause() {
    if (isPlaying) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }
    isPlaying = !isPlaying;
    state = state?.copyWith(hex_code: state?.hex_code);
  }

  void seek(double val) {
    audioPlayer!.seek(
      Duration(
        milliseconds: (val * audioPlayer!.duration!.inMilliseconds).toInt(),
      ),
    );
  }

  void nextSong() {
    if (currentIndex < songList.length - 1) {
      currentIndex++;
      updateSong(songList[currentIndex],songList,currentIndex);
    }
  }

  // Function to go to the previous song
  void previousSong() {
    if (currentIndex > 0) {
      currentIndex--;
      updateSong(songList[currentIndex],songList,currentIndex);
    }
  }
}
