import 'package:client/core/Theme/app_pallete.dart';
import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentlSearchsongs extends ConsumerStatefulWidget {
  const RecentlSearchsongs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecentlSearchsongsState();
}

class _RecentlSearchsongsState extends ConsumerState<RecentlSearchsongs> {
  // late HomeLocalRepository2 _homeLocalRepository2;

  // @override
  // void initState() {
  //   super.initState();
  //   // Initialize the repository using Riverpod
  //   _homeLocalRepository2 = ref.read(
  //       homeLocalRepository2Provider); // Adjust this line to match your provider
  // }

  @override
  Widget build(BuildContext context) {
    final recentlySearchSongs =
        ref.watch(homeViewmodelProvider.notifier).getRecentlySearchSongs();
    return recentlySearchSongs.isEmpty? const Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Play what you love",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),),
          Text("Search artists,songs,genre and more",
          style: TextStyle(
            color: Pallete.subtitleText,
          ),)
        ],
      )
    ):Padding(
      padding: const EdgeInsets.only(top: 90, bottom: 60),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: recentlySearchSongs.isEmpty
                        ? 0
                        : recentlySearchSongs.length + 2,
                    itemBuilder: (context, index) {
                      if (index == recentlySearchSongs.length+1 &&
                          recentlySearchSongs.isNotEmpty) {
                        return Center(
                          child: SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () async {
                                // ref.read(homeLocalRepositoryProvider).clearAllSongs();
                                await ref
                                    .read(homeViewmodelProvider.notifier)
                                    .ClearRecentSearches();
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor:
                                      Colors.transparent.withOpacity(0),
                                  side:
                                      BorderSide(color: Pallete.subtitleText)),
                              child: const Text(
                                'Clear recent searches',
                                style: TextStyle(color: Pallete.whiteColor),
                              ),
                            ),
                          ),
                        );
                      }
                      if (index == 0 && recentlySearchSongs.isNotEmpty) {
                        return const Text(
                          'Rcent Searches',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      }
                      final song = recentlySearchSongs[index-1];
                      return ListTile(
                        onTap: () {
                          ref
                              .read(currentSongNotifierProvider.notifier)
                              .updateSong(song,recentlySearchSongs,index);
                        },
                        leading: ClipRRect(
                            child: Image.network(
                          song.thumbnail_url,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        )),
                        title: Text(
                          song.song_name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          song.artist,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () async{
                            await ref
                                    .read(homeViewmodelProvider.notifier)
                                    .Remov_recentSearchSong(id:song.id);
                                setState(() {});
                            
                          },
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
