import 'package:fairstores/constants.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';

class CustomSettingsListTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const CustomSettingsListTile({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: kPrimary,
      ),
      title: CustomText(
        text: label,
        isMediumWeight: true,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
      ),
    );
  }
}
