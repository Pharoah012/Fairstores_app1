import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/events/eventshome.dart';
import 'package:fairstores/food/foodpage.dart';
import 'package:fairstores/providers/authProvider.dart';
import 'package:fairstores/providers/historyProviders.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:fairstores/widgets/activeOrderTile.dart';
import 'package:fairstores/widgets/customButton.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/eventHistoryTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final _selectedOptionProvider = StateProvider.autoDispose<String>((ref) => "food");

class History extends ConsumerStatefulWidget {

  const History({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<History> createState() => _HistoryState();
}

class _HistoryState extends ConsumerState<History> {
  // List<bool> isvisible = [true, false];
  dynamic delivery = 0;
  String deliverytime = '';
  double taxes = 0;
  double servicecharge = 0;

  RefreshController _refreshController = RefreshController(initialRefresh: true);


  @override
  void initState() {
    super.initState();
  }


  Widget historyBlank() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
          ),
          Image.asset('images/blankhistory.png'),
          SizedBox(height: 20,),
          CustomText(
            text: "No Orders Yet",
            isBold: true,
            fontSize: 22,
          ),
          SizedBox(height: 2,),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: CustomText(
              text: 'When you place your first it will\n appear here.',
              isCenter: true,
            )
          ),
          SizedBox(height: 20,),
          CustomButton(
            onPressed: () {
              if (ref.read(_selectedOptionProvider) == 'food') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FoodPage())
                );
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventsPage())
                );
              }
            },
            isOrange: true,
            text: ref.read(_selectedOptionProvider) == 'food' ? 'Find Food' : 'Find Event',
          )
        ],
      ),
    );
  }

  Widget pageDisplay() {
    if (ref.read(_selectedOptionProvider) == 'food') {
      final activeOrders = ref.watch(activeOrdersProvider);
      final history = ref.watch(historyProvider);

      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Active Orders",
              color: kBlack,
              isMediumWeight: true,
            ),
            SizedBox(height: 20,),
            activeOrders.when(
              data: (data){
                if (data.isEmpty){
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Center(
                      child: CustomText(
                          text: "You have no active orders"
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ActiveOrderTile(
                        history: data[index],
                      ),
                    );
                  }
                );
              },
              error: (_, err){
                log(err.toString());
                return SizedBox.shrink();
              },
              loading: () => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Center(
                  child: CustomText(
                    text: "Fetching your active orders"
                  ),
                ),
              )
            ),
            CustomText(
              text: "History",
              color: kBlack,
              isMediumWeight: true,
            ),
            SizedBox(height: 20,),
            history.when(
                data: (data){
                  if (data.isEmpty){
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Center(
                        child: CustomText(
                            text: "You have no orders"
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: ActiveOrderTile(
                            history: data[index],
                          ),
                        );
                      }
                  );
                },
                error: (_, err){
                  log(err.toString());
                  return SizedBox.shrink();
                },
                loading: () => Container(
                  child: Center(
                    child: CustomText(
                        text: "Fetching your orders"
                    ),
                  ),
                )
            ),
          ],
        ),
      );
    } else if (ref.read(_selectedOptionProvider) == 'events') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(top: 10.0),
          //   child: StreamBuilder<QuerySnapshot>(
          //       stream: eventTicketsPurchaseRef
          //           .where('userid', isEqualTo: ref.read(authProvider).currentUser!.uid,)
          //           .snapshots(),
          //       builder: (context, snapshot) {
          //         if (!snapshot.hasData) {
          //           return Text('');
          //         }
          //
          //         List<EventHistoryTile> eventpurchaseslist = [];
          //
          //         for (var element in snapshot.data!.docs) {
          //           eventpurchaseslist
          //               .add(EventHistoryTile.fromDocument(element));
          //         }
          //         return Column(
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.only(
          //                   left: 20.0, top: 10, bottom: 7),
          //               child: Row(
          //                 children: [
          //                   eventpurchaseslist.isEmpty
          //                       ? const SizedBox(
          //                           height: 0,
          //                           width: 0,
          //                         )
          //                       : Text('Pending Tickets',
          //                           style: GoogleFonts.manrope(
          //                               fontWeight: FontWeight.w600,
          //                               fontSize: 14)),
          //                 ],
          //               ),
          //             ),
          //             Column(
          //               children: eventpurchaseslist,
          //             ),
          //           ],
          //         );
          //       }),
          // ),
          StreamBuilder<QuerySnapshot>(
              stream: eventhistoryRef
                  .doc(ref.read(authProvider).currentUser!.uid,)
                  .collection('history')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('');
                }

                List<ListTile> eventpurchaseslist = [];
                for (var element in snapshot.data!.docs) {
                  eventpurchaseslist.add(ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                    ),
                  ));
                }
                return eventpurchaseslist.isEmpty
                    ? historyBlank()
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 15),
                            child: Row(
                              children: [
                                Text('Tickets',
                                    style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                              ],
                            ),
                          ),
                          Column(
                            children: eventpurchaseslist,
                          )
                        ],
                      );
              }),
        ],
      );
    }

    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final _currentTab = ref.watch(_selectedOptionProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: "History",
        isCenter: false
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 48,
                width: MediaQuery.of(context).size.width * 0.65,
                decoration: BoxDecoration(
                  color: kPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          ref.read(_selectedOptionProvider.notifier).state = "food";
                        },
                        child: Container(
                          height: 33.6,
                          width: 100,
                          decoration: BoxDecoration(
                            color: ref.read(_selectedOptionProvider) == "food"
                              ? kPrimary
                              : Colors.transparent,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: CustomText(
                              text: 'Food',
                              fontSize: 12,
                              isMediumWeight: true,
                              color: ref.read(_selectedOptionProvider) == "food"
                                ? Colors.white
                                : Colors.black,
                            )
                          )
                        ),
                      ),
                      SizedBox(width: 13,),
                      GestureDetector(
                        onTap: () {
                          ref.read(_selectedOptionProvider.notifier).state = "events";
                        },
                        child: Container(
                          height: 33.6,
                          width: 100,
                          decoration: BoxDecoration(
                            color: ref.read(_selectedOptionProvider) == "events"
                                ? kPrimary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: CustomText(
                              text: 'Events',
                              fontSize: 12,
                                color: ref.read(_selectedOptionProvider) == "events"
                                    ? Colors.white
                                    : Colors.black,
                                isMediumWeight: true
                            ),
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                header: WaterDropHeader(),
                onRefresh: (){
                  ref.invalidate(activeOrdersProvider);
                  ref.invalidate(historyProvider);

                  ref.read(activeOrdersProvider.future);
                  ref.read(historyProvider.future);

                  _refreshController.refreshCompleted();
                },
                child: pageDisplay()
              ),
            ),
          ],
        ),
      ),
    );
  }
}