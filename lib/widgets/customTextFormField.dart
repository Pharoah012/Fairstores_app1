import 'package:fairstores/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatefulWidget {
  final bool isPassword;
  final String labelText;
  final bool isRequired;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    Key? key,
    this.isPassword = false,
    this.isRequired = true,
    required this.labelText,
    required this.controller,
    this.validator
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = widget.isPassword;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        validator: widget.validator ?? (value){

          if (widget.isRequired){
            if (value == null || value.isEmpty){
              return "${widget.labelText} cannot be empty";
            }

            return null;
          }
        },
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: kLabelColor
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimary),
            borderRadius: BorderRadius.circular(10)
          ),
          fillColor: kPrimary,
          focusColor: kPrimary,
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: kLabelColor
              ),
              borderRadius: BorderRadius.circular(10)
          ),
          suffixIcon: widget.isPassword ? GestureDetector(
            child: Icon(
              Icons.visibility,
              color: _obscureText == true
                  ? Colors.grey
                  : kPrimary,
            ),
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            }
          ) : SizedBox.shrink(),
        ),
      ),
    );
  }
}
