import 'package:client/core/Theme/app_pallete.dart';
import 'package:client/features/home/view/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchArea extends ConsumerStatefulWidget {
  const SearchArea ({super.key});

  @override
  _SearchAreaState createState() => _SearchAreaState();
}

class _SearchAreaState extends ConsumerState<SearchArea> {
  @override
  Widget build(BuildContext context) {
    // final searchController = TextEditingController();
    return  GestureDetector(
      onTap: () {
        setState(
                    () {
                      ref.read(CurrentIndexProvider.notifier).state = 2;
                    },
                  );
      },
      child: Center(
        child: Container(
          height: 45,
          width: MediaQuery.of(context).size.width-30,
          decoration: BoxDecoration(
              color: Pallete.whiteColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Pallete.whiteColor)),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.search,color: Color.fromARGB(255, 72, 71, 71),size: 30,),
                SizedBox(width: 5,),
                Text(
                  'Whats on your mind',
                  style: TextStyle(
                    color: Color.fromARGB(255, 72, 71, 71),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
            
  }
}



