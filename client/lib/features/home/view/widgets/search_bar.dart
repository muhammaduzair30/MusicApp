import 'package:client/features/home/view/pages/search_page.dart';
import 'package:client/features/home/view/pages/search_songPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchTextProvider = StateProvider<String>((ref) => '');


class SearchBarr extends ConsumerStatefulWidget {
  final TextEditingController textFieldController;

  const SearchBarr({super.key,required this.textFieldController});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchBarrState();
}

class _SearchBarrState extends ConsumerState<SearchBarr> {





  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFF2E2E2E),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: TextField(
                  controller: widget.textFieldController,
                  cursorColor: Colors.green[800],
                  decoration: InputDecoration(
                    hintText: 'What do you want to Listen to?',
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 7),
                    hintStyle: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF6A6A6A),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    prefixIcon: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                      
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                          setState(
                      () {
                        widget.textFieldController.clear();
                        ref.read(CurrentIndexProvider.notifier).state = 0;
                      },
                    );
        
                      },
                    ),
                    suffixIcon: widget.textFieldController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              widget.textFieldController.clear();
                              ref
                                  .read(searchTextProvider.notifier)
                                  .state = ''; 
                              ref.read(SearchSongCurrentIndexProvider.notifier).state = 0;// Update provider if needed
                            });
                          },
                        )
                      : null,
                
                  ),
                  onSubmitted: (value) async {
                    if(value.isEmpty){
                      return ;
                    }
                  ref.read(SearchSongCurrentIndexProvider.notifier).state = 2;
                  },
                  onChanged: (value) {
                  if(value.isEmpty){
                    ref.read(SearchSongCurrentIndexProvider.notifier).state = 0;
                  }else{ 
                  ref.read(SearchSongCurrentIndexProvider.notifier).state = 1;
                  }  
                  ref.watch(searchTextProvider.notifier).state = value;
                  },
                ),
              ),
    );
  }
}