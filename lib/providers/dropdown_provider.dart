import 'package:fairstores/widgets/customDropdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class DropdownProvider extends StateNotifier<CustomDropdown> {

  DropdownProvider(CustomDropdown state) : super(state);


  void load({
    required List<String> items,
    String? label,
    required StateProvider<String> currentValue
  }){
    state = CustomDropdown(
      items: items,
      dropdownError: false,
      currentValue: currentValue,
      label: label,
    );
  }

  void showError({
    required List<String> items,
    required StateProvider<String> value,
    String? label
  }){
    state = CustomDropdown(
      items: items,
      dropdownError: true,
      currentValue: value,
      label: label,
    );
  }

  void removeError({
    required List<String> items,
    required StateProvider<String> value,
    String? label
  }){
    state = CustomDropdown(
      items: items,
      dropdownError: false,
      currentValue: value,
      label: label,
    );
  }

}