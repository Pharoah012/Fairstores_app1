import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/models/JointMenuOption.dart';
import 'package:fairstores/providers/cartInfoProvider.dart';
import 'package:fairstores/models/foodOrdersModel.dart';
import 'package:fairstores/models/jointMenuItemModel.dart';
import 'package:fairstores/models/jointModel.dart';
import 'package:fairstores/providers/schoolListProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/cartCard.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/jointMenuItemTile.dart';
import 'package:fairstores/widgets/jointMenuOption.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final selectedMenuOptionProvider = StateProvider<String>((ref) => "");
// final menuItemsListProvider = StateProvider<List<JointMenuItemModel>>((ref) => []);
// final foodCartListProvider = StateProvider((ref) => []);
final _favoriteProvider = StateProvider<bool>((ref) => false);

final jointMenuItemsProvider = FutureProvider.autoDispose.family<List<JointMenuItemModel>, JointModel>(
  (ref, joint) async {

    // get the menu items for the selected menu category
    List<JointMenuItemModel> menuOptions = await joint.getMenuOptionItems(
      menuOption: ref.read(selectedMenuOptionProvider)
    );

    return menuOptions;
  }
);

final jointMenuOptionProvider = FutureProvider.family<List<JointMenuOptionModel>, JointModel>(
  (ref, joint) async {
    // get the menu options
    List<JointMenuOptionModel> menuOptions = await joint.getMenuOptions();

    // set the first option as the active one
    if (menuOptions.isNotEmpty){
      ref.read(selectedMenuOptionProvider.notifier).state = menuOptions.first.id;
    }

    // refresh the menu items
    ref.invalidate(jointMenuItemsProvider(joint));

    return menuOptions;
  }
);

class FoodDetails extends ConsumerStatefulWidget {
  final JointModel joint;

  const FoodDetails({
    Key? key,
    required this.joint,
  }) : super(key: key);

  @override
  ConsumerState<FoodDetails> createState() => _FoodhomeState();
}

class _FoodhomeState extends ConsumerState<FoodDetails> {

  RefreshController refreshController = RefreshController(initialRefresh: false);

