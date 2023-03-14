import 'package:fairstores/constants.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutPaymentOption extends ConsumerWidget {
  final String title;
  final AutoDisposeStateProvider<String?> networkProvider;

  const CheckoutPaymentOption({
    Key? key,
    required this.title,
    required this.networkProvider
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final network = ref.watch(networkProvider);

    return ListTile(
      onTap: () {
        ref.read(networkProvider.notifier).state = title;
      },
      leading: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(40)
            ),
            width: 20,
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                // border: Border.all(
                //     color: network == title
                //         ? Colors.grey
                //         : Colors.transparent
                // ),
                color: network == title
                    ? Colors.green
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(40)
            ),
            width: 15,
            height: 15,
          ),
        ],
      ),
      title: CustomText(
        text: title,
        fontSize: 16,
        isMediumWeight: true,
        color: kBlack,
      )
    );
  }
}
