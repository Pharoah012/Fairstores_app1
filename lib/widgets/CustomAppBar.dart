import 'dart:developer';
import 'package:fairstores/constants.dart';
import 'package:fairstores/providers/schoolListProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final String? title;
  final bool isDropdown;
  final StateProvider<String>? currentLocationProvider;
  final bool isCenter;

  const CustomAppBar({
    Key? key,
    this.title,
    this.isDropdown = false,
    this.isCenter = true,
    this.currentLocationProvider
  }) : super(key: key);

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(isDropdown ? 70 : 50);

}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {

  @override
  Widget build(BuildContext context) {
    if (widget.isDropdown){
      final _schoolsProvider = ref.watch(schoolsProvider);
      final _currentLocationProvider = ref.watch(widget.currentLocationProvider!);
    }


    return widget.isDropdown
      ? dropdownAppBar()
      : !widget.isCenter
        ? leftSidedHeader()
        : standardAppBar();
  }

  Widget dropdownAppBar(){
    return AppBar(
      iconTheme: IconThemeData(
          color: kBlack
      ),
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      // leadingWidth: 10,
      // leading: widget.child!,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              padding: const EdgeInsets.only(top: 8),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close)
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 150,
                // height: 50,
                child: DropdownButton<dynamic>(
                    isDense: true,
                    elevation: 0,
                    underline: SizedBox.shrink(),
                    hint: CustomText(
                      text: 'Your Location',
                      fontSize: 12,
                    ),
                    items: ref.read(schoolsProvider).when(
                        data: (data) => data.map(
                                (element) => DropdownMenuItem(
                                value: element,
                                child: Text(element)
                            )
                        ).toList(),
                        error: (_, err){
                          log(err.toString());
                          return [
                            DropdownMenuItem(
                                child: Text(
                                    ref.read(userProvider).school!
                                )
                            )
                          ];
                        },
                        loading: () => [
                          DropdownMenuItem(
                              child: Text(
                                  ref.read(userProvider).school!
                              )
                          )
                        ]
                    ),
                    isExpanded: true,
                    onChanged: (value) {
                      ref.read(widget.currentLocationProvider!.notifier).state = value;
                    }
                ),
              ),
              CustomText(
                text: ref.read(widget.currentLocationProvider!),
                fontSize: 12,
                isBold: true,
                color: kBlack,
              )
            ],
          )
        ],
      ),
      elevation: 0,
      centerTitle: false,
    );
  }

  Widget standardAppBar(){
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
        text: widget.title!,
        color: kBlack,
        fontSize: 16,
        isMediumWeight: true,
      ),
      centerTitle: true,
    );
  }

  Widget leftSidedHeader(){
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      title: CustomText(
        text: widget.title!,
        color: kBlack,
        fontSize: 22,
        isMediumWeight: true,
      ),
      centerTitle: false,
    );
  }
}
