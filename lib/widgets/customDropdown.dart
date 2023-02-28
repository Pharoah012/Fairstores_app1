import 'dart:developer';

import 'package:fairstores/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdown extends ConsumerWidget {
  final List<String> items;
  StateProvider<String> currentValue;
  final bool dropdownError;
  final String? label;

  CustomDropdown({
    Key? key,
    required this.items,
    this.dropdownError = false,
    required this.currentValue,
    this.label
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log("DROPDOWN: " + items.toString());
    final _currentValue = ref.watch(currentValue);

    return SizedBox(
      child: DropdownButtonFormField<String>(
          validator: ((value) {
            if (value == "-Select School-") {
              return "Kindly select a school";
            } else {
              return null;
            }
          }),
          value: _currentValue,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: kPrimary,
                )
            ),
            focusColor: kPrimary,
            labelStyle: GoogleFonts.manrope(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: kLabelColor
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xffE5E5E5),
                ),
                borderRadius:
                BorderRadius.circular(10)
            ),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
                borderRadius:
                BorderRadius.circular(10)
            ),
          ),
          hint: const Text("Select School"),
          items: items.map((value) {
            return DropdownMenuItem<String>(
                child: Text(value), value: value);
          }).toList(),
          isExpanded: true,
          onChanged: (value) {
            ref.read(currentValue.notifier).state = value!;
          }),
    );
  }
}
