import 'dart:developer';
import 'package:fairstores/constants.dart';
import 'package:fairstores/events/eventshome.dart';
import 'package:fairstores/food/foodpage.dart';
import 'package:fairstores/providers/historyProviders.dart';
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:fairstores/widgets/activeOrderTile.dart';
import 'package:fairstores/widgets/customButton.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/eventTicketHistoryTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  RefreshController _refreshController = RefreshController(initialRefresh: true);

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
      final pendingEventTickets = ref.watch(pendingEventTicketsProvider);
      final purchasedEventTickets = ref.watch(purchasedEventTicketsProvider);

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Pending Tickets"
          ),
          SizedBox(height: 15,),
          pendingEventTickets.when(
              data: (data){
                if (data.isEmpty){
                  return Center(
                    child: CustomText(
                        text: "You have no pending tickets"
                    ),
                  );
                }

                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: EventTicketHistoryTile(
                          eventHistoryItem: data[index],
                        ),
                      );
                    }
                );
              },
              error: (_, err){
                log(err.toString());
                return Center(
                  child: CustomText(
                      text: "An error occurred while fetching your pending tickets"
                  ),
                );
              },
              loading: () => Center(
                child: CustomText(
                    text: "Fetching your pending tickets"
                ),
              )
          ),
          SizedBox(height: 20,),
          CustomText(
            text: "Tickets"
          ),
          SizedBox(height: 15,),
          purchasedEventTickets.when(
              data: (data){
                if (data.isEmpty){
                  return Center(
                    child: CustomText(
                        text: "You have not purchased any tickets"
                    ),
                  );
                }

                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: EventTicketHistoryTile(
                          eventHistoryItem: data[index],
                        ),
                      );
                    }
                );
              },
              error: (_, err){
                log(err.toString());
                return Center(
                  child: CustomText(
                      text: "An error occurred while fetching your tickets"
                  ),
                );
              },
              loading: () => Center(
                child: CustomText(
                    text: "Fetching your purchased tickets"
                ),
              )
          ),
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
                  ref.invalidate(pendingEventTicketsProvider);
                  ref.invalidate(purchasedEventTicketsProvider);

                  ref.read(activeOrdersProvider.future);
                  ref.read(historyProvider.future);
                  ref.read(pendingEventTicketsProvider.future);
                  ref.read(purchasedEventTicketsProvider.future);

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