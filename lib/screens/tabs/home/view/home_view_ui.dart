import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/model/novel_model.dart';
import 'package:look8me/common/services/global_database_helper.dart';
import 'package:look8me/common/services/locator.dart';
import 'package:look8me/common/services/navigation_service.dart';
import 'package:look8me/common/utils/app_strings.dart';
import 'package:look8me/common/utils/common_widgets.dart';
import 'package:look8me/routes/screen_name.dart';
import 'package:look8me/screens/tabs/home/bloc/home_bloc.dart';

import '../../../../common/model/bottom_sheet_modal_item.dart';
import '../../../../common/services/firebase/firebase_database_service.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeBloc>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/icons/app_icon.png'),
                        fit: BoxFit.fill))),
            GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.account_circle_outlined,
                  size: 40,
                  color: Colors.grey,
                ))
          ],
        ),
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if(state is HomeLoadedState) {
            bloc.continueReadingSubscription = locator
                .get<FirebaseDatabaseService>()
                .getContinueReadingNovelsRef(GlobalDatabaseHelper.currentUser!.userId!)
                .onValue
                .listen((DatabaseEvent event) {
              if (event.snapshot.exists) {
                bloc.add(GetUpdatedContinueReadingNovelsEvent());
              }
            });
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) =>
        current is HomeLoadingState || current is HomeLoadedState,
        builder: (context, state) {
          return state is HomeLoadingState 
              ? CommonWidget.getLoader() 
              : SingleChildScrollView(child: Padding(padding: const EdgeInsets.all(8.0), child: Column(
                children: [
                  BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        return bloc.continueReadingNovels.isNotEmpty ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                AppStrings.continueReading,
                                style: TextStyle(
                                    fontSize: 26, color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 220,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: bloc.continueReadingNovels.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Stack(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: bloc.continueReadingNovels.elementAt(index).novel.novelImage!,
                                                placeholder: (context, url) =>
                                                    Container(
                                                        color: Colors.black12,
                                                        height: 200,
                                                        width: 170),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                                imageBuilder: (context, imageProvider) =>
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await locator.get<NavigationService>().navigateTo(
                                                            ScreenName.novelView,
                                                            arguments: NovelWithReadProgress(
                                                                novel: bloc.continueReadingNovels.elementAt(index).novel,
                                                                readProgress: bloc.continueReadingNovels.elementAt(index).readProgress));
                                                      },
                                                      child: Container(
                                                        width: 170,
                                                        height: 200,
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: imageProvider,
                                                              fit: BoxFit.fill),
                                                        ),
                                                      ),
                                                    ),
                                              ),
                                              SizedBox(
                                                height: 200,
                                                width: 170,
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                        right: 0,
                                                        child: GestureDetector(
                                                            onTap: () => CommonWidget.showBottomModalSheet(
                                                                context: context,
                                                                title: bloc.continueReadingNovels.elementAt(index).novel.novelName!,
                                                                items: [
                                                                  BottomSheetModalItem(icon: Icons.close, itemName: 'Remove from Continue Reading', onTap: () {
                                                                    locator.get<NavigationService>().goBack();
                                                                    GlobalDatabaseHelper.removeNovelFromContinueReading(bloc.continueReadingNovels.elementAt(index).novel.novelId!);
                                                                  }),
                                                                  BottomSheetModalItem(icon: Icons.info_outline, itemName: 'View Details', onTap: () async {
                                                                    locator.get<NavigationService>().goBack();
                                                                    locator.get<NavigationService>().navigateTo(ScreenName.novelSummary, arguments: bloc.continueReadingNovels.elementAt(index).novel);
                                                                  })
                                                                ]
                                                            ),
                                                            child: const Icon(Icons.more_vert, size: 25, color: Colors.white))),
                                                    Positioned(width: 170, bottom: 0, child: LinearProgressIndicator(color: Colors.green, value: bloc.continueReadingNovels.elementAt(index).readProgress.toDouble(), borderRadius: BorderRadius.circular(10.0)))],
                                                ),
                                              )
                                            ],
                                          )
                                      );
                                    }),
                              )
                            ]
                        ) : const SizedBox();
                      }
                  ),
                  for (NovelByCategory component in bloc.homeComponents)
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Text(
                                component.category,
                                style: const TextStyle(
                                    fontSize: 26, color: Colors.white),
                              ),
                              component.category == AppStrings.topPicks ? const SizedBox() : const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 22,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 220,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: component.category == AppStrings.topPicks ? component.novels.length : component.novels.length < 15
                                  ? component.novels.length
                                  : 15,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CachedNetworkImage(
                                      imageUrl: component.novels.elementAt(index).novelImage!,
                                      placeholder: (context, url) => Container(color: Colors.black12, height: 200, width: 170),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                      imageBuilder: (context, imageProvider) =>
                                          GestureDetector(
                                            onTap: () async {
                                              await locator.get<NavigationService>().navigateTo(ScreenName.novelSummary, arguments: component.novels.elementAt(index));
                                            },
                                            child: Container(
                                              width: 170,
                                              height: 200,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.fill),
                                              ),
                                            ),
                                          ),
                                    )
                                );
                              }),
                        )
                      ],
                    )
                ],
              ),
            ),
          );
        },
      ),
),
    );
  }
}
