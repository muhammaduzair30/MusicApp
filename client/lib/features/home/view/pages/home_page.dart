import 'package:client/core/Theme/app_pallete.dart';
import 'package:client/features/home/view/pages/librarypage.dart';
import 'package:client/features/home/view/pages/search_page.dart';
import 'package:client/features/home/view/pages/search_songPage.dart';
import 'package:client/features/home/view/pages/song_page.dart';
import 'package:client/features/home/view/widgets/music_slab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex = 0;
  bool showGenreSonglist = false;
  final pages = const [
    SongPage(),
    SearchPage(),
    LibraryPage(),
  ];
 int nestedIndex = -1; // Add nestedIndex to track the nested page
  final PageController pageController = PageController();



  @override
  Widget build(BuildContext context) {  

    return Scaffold(
      body: Stack(
        children: [

          pages[selectedIndex],
          const Positioned(
            bottom: 0,
            child: MusicSlab(),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        
        currentIndex: selectedIndex,
        selectedItemColor: Pallete.whiteColor,
        onTap: (value) {
          setState(() {
            selectedIndex = value;

          });
            
            ref.read(CurrentIndexProvider.notifier).state = 0;
            ref.read(SearchSongCurrentIndexProvider.notifier).state = 0;
    
        },
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                selectedIndex == 0
                    ? 'assets/images/home_filled.png'
                    : 'assets/images/home_unfilled.png',
                color: selectedIndex == 0
                    ? Pallete.whiteColor
                    : Pallete.inactiveBottomBarItemColor,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: selectedIndex == 1
                    ? Pallete.whiteColor
                    : Pallete.inactiveBottomBarItemColor,
                size: 30,
              ),
              label: 'Search'),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/library.png',
                color: selectedIndex == 2
                    ? Pallete.whiteColor
                    : Pallete.inactiveBottomBarItemColor,
              ),
              label: 'Library'),
        ],
      ),
    );
  }
}