  Widget jointLogo() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(
            widget.joint.headerImage,
          )
        )
      ),
      width: MediaQuery.of(context).size.width,
      height: 200,
    );
  }

  Widget jointHeader() {
    return ListTile(
        subtitle: Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                widget.joint.location,
                style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
          ],
        ),
        leading: CircleAvatar(
          // backgroundColor: kPrimary,
          radius: 25,
          backgroundImage: CachedNetworkImageProvider(
            widget.joint.logo
          ),
        ),
        title: CustomText(
          text: widget.joint.name,
          fontSize: 18,
          isBold: true,
          color: kBlack,
        )
    );
  }

  Widget jointInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xffF7F7F9)
        ),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star,
                    size: 15,
                    color: Colors.black,
                  ),
                  SizedBox(width: 10,),
                  CustomText(
                    text: 'Rating ${widget.joint.rating}',
                    fontSize: 12,
                    color: kBlack,
                    isMediumWeight: true,
                  )
                ],
              ),
              SizedBox(height: 14,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.share_location,
                    size: 15,
                    color: Colors.black,
                  ),
                  SizedBox(width: 10,),
                  CustomText(
                    text: '1.4 kilometers',
                    fontSize: 12,
                    color: kBlack,
                    isMediumWeight: true,
                  )
                ],
              ),
              SizedBox(height: 14,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.delivery_dining,
                    size: 15,
                    color: Colors.black,
                  ),
                  SizedBox(width: 10,),
                  CustomText(
                    text: 'Delivery in ${widget.joint.deliveryTime}',
                    fontSize: 12,
                    color: kBlack,
                    isMediumWeight: true,
                  )
                ],
              ),
            ],
          ),
        )
      ),
    );
  }

  Widget jointMenuOptionTile() {
    final menuOptions = ref.watch(jointMenuOptionProvider(widget.joint));

    return menuOptions.when(
      data: (data){
        if (data.isEmpty){
          return Center(
            child: CustomText(
                text: "There is no menu"
            ),
          );
        }

        return SizedBox(
          height: 52,
          child: ListView.builder(
            itemCount: data.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index){
              return GestureDetector(
                onTap: () {
                  ref.read(selectedMenuOptionProvider.notifier).state = data[index].id;

                  // refresh the menu items list
                  ref.invalidate(jointMenuItemsProvider(widget.joint));
                  ref.read(jointMenuItemsProvider(widget.joint).future);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: JointMenuOption(
                    menuOption: data[index],
                    isActive: ref.read(selectedMenuOptionProvider) == data[index].id
                  ),
                ),
              );
            }
          ),
        );
      },
      error: (_, err){
        log(err.toString());
        return Center(
          child: CustomText(
              text: "An error occurred while fetching the menu"
          ),
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(
          color: kPrimary,
        )
      )
    );
  }

  Widget jointMenuItems() {

    final jointMenuOptionItems = ref.watch(jointMenuItemsProvider(widget.joint));

    return jointMenuOptionItems.when(
        data: (data){

          List<JointMenuItemModel> menuList = data;

          if (menuList.isEmpty){
            return Center(
              child: CustomText(
                  text: "There are no items for this option"
              ),
            );
          }

          return ListView.builder(
              itemCount: menuList.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.only(bottom: 23.0),
                  child: JointMenuItemTile(
                    menuItem: menuList[index],
                    joint: widget.joint,
                    selectedCategory: selectedMenuOptionProvider
                  ),
                );
              }
          );
        },
        error: (_, err){
          log(err.toString());
          return Center(
            child: CustomText(
                text: "An error occurred while fetching the menu items"
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            color: kPrimary,
          )
        )
    );
  }

  Widget itemInCart() {
    final cart = ref.watch(cartProvider(widget.joint));

    return cart.when(
      data: (data){
        List<FoodOrdersModel> cart = ref.read(cartInfoProvider).values.toList();

        return CartCard(
          joint: widget.joint,
          cartItems: cart
        );
      },
      error: (_, err) {
        log("Cart Error: ${err.toString()}");
        return SizedBox.shrink();

      } ,
      loading: () {
        log("loading Cart");
        return SizedBox.shrink();
      });
  }

  @override
  Widget build(BuildContext context) {
    final selectedOption = ref.watch(selectedMenuOptionProvider);
    final cartInfo = ref.watch(cartInfoProvider);
    final cart = ref.watch(cartProvider(widget.joint));
    final isFavorite = ref.watch(_favoriteProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              try{
                // update the favorite status of this item
                bool updateFavorite = await widget.joint.updateFavorites(
                  userID: ref.read(userProvider).uid,
                  school: ref.read(selectedSchoolProvider)
                );

                ref.read(_favoriteProvider.notifier).state = updateFavorite;
              }
              catch(exception){
                log(exception.toString());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "An error occurred while updating this favorite"
                    )
                  )
                );
              }
            },
            icon: Icon(
              Icons.favorite_outline,
              color: widget.joint.isFavorite == true
                ? kPrimary
                : kBlack,
            )
          )
        ],
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 12,
                ),
              ),
              Text(
                'Back',
                style: GoogleFonts.manrope(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: SmartRefresher(
              controller: refreshController,
              header: WaterDropHeader(),
              onRefresh: (){
                ref.invalidate(cartProvider(widget.joint));
                ref.invalidate(cartInfoProvider);
                ref.invalidate(jointMenuItemsProvider(widget.joint));

                ref.read(cartProvider(widget.joint).future);
                ref.read(cartInfoProvider);
                ref.read(jointMenuItemsProvider(widget.joint).future);
                refreshController.refreshCompleted();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    jointLogo(),
                    jointHeader(),
                    jointInfo(),
                    jointMenuOptionTile(),
                    SizedBox(height: 8,),
                    jointMenuItems(),
                    SizedBox(height: 80,)
                  ]
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: itemInCart(),
            ),
          )
        ],
      ),
    );
  }
}




