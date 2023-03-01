import 'package:fairstores/constants.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(50);

}

class _CustomAppBarState extends State<CustomAppBar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: kBlack
      ),
      leadingWidth: 81,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 20,),
            Icon(Icons.arrow_back_ios),
            CustomText(
              text: "Back",
              isMediumWeight: true,
              fontSize: 16,
              color: Colors.black,
            )
          ],
        ),
      ),
      elevation: 0,
      title: CustomText(
        text: widget.title,
        color: kBlack,
        fontSize: 16,
        isMediumWeight: true,
      ),
      centerTitle: true,
    );
  }
}
