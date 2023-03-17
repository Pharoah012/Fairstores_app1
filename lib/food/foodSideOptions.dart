import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/models/foodOrdersModel.dart';
import 'package:fairstores/models/jointMenuItemModel.dart';
import 'package:fairstores/models/jointModel.dart';
import 'package:fairstores/models/menuItemOptionItemModel.dart';
import 'package:fairstores/models/menuItemOptionModel.dart';
import 'package:fairstores/providers/cartInfoProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/customButton.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/customTextFormField.dart';
import 'package:fairstores/widgets/menuItemOptionItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

final selectedSidesProvider = StateProvider.autoDispose<List<MenuItemOptionItemModel>>(
  (ref) => []);

final requiredCheckerProvider = StateProvider.autoDispose<Map<String, StateProvider<int>>>((ref) => {});


class FoodSideOptions extends ConsumerStatefulWidget {
  final JointMenuItemModel menuItem;
  final JointModel joint;
  // final StateProvider<List<MenuItemOptionModel>> menuItemOptionsList;
  final FutureProviderFamily<List<MenuItemOptionModel>,
    Tuple3<
      JointMenuItemModel,
      JointModel,
      StateProvider<String>
    >> sideOptionsProvider;
  final Tuple3<
    JointMenuItemModel,
    JointModel,
    StateProvider<String>
  > menuItemInfo;

  const FoodSideOptions({
    required this.joint,
    required this.menuItem,
    required this.sideOptionsProvider,
    required this.menuItemInfo,
  });

  @override
  ConsumerState<FoodSideOptions> createState() => _FoodOptionsState();
}

