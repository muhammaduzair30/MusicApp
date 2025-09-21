import 'dart:math';

import 'package:client/core/Theme/app_pallete.dart';
import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:client/features/home/view/pages/search_songPage.dart';
import 'package:client/features/home/view/widgets/search_bar.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';  

// class SugesstionsPage extends ConsumerStatefulWidget {
//   final TextEditingController textFieldController;
//   const SugesstionsPage({super.key,required this.textFieldController});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _SugesstionsPageState();
// }

// class _SugesstionsPageState extends ConsumerState<SugesstionsPage> {
//   late HomeLocalRepository2 _homeLocalRepository2;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the repository using Riverpod
//     _homeLocalRepository2 = ref.read(homeLocalRepository2Provider); // Adjust this line to match your provider
//   }
//   @override
//   Widget build(BuildContext context) {
//     var typedWords = ref.watch(searchTextProvider);
//     print("typed worde:$typedWords");
//     final get_suggestions = ref.watch(getSuggestionsProvider(typedWords));
//     return Padding(
//       padding: const EdgeInsets.only(top: 70,bottom: 55),
//       child: SizedBox(
//         // height: MediaQuery.of(context).size.height-100,
//         child: Column(
//           children: [
//             get_suggestions.when(
//                 data: (data) {
//                   print('DATA:${data}');
//                    final songs = data.item1; // List<SongModel>
//                    final suggestions = data.item2; // List<String>
//                 return Expanded(
//                   child: ListView.builder(
//                     itemCount: min(4, suggestions.length)+songs.length,
//                     itemBuilder: (context,index) {
                      
//                       if(index<min(4, suggestions.length)){
//                         return ListTile(
//                           onTap: () {
//                             widget.textFieldController.text =suggestions[index];
//                             ref.watch(searchTextProvider.notifier).state=suggestions[index];
//                             print(widget.textFieldController);
//                             ref.read(SearchSongCurrentIndexProvider.notifier).state = 2;
//                           },
//                           leading: Icon(Icons.search,size: 30,),
//                           title: Text(
//                                       suggestions[index],
//                                       style: const TextStyle(
//                                         fontSize: 18,
//                                         color: Pallete.subtitleText,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
                        
//                         ); 
//                     } else {
//                       final song = songs[index-min(4, suggestions.length)];
//                       return ListTile(
//                                 onTap: () {
//                                   _homeLocalRepository2.uploadLocalSong(song);
//                                   ref
//                                     .read(currentSongNotifierProvider.notifier)
//                                     .updateSong(song,songs,index);
                                
//                                 },
//                                 leading: CircleAvatar(
//                                   backgroundImage: NetworkImage(song.thumbnail_url),
//                                   radius: 35,
//                                 ),
//                                 title: Text(
//                                   song.song_name,
//                                   style: const TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                                 subtitle: Text(
//                                   song.artist,
//                                   style: const TextStyle(
//                                       fontSize: 13, fontWeight: FontWeight.w600),
//                                 ),
//                               );
                    
                      
                        
//                     }
//                     } 
        
//                     ) 
//                 ); 
                  
        
//                 }, 
        
//                 error: (error, st) {
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 70),
//                     child: Center(
//                       child: Text(error.toString())
//                     ),
//                   );
//                 }, 
//                 loading: ()=> Loader())
//           ],
//         ),
//       ),
//     );
//   }
// }



class SugesstionsPage extends ConsumerStatefulWidget {
  final TextEditingController textFieldController;
  const SugesstionsPage({super.key, required this.textFieldController});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SugesstionsPageState();
}

class _SugesstionsPageState extends ConsumerState<SugesstionsPage> {
  late HomeLocalRepository2 _homeLocalRepository2;

  @override
  void initState() {
    super.initState();
    _homeLocalRepository2 = ref.read(homeLocalRepository2Provider);
  }

  @override
  Widget build(BuildContext context) {
    var typedWords = ref.watch(searchTextProvider) ?? '';  // Ensure typedWords is not null
    print("typed worde:$typedWords");
    final get_suggestions = ref.watch(getSuggestionsProvider(typedWords));
    return Padding(
      padding: const EdgeInsets.only(top: 70, bottom: 55),
      child: SizedBox(
        child: Column(
          children: [
            get_suggestions.when(
                data: (data) {
                  print('DATA:$data');
                  final songs = data.item1; // List<SongModel>
                  final suggestions = data.item2; // List<String>
                  return Expanded(
                    child: ListView.builder(
                      itemCount: min(4, suggestions.length) + songs.length,
                      itemBuilder: (context, index) {
                        if (index < min(4, suggestions.length)) {
                          final suggestion = suggestions[index];
                          return ListTile(
                            onTap: () {
                              widget.textFieldController.text = suggestion;
                              ref.watch(searchTextProvider.notifier).state =
                                  suggestion;
                                print(typedWords);
                              ref.read(SearchSongCurrentIndexProvider.notifier)
                                  .state = 2;
                            },
                            leading: const Icon(
                              Icons.search,
                              size: 30,
                            ),
                            title: RichText(
                              text: TextSpan(
                                children: _highlightMatches(
                                    suggestion, typedWords),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Pallete.subtitleText,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          );
                        } else {
                          final song =
                              songs[index - min(4, suggestions.length)];
                          return ListTile(
                            onTap: () {
                              _homeLocalRepository2.uploadLocalSong(song);
                              ref
                                  .read(currentSongNotifierProvider.notifier)
                                  .updateSong(song, songs, index);
                            },
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(song.thumbnail_url),
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
                        }
                      },
                    ),
                  );
                },
                error: (error, st) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: Center(child: Text(error.toString())),
                  );
                },
                loading: () => const Loader())
          ],
        ),
      ),
    );
  }

  // This function generates a list of TextSpan to highlight the matched words in white
  List<TextSpan> _highlightMatches(String suggestion, String typedWords) {
    if (typedWords.isEmpty) {
      return [
        TextSpan(
          text: suggestion,
          style: const TextStyle(color: Colors.grey),
        ),
      ];
    }

    final List<TextSpan> spans = [];
    final suggestionLower = suggestion.toLowerCase();
    final typedWordsLower = typedWords.toLowerCase();

    int start = 0;
    int matchIndex = suggestionLower.indexOf(typedWordsLower);

    while (matchIndex != -1) {
      // Add the text before the match
      if (matchIndex > start) {
        spans.add(TextSpan(
            text: suggestion.substring(start, matchIndex),
            style: const TextStyle(color: Colors.grey)));
      }

      // Add the matched text in white
      spans.add(TextSpan(
          text: suggestion.substring(
              matchIndex, matchIndex + typedWords.length),
          style: const TextStyle(color: Colors.white)));

      // Move to the end of the matched text
      start = matchIndex + typedWords.length;
      matchIndex = suggestionLower.indexOf(typedWordsLower, start);
    }

    // Add any remaining text after the last match
    if (start < suggestion.length) {
      spans.add(TextSpan(
          text: suggestion.substring(start),
          style: const TextStyle(color: Colors.grey)));
    }

    return spans;
  }
}
