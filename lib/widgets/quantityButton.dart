import 'dart:developer';

import 'package:fairstores/constants.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuantityButton extends ConsumerWidget {
  final StateProvider<int> quantityProvider;

  const QuantityButton({
    Key? key,
    required this.quantityProvider
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _count = ref.watch(quantityProvider);

    return ElevatedButton(
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: (){
              if (_count > 1){
                ref.read(quantityProvider.notifier).state = _count - 1;
              }
            },
            icon: Icon(
              Icons.remove,
              color: kBlack,
              size: 20,
            )
          ),
          CustomText(
            text: _count.toString(),
            color: kBlack,
            fontSize: 20,
          ),
          IconButton(
              onPressed: (){
                ref.read(quantityProvider.notifier).state = _count + 1;
              },
              icon: Icon(
                Icons.add,
                color: kBlack,
                size: 20,
              )
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: kWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: kEnabledBorderColor
          ),
          borderRadius: BorderRadius.circular(40.0),
        ),
        fixedSize: Size.fromHeight(56),
      ),
    );
  }
}
