import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/models/JointMenuOption.dart';
import 'package:fairstores/models/cartListProvider.dart';
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
final menuItemsListProvider = StateProvider<List<JointMenuItemModel>>((ref) => []);
final foodCartListProvider = StateProvider((ref) => []);
final _favoriteProvider = StateProvider<bool>((ref) => false);

final jointMenuItemsProvider = FutureProvider.autoDispose.family<List<JointMenuItemModel>, JointModel>(
  (ref, joint) async {

    // get the menu items for the selected menu category
    List<JointMenuItemModel> menuOptions = await joint.getMenuOptionItems(
      menuOption: ref.read(selectedMenuOptionProvider)
    );

    // assign the list of the list of menu items to the menu item provider
    ref.read(menuItemsListProvider.notifier).state = menuOptions;

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

    // refresh the menu items list
    ref.invalidate(jointMenuItemsProvider(joint));

    return menuOptions;
  }
);

final cartProvider = FutureProvider.family<List<FoodOrdersModel>, JointModel>(
        (ref, joint) async {

      // get the cart items
      List<FoodOrdersModel> orders = await FoodOrdersModel.getJointOrders(
        jointID: joint.jointID,
        userID: ref.read(userProvider).uid
      );

      // load the orders into the cart list provider
      ref.read(cartListProvider.notifier).state = orders;

      return orders;
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
                  log((ref.read(selectedMenuOptionProvider) == data[index].id).toString());
                  ref.invalidate(jointMenuItemsProvider);
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
        child: CustomText(
            text: "Fetching the menu"
        ),
      )
    );
  }

  jointMenuItems() {

    final jointMenuOptionItems = ref.watch(jointMenuItemsProvider(widget.joint));

    return jointMenuOptionItems.when(
        data: (data){

          List<JointMenuItemModel> menuList = ref.read(menuItemsListProvider);

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
          child: CustomText(
              text: "Fetching the menu items"
          ),
        )
    );
  }

  Widget itemInCart() {
    final cart = ref.watch(cartProvider(widget.joint));

    return cart.when(
      data: (data){
        List<FoodOrdersModel> cart = ref.read(cartListProvider);

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

    // return StreamBuilder<QuerySnapshot>(
    //     stream: foodCartRef
    //         .doc(ref.read(userProvider).uid)
    //         .collection('Orders')
    //         .where('shopid', isEqualTo: widget.joint.jointID)
    //         .snapshots(),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) {
    //         return const SizedBox();
    //       }
    //
    //       List<Text> foodcartlist = [];
    //       itemplural() {
    //         String plural = 'Item';
    //         if (foodcartlist.length == 1) {
    //           plural = 'Item';
    //           return 'Item';
    //         } else if (foodcartlist.isEmpty) {
    //           return 0;
    //         } else {
    //           plural = 'Items';
    //           return plural;
    //         }
    //       }
    //
    //       for (var doc in snapshot.data!.docs) {
    //         foodcartlist.add(const Text('available'));
    //       }
    //       return foodcartlist.isEmpty
    //           ? const SizedBox()
    //           : Padding(
    //               padding:
    //                   const EdgeInsets.only(left: 20.0, right: 18, bottom: 27),
    //               child: Container(
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(12),
    //                   boxShadow: [
    //                     BoxShadow(
    //                       color: const Color(0xff010F07).withOpacity(0.12),
    //                       spreadRadius: 5,
    //                       blurRadius: 7,
    //                       offset:
    //                           const Offset(0, 20), // changes position of shadow
    //                     ),
    //                   ],
    //                   color: kPrimary,
    //                 ),
    //                 width: MediaQuery.of(context).size.width,
    //                 height: 70,
    //                 child: MaterialButton(
    //                   onPressed: (() {
    //                     Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                           builder: (context) => FoodBag(
    //                             shopid: widget.joint.jointID,
    //                             user: ref.read(userProvider).uid,
    //                             schoolname: ref.read(userProvider).school!,
    //                           ),
    //                         ));
    //                   }),
    //                   child: Row(children: [
    //                     Image.asset('images/shoppingcart.png'),
    //                     Padding(
    //                       padding: const EdgeInsets.only(left: 15.0),
    //                       child: Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Text(
    //                             'View Cart',
    //                             style: GoogleFonts.manrope(
    //                                 fontWeight: FontWeight.w500,
    //                                 fontSize: 12,
    //                                 color: Colors.white.withOpacity(0.64)),
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.only(top: 4.0),
    //                             child: Text(widget.joint.name,
    //                                 style: GoogleFonts.manrope(
    //                                     fontWeight: FontWeight.w600,
    //                                     fontSize: 16,
    //                                     color: Colors.white)),
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                     Expanded(child: const SizedBox()),
    //                     Text(
    //                       '${foodcartlist.length} ${itemplural()}',
    //                       style: GoogleFonts.manrope(
    //                           fontSize: 14,
    //                           fontWeight: FontWeight.w600,
    //                           color: Colors.white),
    //                     )
    //                   ]),
    //                 ),
    //               ),
    //             );
    //     });
  }

  @override
  Widget build(BuildContext context) {
    final selectedOption = ref.watch(selectedMenuOptionProvider);
    final menuListItems = ref.watch(menuItemsListProvider);
    final cartList = ref.watch(cartListProvider);
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
                ref.invalidate(jointMenuItemsProvider(widget.joint));

                ref.read(cartProvider(widget.joint).future);
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




