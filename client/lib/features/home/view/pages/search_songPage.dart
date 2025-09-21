import 'package:client/features/home/view/pages/SearchedSongList.dart';
import 'package:client/features/home/view/pages/SugesstionsPage.dart';
import 'package:client/features/home/view/pages/recentl_searchSongs.dart';
import 'package:client/features/home/view/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final SearchSongCurrentIndexProvider = StateProvider<int>((ref) {
  return 0;
});


class SearchSongpage extends ConsumerStatefulWidget {
  const SearchSongpage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchSongpageState();
}

class _SearchSongpageState extends ConsumerState<SearchSongpage> {
  final TextEditingController textFieldController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    textFieldController.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    int currentPageIndex = ref.watch(SearchSongCurrentIndexProvider);
    
    return Stack(
      children: [
        IndexedStack(
          index: currentPageIndex,
          children:  [
            RecentlSearchsongs(),
            SugesstionsPage(textFieldController: textFieldController),
            Searchedsonglist(textFieldController: textFieldController),
            
          ],

        ),
          Positioned(
            top: 0,
            left: 0, // Align it to the left
            right: 0, // Align it to the right
            child: SearchBarr(textFieldController: textFieldController), // Add your SearchBarr widget here
          ),
      ],


    );
  }

}

