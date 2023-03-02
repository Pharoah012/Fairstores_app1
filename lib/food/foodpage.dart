import 'dart:developer';
import 'package:fairstores/constants.dart';
import 'package:fairstores/mainScreens/search.dart';
import 'package:fairstores/models/categoryModel.dart';
import 'package:fairstores/models/jointModel.dart';
import 'package:fairstores/providers/adsProvider.dart';
import 'package:fairstores/providers/categoryProvider.dart';
import 'package:fairstores/providers/jointProvider.dart';
import 'package:fairstores/providers/schoolListProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/adTile.dart';
import 'package:fairstores/widgets/categoryItem.dart';
import 'package:fairstores/widgets/customSearchField.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/lockedJointTile.dart';
import 'package:fairstores/widgets/unlockedJointTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final _selectedSchoolProvider = StateProvider<String>(
  (ref) => ref.read(userProvider).school!
);

final _selectedCategoryProvider = StateProvider<String>((ref) => "All");


class FoodPage extends ConsumerStatefulWidget {

  const FoodPage({Key? key})
      : super(key: key);

  @override
  ConsumerState<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends ConsumerState<FoodPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(_selectedSchoolProvider.notifier).state = ref.read(userProvider).school!;
    });

    super.initState();
    // //getbestsellers();
    // // getjoints();
  }

  getCategories() {
    List<CategoryModel> categories = ref.read(categoryListProvider);

    if (categories.isEmpty){
      return CustomText(text: "There are no categories");
    }

    return SizedBox(
      height: 33,
      child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: () {
              ref.read(_selectedCategoryProvider.notifier).state = categories[index].name;
            },
            child: CategoryItem(
              category: categories[index],
              isActive: categories[index].name == ref.read(_selectedCategoryProvider),
            ),
          );
        }
      ),
    );
  }

  Widget adSection() {
    final ads = ref.watch(adsProvider(ref.read(_selectedSchoolProvider)));

    return ads.when(
        data: (data){

          if (data.isEmpty){
            return SizedBox.shrink();
          }

          return SizedBox(
            height: 157,
            child: ListView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index){
                return AdTile(ad: data[index]);
              }
            ),
          );

        },
        error: (_, err){
          log(err.toString());
          return SizedBox.shrink();
        },
        loading: () => Container(
          color: kGrey,
          height: 157,
        )
    );
  }

  getJoints() {

    AsyncValue<List<JointModel>> joints;

    if (ref.read(_selectedCategoryProvider) == "All"){
      joints = ref.watch(jointProvider(null));
    }
    else{
      joints = ref.watch(jointProvider({
        "school": ref.read(_selectedSchoolProvider),
        "category": ref.read(_selectedCategoryProvider)
      }));
    }

    return joints.when(
        data: (data){

          log(data.length.toString());

          if (data.isEmpty){
            return SizedBox.shrink();
          }

          return SizedBox(
            height: 190,
            child: ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index){
                  log(data[index].lockshop.toString());
                  return Container(
                    width: 260,
                    padding: EdgeInsets.only(right: 15),
                    child: data[index].lockshop
                      ? LockedJointTile(joint: data[index])
                      : UnlockedJointTile(joint: data[index]),
                  );
                }
            ),
          );

        },
        error: (_, err){
          log(err.toString());
          return SizedBox.shrink();
        },
        loading: () => Container(
          color: kGrey,
          height: 157,
        )
    );
  }
  //
  // getbestsellers() {
  //   if (categorySelection == '01') {
  //     return StreamBuilder<QuerySnapshot>(
  //         stream: jointsRef
  //             .doc(selectedSchool)
  //             .collection('Joints')
  //             .orderBy('foodjoint_favourite_count', descending: true)
  //             .limit(4)
  //             .snapshots(),
  //         builder: (context, snapshot) {
  //           if (!snapshot.hasData) {
  //             return const Text('');
  //           }
  //
  //           List<HomeTile> foodlist = [];
  //           for (var doc in snapshot.data!.docs) {
  //             foodlist
  //                 .add(HomeTile.fromDocument(doc, widget.user, selectedSchool));
  //           }
  //
  //           return Padding(
  //             padding: const EdgeInsets.only(top: 10.0),
  //             child: SizedBox(
  //               height: MediaQuery.of(context).size.height * 0.3,
  //               child: ListView(
  //                 scrollDirection: Axis.horizontal,
  //                 children: foodlist,
  //               ),
  //             ),
  //           );
  //         });
  //   } else {
  //     return StreamBuilder<QuerySnapshot>(
  //         stream: jointsRef
  //             .doc(selectedSchool)
  //             .collection('Joints')
  //             .where('categoryid', isEqualTo: categorySelection)
  //             .orderBy('foodjoint_favourite_count', descending: true)
  //             .limit(4)
  //             .snapshots(),
  //         builder: (context, snapshot) {
  //           if (!snapshot.hasData) {
  //             return const Text('');
  //           }
  //
  //           List<HomeTile> foodlist = [];
  //           for (var doc in snapshot.data!.docs) {
  //             foodlist
  //                 .add(HomeTile.fromDocument(doc, widget.user, selectedSchool));
  //           }
  //
  //           return Padding(
  //             padding: const EdgeInsets.only(top: 10.0),
  //             child: SizedBox(
  //               height: MediaQuery.of(context).size.height * 0.3,
  //               child: ListView(
  //                 scrollDirection: Axis.horizontal,
  //                 children: foodlist,
  //               ),
  //             ),
  //           );
  //         });
  //   }
  // }
  //

  foodPageHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 45.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              padding: const EdgeInsets.only(top: 8),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close)),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: DropdownButton<dynamic>(
                      elevation: 0,
                      underline: const SizedBox(
                        height: 0,
                      ),
                      hint: Text(
                        ' Your Location',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                      items: ref.read(schoolsProvider).when(
                        data: (data) => data.map((element) => DropdownMenuItem(
                          value: element, child: Text(element)))
                             .toList(),
                        error: (_, err){
                          log(err.toString());
                          return [
                            DropdownMenuItem(
                              child: Text(
                                  ref.read(userProvider).school!
                              )
                            )
                          ];
                        },
                        loading: () => [
                          DropdownMenuItem(
                            child: Text(
                              ref.read(userProvider).school!
                            )
                          )
                        ]
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        ref.read(_selectedSchoolProvider.notifier).state = value;
                      }),
                ),
                Text(
                  ref.read(_selectedSchoolProvider),
                  style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w800, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  categoryList() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20,
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: kPrimary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        left: 19.0, right: 19, top: 8, bottom: 8),
                    child: Text(
                      'All',
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.white),
                    ),
                  ))),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    final categoriesList = ref.watch(categoryListProvider);
    final currentCategory = ref.watch(_selectedCategoryProvider);
    final currentLocation = ref.watch(_selectedSchoolProvider);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20,),
          foodPageHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: CustomSearchField(
                    onSubmitted: (value){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Search(
                            searchValue: value,
                          )
                        )
                      );
                    }
                  ),
                ),
                getCategories(),
                SizedBox(height: 20,),
                adSection(),
                SizedBox(height: 20,),
                CustomText(
                  text: "Restaurants Available",
                  isMediumWeight: true,
                ),
                SizedBox(height: 15,),
                // getBestSellers(),
                SizedBox(height: 20,),
                CustomText(
                  text: "Restaurants Available",
                  isMediumWeight: true,
                ),
                SizedBox(height: 15,),
                getJoints()
              ],
            ),
          )

      // Padding(
      //   padding: const EdgeInsets.only(top: 20.0, left: 25, bottom: 0),
      //   child: Text('Best Sellers',
      //       style: GoogleFonts.manrope(
      //           fontWeight: FontWeight.w600, fontSize: 14)),
      // ),
      // getbestsellers(),

        ],
      ),
    );
  }
}