class _FoodOptionsState extends ConsumerState<FoodSideOptions> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.invalidate(widget.sideOptionsProvider(widget.menuItemInfo));
    });
    super.initState();
  }

  String orderID = const Uuid().v4();
  TextEditingController instructionController = TextEditingController();

  final menuItemOptionItemsProvider = FutureProvider.family<
      List<MenuItemOptionItemModel>,
      Tuple4<
          JointMenuItemModel,
          JointModel,
          String,
          String
      >
  >(
      (ref, menuItemInfo) async {

        List<MenuItemOptionItemModel> sidesList = await menuItemInfo.item1.getMenuItemOptionList(
            jointID: menuItemInfo.item2.jointID,
            categoryID: menuItemInfo.item4,
            menuItemOptionID: menuItemInfo.item3
        );

        return sidesList;
      }
  );

  Widget optionsHeader() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                widget.menuItem.tileimage,
              )
            )
          ),
          width: MediaQuery.of(context).size.width,
          height: 200,
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                // border: Border.all(color: const Color(0xffE7E4E4)),
                color: Colors.white,
                borderRadius: BorderRadius.circular(100)),
              child: const Icon(
                Icons.close,
                size: 15,
                color: kDarkGrey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget menuItemDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: widget.menuItem.name,
          isBold: true,
          fontSize: 20,
          color: kBlack,
        ),
        SizedBox(height: 4,),
        CustomText(
          text: "GHS ${widget.menuItem.price.toDouble()}",
          fontSize: 12,
          color: kBlack,
          isMediumWeight: true,
        ),
        SizedBox(height: 8,),
        CustomText(
          text: widget.menuItem.description,
          fontSize: 10,
        )
      ],
    );
  }

  
  // check if options have been selected in required fields
  bool areAllRequiredFieldsFilled(){
    bool result = true;
    
    // iterate though the required fields to check if an option has been selected
    for (StateProvider<int> numberOfSelectedFields in ref.read(requiredCheckerProvider).values){
      if (ref.read(numberOfSelectedFields) < 1){
        result = false;
      }
    }
    
    return result;
  }

  Widget menuItemOptionItems(){

    log("CATEGORY ID: " + ref.read(widget.menuItemInfo.item3));
    log("JOINT ID: ${widget.menuItemInfo.item2.jointID}");
    log("MENU ITEM ID: ${widget.menuItemInfo.item1.id}");

    final sideOptions = ref.read(widget.sideOptionsProvider(widget.menuItemInfo));

    return sideOptions.when(
      data: (data){

        // check if there are no sides
        if (data.isEmpty){
          return Center(
            child: CustomText(
              text: "There are no sides",
            ),
          );
        }

        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index){

              // initialize the info needed to get the menu item option items
              Tuple4<
                JointMenuItemModel,
                JointModel,
                String,
                String
              > menuItemOptionItemInfo = Tuple4(
                widget.menuItem,
                widget.joint,
                data[index].id,
                ref.read(widget.menuItemInfo.item3)
              );

              final _menuItemOptionItemProvider = ref.watch(
                  menuItemOptionItemsProvider(menuItemOptionItemInfo)
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: data[index].name,
                          isMediumWeight: true,
                          color: kBrownText,
                        ),
                        data[index].isrequired
                            ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                              color: kLabelColor.withOpacity(0.20),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Center(
                            child: CustomText(
                              text: "Required",
                              fontSize: 8,
                              color: kBlack,
                            ),
                          ),
                        )
                            : SizedBox.shrink()
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: kWhite,
                    child: _menuItemOptionItemProvider.when(
                        data: (sideList){

                          if (sideList.isEmpty){
                            return Center(
                                child: CustomText(
                                    text: "There are no options"
                                )
                            );
                          }

                          // track the number of selected options
                          final selectedOptionsCountProvider = StateProvider<int>(
                                  (ref) => 0
                          );

                          // check if the option is required and create a field for it in the required
                          // field checker provider
                          if (data[index].isrequired){
                            ref.read(requiredCheckerProvider.notifier)
                                .state[sideList[index].id] = selectedOptionsCountProvider;
                          }

                          return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: sideList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, itemIndex){

                                return MenuItemOptionItem(
                                    menuItemOptionItem: sideList[itemIndex],
                                    selectedOptionsCountProvider: selectedOptionsCountProvider,
                                    selectedSidesProvider: selectedSidesProvider,
                                    menuItemMaxSidesNumber: data[index].maxitems
                                );
                              }
                          );
                        },
                        error: (_, err){
                          log(err.toString());
                          return Container(
                            height: 200,
                            color: kWhite,
                            child: Center(
                                child: CustomText(
                                    text: "An error occurred while fetching the options"
                                )
                            ),
                          );
                        },
                        loading: () => Container(
                          height: 200,
                          color: kWhite,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: kPrimary,
                            ),
                          ),
                        )
                    ),
                  )
                ],
              );
            }
        );

      },
      error: (_, err){
        log(err.toString());
        return Center(
          child: CustomText(
            text: "An error occurred while fetching the sides",
          ),
        );
      },
      loading: ()=> Center(
        child: CircularProgressIndicator(
          color: kPrimary,
        ),
      )
    );
  }

  Widget optionsFooter() {
    return SafeArea(
      bottom: false,
      child: Container(
        color: kWhite,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: "Instructions",
                fontSize: 16,
                color: kBlack,
                isMediumWeight: true,
              ),
              CustomText(
                text: 'Let us know if you have specific things in mind',
              ),
              SizedBox(height: 15,),
              CustomTextFormField(
                labelText: 'Leave a note for the kitchen',
                controller: instructionController,
                isRequired: false,
              ),
              SizedBox(height: 18,),
              CustomButton(
                onPressed: () async {

                  // check if all the required option are selected
                  if (!areAllRequiredFieldsFilled()){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select all required options')
                      )
                    );
                  }

                  // Create the order model
                  FoodOrdersModel order = FoodOrdersModel(
                    sides: ref.read(selectedSidesProvider).map(
                      (object) => object.toJson()
                    ).toList(),
                    jointID: widget.joint.jointID,
                    orderID: orderID,
                    price: widget.menuItem.price,
                    image: widget.menuItem.tileimage,
                    foodName: widget.menuItem.name,
                    quantity: 1,
                    status: "pending",
                    cartID: "cart${ref.read(userProvider).uid}"
                  );

                  // add the order to the cart
                  try{
                    await order.placeOrder(
                        userID: ref.read(userProvider).uid
                    );

                    ref.invalidate(cartProvider(widget.joint));

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                              "Your item has been added to cart"
                            )
                        )
                    );

                    // remove the drawer
                    Navigator.of(context).pop();
                  } catch (exception) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Unable to add to cart. Please try again later."
                            )
                        )
                    );
                  }
                },
                isOrange: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    CustomText(
                      text: 'Add to Bag',
                      fontSize: 16,
                      color: kWhite,
                      isMediumWeight: true,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    // watch the sides
    final sides = ref.watch(widget.sideOptionsProvider(widget.menuItemInfo));
    
    // watch the required fields
    final _requiredFieldChecker = ref.watch(requiredCheckerProvider);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: kWhite,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20,
                        bottom: 20
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 23,),
                          optionsHeader(),
                          SizedBox(height: 12,),
                          menuItemDetails()
                        ],
                      ),
                    ),
                  ),
                  menuItemOptionItems(),
                ]
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: optionsFooter()
          )
        ],
      ),
    );
  }
}
