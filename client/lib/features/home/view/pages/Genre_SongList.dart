import 'dart:math';

import 'package:client/core/Theme/app_pallete.dart';
import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/pages/search_page.dart';
import 'package:client/features/home/view/pages/search_pageContents.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class GenreSonglist extends ConsumerStatefulWidget {
  const GenreSonglist({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GenreSonglistState();
}

class _GenreSonglistState extends ConsumerState<GenreSonglist> {
  @override
  Widget build(BuildContext context) {
    final genre = ref.watch(genreProvider);
    final color = ref.read(cardColor);
    

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: true,
              toolbarHeight: 0,
              expandedHeight: 130,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration:  BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                          color, // Start color
                        Color.fromRGBO(18, 18, 18, 1) // End color
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          // Go back to Search Page
                          setState(
                            () {
                              ref.read(CurrentIndexProvider.notifier).state = 0;
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          genre,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
                pinned: true,
                delegate: _SliverPersistentHeaderDelegate(
                  minHeight:
                      50.0, // Adjust this height for how much you want it to shrink
                  maxHeight: 55.0,
                  child: Container(
                    decoration:  BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ref.read(cardColor), // Start color
                          Color.fromRGBO(18, 18, 18, 1)// End color
                        ],
                        begin: Alignment.center, // Starting point
                        end: Alignment.topRight, // Ending point
                      ),
                    ),
                    // color: Colors.white, // Background color for persistent header
                    child: Row(
                      children: [
                        IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          // Go back to Search Page
                          setState(
                            () {
                              ref.read(CurrentIndexProvider.notifier).state = 0;
                            },
                          );
                        },
                      ),
                        Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      child: Text(
                        ref.watch(genreProvider),
                        style:
                            TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                    ),
                      ],
                    )
                  ),
                ),
              ),
            ref.watch(getGenreSongListProvider(genre)).when(
                    data: (data) {
                      // ref.read(no_ofSongs.notifier).state=data.isNotEmpty ? data.length : 0;
                      return SliverPadding(
                        padding: const EdgeInsets.only(bottom: 60),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              
                              final song = data[index];
                              return ListTile(
                                key: ValueKey(song.id), // Unique key for each song
                                onTap: () {
                                  ref
                                      .read(currentSongNotifierProvider.notifier)
                                      .updateSong(song,data,index);
                                },
                                leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(song.thumbnail_url),
                                    radius: 35,
                                    backgroundColor: Pallete.backgroundColor),
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
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
                            childCount: data.length, // Add 1 for the "Upload New Song" button
                          ),
                        ),
                      );
                    },
                    error: (error, st) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Text(error.toString()),
                        ),
                      );
                    },
                    loading: () => const SliverToBoxAdapter(
                      child: Loader(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}



class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverPersistentHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
  
  // double opacity =
  //       ((shrinkOffset - (maxExtent - minExtent)) / maxExtent).clamp(0.0, 1.0);
    //  double opacity = 1-(shrinkOffset / maxExtent).clamp(0.0, 1.0);

    double opacity = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    return Opacity(opacity: opacity, child: SizedBox.expand(child: child));
  }

  @override
  bool shouldRebuild(covariant _SliverPersistentHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}












//  final genre = ref.watch(genreProvider);
//     print('GENRE:$genre');
//     return SafeArea(
//       child: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.only(top: 10),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
              // IconButton(
              //   icon: const Icon(Icons.arrow_back, color: Colors.white),
              //   onPressed: () {
              //     // Go back to Search Page
              //     setState(
              //       () {
              //         ref.read(CurrentIndexProvider.notifier).state = 0;
              //       },
              //     );
              //   },
              // ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 00, left: 20),
//                 child: Text(
//                   ref.watch(genreProvider),
//                   style: const TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               ref.watch(getGenreSongListProvider(genre)).when(
//                     data: (songs) {
//                       print('SONGS GEnreSOngLIst: $songs');
//                       return Expanded(
//                         child: ListView.builder(
//                           itemCount: songs.length,
//                           itemBuilder: (context, index) {
//                             final song = songs[index];
//                             return ListTile(
//                               onTap: () {
//                                 ref
//                                     .read(currentSongNotifierProvider.notifier)
//                                     .updateSong(song,songs,index);
//                               },
//                               leading: CircleAvatar(
//                                 backgroundImage: NetworkImage(song.thumbnail_url),
//                                 radius: 35,
//                               ),
//                               title: Text(
//                                 song.song_name,
//                                 style: const TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                               subtitle: Text(
//                                 song.artist,
//                                 style: const TextStyle(
//                                     fontSize: 13, fontWeight: FontWeight.w600),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     },
//                     error: (error, st) {
//                       return Center(
//                         child: Text(error.toString()),
//                       );
//                     },
//                     loading: () => const Loader(),
//                   ),
//             ],
//           ),
//         ),
//       ),
//     );
