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
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:fairstores/widgets/adTile.dart';
import 'package:fairstores/widgets/categoryItem.dart';
import 'package:fairstores/widgets/customSearchField.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/lockedJointTile.dart';
import 'package:fairstores/widgets/unlockedJointTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

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
      ref.read(selectedSchoolProvider.notifier).state = ref.read(userProvider).school!;
    });

    super.initState();
  }

  Widget getCategories() {
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
    final ads = ref.watch(adsProvider(ref.read(selectedSchoolProvider)));

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
                return Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: AdTile(ad: data[index]),
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

  Widget getJoints() {

    AsyncValue<List<JointModel>> joints;

    if (ref.read(_selectedCategoryProvider) == "All"){
      joints = ref.watch(jointProvider(null));
    }
    else{
      Tuple2 filter = Tuple2<String, String>(
          ref.read(selectedSchoolProvider),
          ref.read(_selectedCategoryProvider)
      );
      joints = ref.watch(jointProvider(filter));
    }

    return joints.when(
        data: (data){


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
                return Container(
                  width: 260,
                  padding: EdgeInsets.only(left: 20),
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
          height: 157,
          child: Center(
            child: CircularProgressIndicator(
              color: kPrimary,
            ),
          ),
        )
    );
  }


  Widget getBestSellers() {
    AsyncValue<List<JointModel>> joints;

    if (ref.read(_selectedCategoryProvider) == "All"){
      joints = ref.watch(bestSellersProvider(null));
    }
    else{

      Tuple2 filter = Tuple2<String, String>(
          ref.read(selectedSchoolProvider),
          ref.read(_selectedCategoryProvider)
      );

      joints = ref.watch(jointProvider(filter));
    }

    return joints.when(
        data: (data){

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
                    padding: EdgeInsets.only(left: 20),
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
          height: 157,
          child: Center(
            child: CircularProgressIndicator(
              color: kPrimary,
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    final categoriesList = ref.watch(categoryListProvider);
    final currentCategory = ref.watch(_selectedCategoryProvider);
    final currentLocation = ref.watch(selectedSchoolProvider);

    return Scaffold(
      appBar: CustomAppBar(
        isDropdown: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: getCategories(),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  adSection(),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: CustomText(
                      text: 'Best Sellers',
                      isMediumWeight: true,
                    ),
                  ),
                  SizedBox(height: 15,),
                  getBestSellers(),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: CustomText(
                      text: "Restaurants Available",
                      isMediumWeight: true,
                    ),
                  ),
                  SizedBox(height: 15,),
                  getJoints(),
                  SizedBox(height: 20,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}