import 'package:fairstores/constants.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';

class CustomHomeOption extends StatelessWidget {
  final bool isVertical;
  final Widget nextScreen;
  final Color color;
  final String title;
  final Image image;

  const CustomHomeOption({
    Key? key,
    this.isVertical = false,
    required this.nextScreen,
    required this.image,
    required this.title,
    required this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => nextScreen
          )
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16)
        ),
        child: isVertical
          ? verticalHomeOption()
          : horizontalHomeOption(),
      ),
    );
  }

  Widget verticalHomeOption(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title,
            isMediumWeight: true,
            fontSize: 16,
            color: kBlack,
          ),
          SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: image,
          )
        ],
      ),
    );
  }

  Widget horizontalHomeOption(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title,
            isMediumWeight: true,
            fontSize: 16,
            color: kBlack,
          ),
          image
        ],
      ),
    );
  }
}
