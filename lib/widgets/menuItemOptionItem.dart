import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/models/menuItemOptionItemModel.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MenuItemOptionItem extends ConsumerWidget {
  final MenuItemOptionItemModel menuItemOptionItem;
  final StateProvider<int> selectedOptionsCountProvider;
  final AutoDisposeStateProvider<List<MenuItemOptionItemModel>> selectedSidesProvider;
  final int menuItemMaxSidesNumber;

  MenuItemOptionItem({
    Key? key,
    required this.menuItemOptionItem,
    required this.selectedOptionsCountProvider,
    required this.selectedSidesProvider,
    required this.menuItemMaxSidesNumber
  }) : super(key: key);

  final isSelectedProvider = StateProvider<bool>((ref) => false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _selectedSides = ref.watch(selectedSidesProvider);
    final _isSelected = ref.watch(isSelectedProvider);
    final _selectedNumber = ref.watch(selectedOptionsCountProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: menuItemOptionItem.name,
            color: kBlack,
            isMediumWeight: true,
          ),
          Row(
            children: [
              CustomText(
                text: "+GHS ${menuItemOptionItem.price.toString()}",
                color: kBlack,
                isMediumWeight: true,
                fontSize: 10,
              ),
              SizedBox(width: 9,),
              GestureDetector(
                onTap: (){

                  // check if the item has been selected
                  if (_isSelected){

                    // remove the item from the selected list
                    ref.read(selectedSidesProvider.notifier).state.remove(menuItemOptionItem);

                    // indicate that it has been unselected
                    ref.read(isSelectedProvider.notifier).state = !_isSelected;

                    // decrement the number of options selected
                    ref.read(selectedOptionsCountProvider.notifier).state = _selectedNumber - 1;
                  }
                  // check if the user can select this side
                  // if the currently selected number is less than the max
                  else if (_selectedNumber < menuItemMaxSidesNumber){

                    // add the menu item option item to the list of selected
                    ref.read(selectedSidesProvider.notifier).state.add(menuItemOptionItem);

                    // indicate that this item has been selected
                    ref.read(isSelectedProvider.notifier).state = !_isSelected;

                    // increment the number of options selected
                    ref.read(selectedOptionsCountProvider.notifier).state = _selectedNumber + 1;

                  }
                },
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kLabelColor
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: _isSelected
                    ? Center(
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: kGreen
                        ),
                      ),
                    )
                    : null,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
