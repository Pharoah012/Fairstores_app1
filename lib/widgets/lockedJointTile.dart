import 'package:fairstores/constants.dart';
import 'package:fairstores/models/jointModel.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';

class LockedJointTile extends StatelessWidget {
  final JointModel joint;

  const LockedJointTile({
    Key? key,
    required this.joint
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 19.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Currently Unavailable')));
                },
                child: Container(
                  width: 246,
                  height: 143,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: CustomText(
                      text: 'Currently Closed',
                      fontSize: 16,
                      color: kWhite,
                      isMediumWeight: true,
                    )
                  ),
                ),
              ),
              SizedBox(height: 8,),
              CustomText(
                text: joint.name,
                isMediumWeight: true,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: 'GHC ${joint.price}',
                      fontSize: 10,
                      isMediumWeight: true,
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
                      text: joint.deliveryTime,
                      fontSize: 10,
                      isMediumWeight: true,
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
