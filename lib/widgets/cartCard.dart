import 'package:fairstores/constants.dart';
import 'package:fairstores/food/foodbag.dart';
import 'package:fairstores/models/foodOrdersModel.dart';
import 'package:fairstores/models/jointModel.dart';
import 'package:fairstores/providers/schoolListProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartCard extends ConsumerWidget {
  final JointModel joint;
  final List<FoodOrdersModel> cartItems;

  const CartCard({
    Key? key,
    required this.joint,
    required this.cartItems
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final selectedSchool = ref.watch(selectedSchoolProvider);

    return GestureDetector(
      onTap: (){

        if (cartItems.length > 0){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodBag(
                joint: joint
              ),
            )
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kPrimary,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('images/shoppingcart.png'),
                    SizedBox(width: 15,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'View Cart',
                          fontSize: 12,
                          isMediumWeight: true,
                          color: kWhite.withOpacity(0.64),
                        ),
                        SizedBox(height: 4,),
                        CustomText(
                          text: joint.name,
                          fontSize: 16,
                          isBold: true,
                          color: kWhite,
                        )
                      ],
                    ),
                  ],
                ),
                CustomText(
                  text: '${cartItems.length} '
                      '${cartItems.length == 1 ? "Item" : "Items"}',
                  fontSize: 14,
                  isBold: true,
                  color: kWhite,
                )
              ]
            ),
          ],
        ),
      ),
    );
  }
}
