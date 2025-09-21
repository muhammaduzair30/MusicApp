import 'dart:math';

import 'package:client/core/Theme/app_pallete.dart';
import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final no_ofSongs =StateProvider<int>((ref){
//   return 0;
// });

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true, // App bar remains visible at the top
                floating: true, // App bar can be hidden when scrolling down
                expandedHeight: 170,
                toolbarHeight: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      alignment: Alignment.topLeft,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(30, 50, 165, 1), // Start color
                            Color.fromRGBO(18, 18, 18, 1) // End color
                          ],
                          begin: Alignment.topCenter, // Starting point
                          end: Alignment.bottomCenter, // Ending point
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      
                  
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40,vertical: 19),
                            child: RichText(
                              text: TextSpan(
                                  text: 'Liked Songs',
                                  style: const TextStyle(
                                      fontSize: 30, fontWeight: FontWeight.w700),
                                  children: [
                                    TextSpan(
                                        text:
                                            "\n${ref.watch(getFavSongsProvider).maybeWhen(
                                                  data: (data) =>
                                                      '${data.length} songs',
                                                  orElse: () => '0 songs',
                                                )}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Pallete.subtitleText,
                                        ))
                                  ]),
                            ),
                          ),
                          SizedBox(height: 15,),
                  
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const UploadSongPage(),
                                      ),
                                    );
                              },
                              
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                side: BorderSide(color: Pallete.subtitleText),
                                elevation: 0,
                                
                              ),
                              child: const Text('Upload Song',style: TextStyle(color: Colors.green),),
                            ),
                          )
                  
                          // SizedBox(height: 15),
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
                  maxHeight: 50.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(58, 78, 193, 1), // Start color
                          Color.fromRGBO(40, 40, 40, 1) // End color
                        ],
                        begin: Alignment.center, // Starting point
                        end: Alignment.topRight, // Ending point
                      ),
                    ),
                    // color: Colors.white, // Background color for persistent header
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        "Liked Songs",
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              ref.watch(getFavSongsProvider).when(
                    data: (data) {
                      // ref.read(no_ofSongs.notifier).state=data.isNotEmpty ? data.length : 0;
                      return SliverList(
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
    // Calculate the opacity based on how much the header has been scrolled
    double opacity =
        ((shrinkOffset - (maxExtent - minExtent)) / maxExtent).clamp(0.0, 1.0);
    // double opacity = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    return Opacity(opacity: opacity, child: SizedBox.expand(child: child));
  }

  @override
  bool shouldRebuild(covariant _SliverPersistentHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
