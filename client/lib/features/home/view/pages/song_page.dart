import 'package:client/core/Theme/app_pallete.dart';
import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/uitils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongPage extends ConsumerStatefulWidget {
  const SongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SongPageState();
}

class _SongPageState extends ConsumerState<SongPage> {
  // const SongPage({super.key});
  List<bool> isTappedList = [];
  List<bool> isTappedRecentList = [];

  @override
  Widget build(BuildContext context) {
    final recentlyPlayedSongs =
        ref.watch(homeViewmodelProvider.notifier).getRecentlyPlaySomgs();
    final currentSong = ref.watch(currentSongNotifierProvider);

    return Container(
      decoration: currentSong == null
          ? null
          : BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  hexToColor(currentSong.hex_code),
                  Pallete.transparentColor
                ],
                stops: const [0.0, 0.3],
              ),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Your recent rotation",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 36),
            child: SizedBox(
              height: 280,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: recentlyPlayedSongs.length,
                itemBuilder: (context, index) {
                  if (isTappedRecentList.length != recentlyPlayedSongs.length) {
                    isTappedRecentList =
                        List<bool>.filled(recentlyPlayedSongs.length, false);
                  }
                  final song = recentlyPlayedSongs[index];
                  return GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        isTappedRecentList[index] = true;
                      });
                    },
                    onTapUp: (_) {
                      Future.delayed((const Duration(milliseconds: 100)), () {
                        ref
                            .read(currentSongNotifierProvider.notifier)
                            .updateSong(song, recentlyPlayedSongs, index);

                        setState(() {
                          isTappedRecentList[index] = false;
                        });
                      });
                    },
                    child: TweenAnimationBuilder(
                        tween: Tween<double>(
                          begin: isTappedRecentList[index]
                              ? 0.9
                              : 1.0, // adjust scale when tapped
                          end: 1.0,
                        ),
                        duration: const Duration(milliseconds: 200),
                        builder: (context, double scale, child) {
                          return Transform.scale(
                            scale: scale,
                            child: Opacity(
                            opacity: isTappedRecentList[index] ? 0.7 : 1.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Pallete.borderColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 56,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(song.thumbnail_url),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          bottomLeft: Radius.circular(4)),
                                    ),
                                    padding: EdgeInsets.only(right: 20),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Flexible(
                                    child: Text(
                                      song.song_name,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          );
                        }),
                  );
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Latest today',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ref.watch(getAllSongsProvider).when(
                data: (songs) {
                  if (isTappedList.length != songs.length) {
                    isTappedList = List<bool>.filled(songs.length, false);
                  }
                  return SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return GestureDetector(
                          onTapDown: (_) {
                            setState(() {
                              isTappedList[index] = true;
                            });
                          },
                          onTapUp: (_) {
                            Future.delayed((const Duration(milliseconds: 100)),
                                () {
                              ref
                                  .read(currentSongNotifierProvider.notifier)
                                  .updateSong(song, songs, index);

                              setState(() {
                                isTappedList[index] = false;
                              });
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  curve: Curves.easeInOut,
                                  transform: Matrix4.identity()
                                    ..scale(isTappedList[index] ? 0.95 : 1.0),
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              songs[index].thumbnail_url),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(7)),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.song_name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.artist,
                                    style: const TextStyle(
                                        color: Pallete.subtitleText,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                error: (error, st) {
                  return Center(
                    child: Text(
                      error.toString(),
                    ),
                  );
                },
                loading: () => const Loader(),
              ),
        ],
      ),
    );
  }
}
