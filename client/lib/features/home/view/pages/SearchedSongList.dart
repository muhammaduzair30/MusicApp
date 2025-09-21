
import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:client/features/home/view/widgets/search_bar.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Searchedsonglist extends ConsumerStatefulWidget {
  final TextEditingController textFieldController;
  const Searchedsonglist({super.key, required this.textFieldController});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchedsonglistState();
}

class _SearchedsonglistState extends ConsumerState<Searchedsonglist> {
late HomeLocalRepository2 _homeLocalRepository2;

  @override
  void initState() {
    super.initState();
    // Initialize the repository using Riverpod
    _homeLocalRepository2 = ref.read(homeLocalRepository2Provider); // Adjust this line to match your provider
  }

  @override
  Widget build(BuildContext context) {
    var typedWords = ref.watch(searchTextProvider);
    final get_suggestions = ref.watch(getSuggestionsProvider(typedWords));
    return Padding(
      padding: const EdgeInsets.only(top: 60,bottom: 55),
      child: Column(
        children: [
          // Text("Seach Song",style: TextStyle(fontSize: 60),),
          Expanded(
            child: get_suggestions.when(
                      data: (data) {
                        final songs = data.item1;
                        return ListView.builder(
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            final song = songs[index];
                            return ListTile(
                              onTap: () {
                                _homeLocalRepository2.uploadLocalSong(song);
                                ref
                                    .read(currentSongNotifierProvider.notifier)
                                    .updateSong(song,data.item1,index);
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(song.thumbnail_url),
                                radius: 35,
                              ),
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
                            );
                          },
                        );
                      },
                      error: (error, st) {
                        return Center(
                          child: Text(error.toString()),
                        );
                      },
                      loading: () => const Loader(),
                    )
          )
        ],
      ),
    );
    
    
  }
}