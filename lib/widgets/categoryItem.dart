import 'package:fairstores/constants.dart';
import 'package:fairstores/models/categoryModel.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatefulWidget {
  final bool isActive;
  final CategoryModel category;

  const CategoryItem({
    Key? key,
    required this.category,
    this.isActive = false
  }) : super(key: key);

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: kEnabledBorderColor
          ),
          color: widget.isActive
            ? kPrimary
            : Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 19,
              vertical: 8
            ),
            child: CustomText(
              text: widget.category.name,
              isMediumWeight: true,
              fontSize: 12,
              color: widget.isActive ? kWhite : kLabelColor
            )
          )
        )
      )
    );
  }
}
