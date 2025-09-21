import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/pages/search_page.dart';
import 'package:client/features/home/view/widgets/search_barDummy.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final genreProvider = StateProvider<String>((ref) {
  return "";
});

final cardColor = StateProvider((ref) {
  return Colors.white;
});

class SearchPageContents extends ConsumerStatefulWidget {
  const SearchPageContents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchPageContentsState();
}

class _SearchPageContentsState extends ConsumerState<SearchPageContents> {
  List<bool> isTappedList = [];

  @override
  Widget build(BuildContext context) {
    final genreList = ref.watch(getGenreListProvider);
    final List<Color> genreColors = [
      const Color.fromRGBO(219, 20, 139, 1), // For "Pop"
      const Color.fromRGBO(132, 0, 231, 1), // For "Dance/Electronic"
      const Color.fromRGBO(95, 129, 8, 1), // For "Hip-Hop"
      const Color.fromRGBO(71, 125, 149, 1), // For "Rock"
      const Color.fromRGBO(35, 56, 75, 1), // For other genres
      const Color.fromRGBO(39, 133, 106, 1), // Add more colors if you have more genres
      const Color.fromRGBO(88, 86, 214, 1),
      const Color.fromRGBO(255, 59, 48, 1),
      const Color.fromRGBO(123, 239, 178, 1),
      const Color.fromRGBO(76, 175, 80, 1)

    ];
    return Scaffold(
        body: SafeArea(
          child: CustomScrollView(
                slivers: [
          const SliverAppBar(
            floating: false,
            pinned: true,
            expandedHeight: 50,
            toolbarHeight: 0,
            flexibleSpace: FlexibleSpaceBar(
              background:  Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            delegate: _SearchAreaHeaderDelegate(),
            pinned: true,
          ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 10,),
        ),
          genreList.when(
              data: (genres) {
                  if (isTappedList.length != genres.length) {
                    isTappedList = List<bool>.filled(genres.length, false);
                  }
                return SliverPadding(
                  padding: const EdgeInsets.only(bottom: 60,left:8,right: 8),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 1.8,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final cardcolor = genreColors[index % genreColors.length];
                        final genre = genres[index];
                        return GestureDetector(
                          onTapDown: (_){
                            setState(() {
                              isTappedList[index] = true;
                            });

                          },
                          onTapUp: (_) {
                          Future.delayed((const Duration(milliseconds: 300)),() { ref.read(cardColor.notifier).state = cardcolor;
                            ref.read(genreProvider.notifier).state = genre;
                          
                            setState(() {
                              ref.read(CurrentIndexProvider.notifier).state =
                                  1; // Show GenreSonglist
                                  isTappedList[index]=false;
                            });});
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 2),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              transform: Matrix4.identity()..scale(isTappedList[index] ? 0.95:1.0),
                              
                                decoration: BoxDecoration(
                                    color: cardcolor,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Stack(children: [
                                  Positioned(
                                    right: -10,
                                    bottom: -10,
                                    child: RotationTransition(
                                      turns:
                                          const AlwaysStoppedAnimation(30 / 360),
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/genreImages/$genre.jpeg'),
                                                  fit: BoxFit.cover),
                                              // color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 6, left: 11),
                                    child: Text(genre,
                                        style: const TextStyle(
                                            color: Color(0xffffffff),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Raleway",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 13.0),
                                        textAlign: TextAlign.left),
                                  )
                                ])
                                //   ]
                                //   ,
                                // ),
                                ),
                          ),
                        );
                      },
                      childCount: genres.length
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
        ));
  }
}

class _SearchAreaHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 60; // Minimum height of the header
  @override
  double get maxExtent => 60; // Maximum height of the header

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
      return Container(
      color: Color.fromRGBO(20, 20, 20, 1), // Set your desired background color here
      child: const SearchArea(), // Return your SearchArea widget here
    );
    // return SearchArea(); // Return your SearchArea widget here
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true; // Rebuild whenever necessary
  }
}









// SafeArea(
//         child: Container(
//           padding: EdgeInsets.only(top: 40,left: 10,right: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Padding(
//                 padding: const EdgeInsets.only(left: 5),
//                 child: const Text(
//                   'Search',
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               SearchArea(),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 63),
//                   child: genreList.when(
//                       data: (genres) => GridView.builder(
//                         gridDelegate:
//                             const SliverGridDelegateWithMaxCrossAxisExtent(
//                           maxCrossAxisExtent: 200,
//                           childAspectRatio: 1.8,
//                           crossAxisSpacing: 8,
//                           mainAxisSpacing: 8,
//                         ),
//                         itemCount: genres.length,
//                         itemBuilder: (context, index) {
//                           final cardcolor =
//                               genreColors[index % genreColors.length];
//                           final genre = genres[index];
//                           return GestureDetector(
//                             onTap: () {
//                               ref.read(cardColor.notifier).state= cardcolor;
//                               ref.read(genreProvider.notifier).state = genre;
//                               print('ref.watch:${ref.read(genreProvider)}');
//                               setState(() {
//                                 ref
//                                     .read(CurrentIndexProvider.notifier)
//                                     .state = 1; // Show GenreSonglist
//                               });
                        
//                             },
                          
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 2),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: cardcolor,
//                                   borderRadius: BorderRadius.circular(6)
//                                 ),
                              
//                                     child:Stack(
//                                       children: [
//                                         Positioned(
//                                           right: -10,
//                                           bottom: -10,
//                                         child: RotationTransition(
//                                           turns: const AlwaysStoppedAnimation(25 / 360),
//                                           child: Container(
                                          
//                                             height: 70,
//                                             width: 70,
//                                             decoration: BoxDecoration(
//                                               image:  DecorationImage(image: AssetImage('assets/genreImages/$genre.jpeg'),fit: BoxFit.cover) ,
//                                               // color: Colors.blue,
//                                               borderRadius: BorderRadius.circular(6)
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 6, left: 11),
//                         child: Text(genre,
//                             style: const TextStyle(
//                                 color: Color(0xffffffff),
//                                 fontWeight: FontWeight.w700,
//                                 fontFamily: "Raleway",
//                                 fontStyle: FontStyle.normal,
//                                 fontSize: 13.0),
//                             textAlign: TextAlign.left),
//                                       )
//                                       ]
//                                     )
//                                 //   ]
//                                 //   ,
//                                 // ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       error: (error, stack) {
//                         return Center(
//                           child: Text(
//                             error.toString(),
//                           ),
//                         );
//                       },
//                       loading: () => Loader()),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),