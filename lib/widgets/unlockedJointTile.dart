import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/food/foodhome.dart';
import 'package:fairstores/models/jointModel.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _favoriteProvider = StateProvider<bool>((ref) => false);

class UnlockedJointTile extends ConsumerStatefulWidget {
  final JointModel joint;


  UnlockedJointTile({
    Key? key,
    required this.joint
  }) : super(key: key);

  @override
  ConsumerState<UnlockedJointTile> createState() => _UnlockedFoodTileState();
}

class _UnlockedFoodTileState extends ConsumerState<UnlockedJointTile> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(_favoriteProvider.notifier).state = widget.joint.isFavorite;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(_favoriteProvider);

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Foodhome(
                  joint: widget.joint
                )
              )
            );
          },
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                height: 143,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        widget.joint.headerImage
                    )
                  ),
                  borderRadius: BorderRadius.circular(10)),
              ),
              IconButton(
                onPressed: () async  {
                  try{

                    // update the favorite status of this item
                    bool updateFavorite = await widget.joint.updateFavorites();

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
                  color: widget.joint.isFavorite
                    ? kPrimary
                      : kWhite,
                  size: 25,
                )
              )
            ],
          ),
        ),
        SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: widget.joint.name,
                  isMediumWeight: true,
                  color: kBlack,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: 'GHC ${widget.joint.price}',
                        isMediumWeight: true,
                        fontSize: 10,
                        color: kBlack,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 2,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomText(
                        text: widget.joint.deliveryTime,
                        isMediumWeight: true,
                        fontSize: 10,
                        color: kBlack,
                      )
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: [
                Image.asset('images/star.png'),
                SizedBox(width: 3,),
                CustomText(
                  text: widget.joint.rating.toString(),
                  isMediumWeight: true,
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
