import 'dart:developer';
import 'package:fairstores/constants.dart';
import 'package:fairstores/food/foodtile.dart';
import 'package:fairstores/models/eventModel.dart';
import 'package:fairstores/models/foodModel.dart';
import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/profileScreens/saveditems.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/customEventTile.dart';
import 'package:fairstores/widgets/customFoodTile.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final foodResultsProvider = FutureProvider.family<List<FoodModel>, String>(
  (ref, searchValue) async {
    UserModel user = ref.read(userProvider);
    return await FoodModel.getSearchResults(
      school: user.school!,
      searchValue: searchValue,
      userID: user.uid
    );
});

final eventResultsProvider = FutureProvider.family<List<EventModel>, String>(
    (ref, searchValue) async {
  UserModel user = ref.read(userProvider);
  return await EventModel.getSearchResults(
      school: user.school!,
      searchValue: searchValue,
      userID: user.uid
  );
});

final _currentPageProvider = StateProvider.autoDispose<String>((ref) => "food");
final _searchProvider = StateProvider.autoDispose<String>((ref) => "");

class Search extends ConsumerStatefulWidget {

  const Search({Key? key,});

  @override
  ConsumerState<Search> createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> {
  String search = '';
  List<FoodTile> foodlist = [];

  @override
  void initState() {
    super.initState();
  }


  // show the results respectice to the selected page
  Widget pageToggle(page) {
    if (page == 'food') {
      final foodResults = ref.watch(foodResultsProvider(search));

      return foodResults.when(
          data: (data){
            if (data.isEmpty){
              return Center(
                child: CustomText(
                    text: "No results match your query"
                ),
              );
            }

            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index){
                  return CustomFoodTile(food: data[index]);
                }
            );
          },
          error: (_, err){
            log(err.toString());
            return Center(
              child: CustomText(
                  text: "An error occurred while fetching your results"
              ),
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(
              color: kPrimary,
            ),
          )
      );
    } else if (page == 'events') {
      final eventResults = ref.watch(eventResultsProvider(search));

      return eventResults.when(
        data: (data){
          if (data.isEmpty){
            return Center(
              child: CustomText(
                  text: "No results match your query"
              ),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index){
              return CustomEventTile(event: data[index]);
            }
          );
        },
        error: (_, err){
          log(err.toString());
          return Center(
            child: CustomText(
              text: "An error occurred while fetching your results"
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            color: kPrimary,
          ),
        )
      );
    }
    return const Text('data');
  }

  searchscreen() {
    return Center(
      child: GestureDetector(
        onTap: () {
          ref.read(currentPage.notifier).state = "food";
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: 48,
          decoration: BoxDecoration(
            color: kPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    height: 33.6,
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      color: ref.read(_currentPageProvider) == 'food'
                        ? kPrimary
                        : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: CustomText(
                        text: 'Food',
                        fontSize: 12,
                        color: ref.read(_currentPageProvider) == 'food'
                            ? Colors.white
                            : Colors.black,
                        isMediumWeight: true,
                      )
                    )
                  ),
                ),
                SizedBox(width: 13,),
                GestureDetector(
                  onTap: () {
                    ref.read(_currentPageProvider.notifier).state = "events";
                  },
                  child: Container(
                    height: 33.6,
                    width: 100,
                    decoration: BoxDecoration(
                      color: ref.read(_currentPageProvider) == 'events'
                        ? kPrimary
                        : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: CustomText(
                        text: 'Events',
                        fontSize: 12,
                        color: ref.read(_currentPageProvider) == 'events'
                          ? Colors.white
                          : Colors.black,
                        isMediumWeight: true,
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  nosearchscreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.search,
          color: kLabelColor,
        ),
        SizedBox(height: 5,),
        CustomText(
          text: 'Search FairStores',
          fontSize: 15,
          isMediumWeight: true,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _currentPage = ref.watch(_currentPageProvider);
    final _searchValue = ref.watch(_searchProvider);

    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: SizedBox(
                    height: 43,
                    width: 335,
                    child: TextField(
                      onSubmitted: (value) {
                        ref.read(_searchProvider.notifier).state = search;
                      },
                      cursorColor: kPrimary,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(
                            color: kPrimary,
                          )
                        ),
                        focusColor: kPrimary,
                        prefixIcon: Icon(
                          Icons.search,
                          color: kPrimary,
                          size: 14,
                        ),
                        labelText: 'Search FairStores app',
                        labelStyle: GoogleFonts.manrope(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: const Color(0xff8B8380)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xffE5E5E5),
                          ),
                          borderRadius: BorderRadius.circular(100)
                        )
                      )
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              _searchValue == '' || search.isEmpty
                ? nosearchscreen()
                : Column(
                children: [
                  searchscreen(),
                  pageToggle(_currentPage)
                ],
              ),
            ],
          )),
        )
    );
  }
}
