import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/models/notificationModel.dart';
import 'package:fairstores/providers/notificationProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/customButton.dart';
import 'package:fairstores/widgets/customLoader.dart';
import 'package:fairstores/widgets/customNotificationItem.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Notifications extends ConsumerStatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  ConsumerState<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends ConsumerState<Notifications> {

  RefreshController _refreshController = RefreshController(initialRefresh: true);


  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final notifications = ref.watch(notificationProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: (() {
              Navigator.pop(context);
            }),
            icon: const Icon(
              Icons.arrow_back,
              size: 15,
              color: Colors.black,
            )),
        centerTitle: true,
        title: CustomText(
          text: 'Notifications',
          fontSize: 16,
          color: kBlack,
          isMediumWeight: true,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          children: [
            SmartRefresher(
              controller: _refreshController,
              onRefresh: (){
                // refresh the provider
                ref.invalidate(notificationProvider);
                // wait for the refresh to end
                ref.read(notificationProvider.future);

                _refreshController.refreshCompleted();
              },
              child: notifications.when(
                data: (data){
                  if (data.isEmpty){
                    return Center(
                      child: CustomText(
                        text: "You don't have any notifications",
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index){
                      return CustomNotifiicationItem(
                        notification: data[index],
                      );
                    }
                  );
                },
                error: (_, err){
                  log(err.toString());
                  return Center(
                    child: CustomText(
                      text: "An error occurred while fetching your notifications",
                    ),
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(
                    color: kPrimary,
                  ),
                )
              ),
            ),
            Positioned(
              bottom: 30,
              right: 0,
              left: 0,
              child: CustomButton(
                isOrange: true,
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => CustomLoader()
                  );

                  await CustomNotificationModel.clearNotifications(
                    userID: user.uid
                  );

                  Navigator.of(context).pop();
                },
                text: "Clear All"
              ),
            )
          ],
        ),
      )
    );
  }
}
