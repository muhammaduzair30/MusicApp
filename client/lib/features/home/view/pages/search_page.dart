import 'package:client/features/home/view/pages/Genre_SongList.dart';
import 'package:client/features/home/view/pages/search_pageContents.dart';
import 'package:client/features/home/view/pages/search_songPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final CurrentIndexProvider = StateProvider<int>((ref) {
  return 0;
});



class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  @override
  Widget build(BuildContext context) {
    int currentPageIndex = ref.watch(CurrentIndexProvider);
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: IndexedStack(
                  index: currentPageIndex,
                  children: const [
                    SearchPageContents(),
                    GenreSonglist(),
                    SearchSongpage(),
                  ],
                ),
              ),
            ],
          ),
      
      
    );
  }
}
