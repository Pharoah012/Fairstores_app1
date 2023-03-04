import 'dart:developer';
import 'package:fairstores/constants.dart';
import 'package:fairstores/providers/favoriteFoodsProvider.dart';
import 'package:fairstores/providers/getFavoriteEvents.dart';
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:fairstores/widgets/customEventTile.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/lockedJointTile.dart';
import 'package:fairstores/widgets/unlockedJointTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final currentPage = StateProvider<String>((ref) => "food");

class SavedItems extends ConsumerStatefulWidget {
  const SavedItems({Key? key}) : super(key: key);

  @override
  ConsumerState<SavedItems> createState() => _SavedItemsState();
}

class _SavedItemsState extends ConsumerState<SavedItems> {

  RefreshController _refreshController = RefreshController(initialRefresh: true);

  Widget pagetoggle(page) {

    final _favoriteFoods = ref.watch(favoriteFoodsProvider);
    final _favoriteEvents = ref.watch(favoriteEventsProvider);

    if (page == 'food') {
      return _favoriteFoods.when(
        data: (data){
          if (data.isEmpty){
            return Center(
              child: CustomText(
                text: "No Favorites"
              ),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: data[index].lockshop
                  ? LockedJointTile(joint: data[index])
                  : UnlockedJointTile(joint: data[index]),
              );
            }
          );
        },
        error: (_, err){
          log(err.toString());
          return Center(
            child: CustomText(
                text: "An error occurred while getting your favorite foods"
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            color: kPrimary,
          ),
        )
      );
    }

    else {
      return _favoriteEvents.when(
          data: (data){
            if (data.isEmpty){
              return Center(
                child: CustomText(
                    text: "No Events"
                ),
              );
            }

            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index){
                  return CustomEventTile(event: data[index]);
                }
            );
          },
          error: (_, err){
            log(err.toString());
            return Center(
              child: CustomText(
                  text: "An error occurred while getting your favorite events"
              ),
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(
              color: kPrimary,
            ),
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _currentPage = ref.watch(currentPage);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Favorites'
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  ref.read(currentPage.notifier).state = "food";
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.59,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xfff25e37).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                              height: 33.6,
                              width: MediaQuery.of(context).size.width * 0.25,
                              decoration: BoxDecoration(
                                color:
                                    _currentPage == 'food' ? kPrimary : Colors.transparent,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: CustomText(
                                  text: 'Food',
                                  color: _currentPage == 'foods'
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 12,
                                  isMediumWeight: true,
                                )
                              )
                          ),
                        ),
                        SizedBox(width: 13,),
                        GestureDetector(
                          onTap: () {
                            ref.read(currentPage.notifier).state = "events";
                          },
                          child: Container(
                            height: 33.6,
                            width: 100,
                            decoration: BoxDecoration(
                              color: _currentPage == 'events'
                                  ? kPrimary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: CustomText(
                                text: 'Events',
                                color: _currentPage == 'events'
                                  ? Colors.white
                                  : Colors.black,
                                fontSize: 12,
                                isMediumWeight: true,
                              )
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Expanded(
              child: SmartRefresher(
                header: WaterDropHeader(),
                onRefresh: (){
                  ref.invalidate(favoriteFoodsProvider);
                  ref.invalidate(favoriteEventsProvider);

                  ref.read(favoriteEventsProvider.future);
                  ref.read(favoriteFoodsProvider.future);

                  _refreshController.refreshCompleted();
                },
                controller: _refreshController,
                child: pagetoggle(_currentPage)
              )
            )
          ],
        ),
      ),
    );
  }
}
