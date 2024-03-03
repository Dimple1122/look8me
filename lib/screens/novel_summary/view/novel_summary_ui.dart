import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/services/locator.dart';
import 'package:look8me/common/services/navigation_service.dart';
import 'package:look8me/common/utils/common_widgets.dart';
import 'package:look8me/screens/novel_summary/bloc/novel_summary_bloc.dart';
import 'package:look8me/screens/novel_summary/view/user_action_item.dart';
import 'package:share_plus/share_plus.dart';

import '../../../common/services/firebase/firebase_database_service.dart';

class NovelSummary extends StatelessWidget {
  const NovelSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NovelSummaryBloc>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        titleSpacing: 5,
        title: Row(
          children: [
            GestureDetector(
              child: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onTap: () => locator.get<NavigationService>().goBack(),
            ),
            const SizedBox(width: 5),
            Text(
              bloc.novel.novelName!,
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ],
        ),
      ),
      body: BlocListener<NovelSummaryBloc, NovelSummaryState>(
        listener: (context, state) {
          if (state is NovelSummaryLoadedState) {
            bloc.noOfLikesSubscription = locator
                .get<FirebaseDatabaseService>()
                .getNoOfLikesRef(bloc.novelIndex)
                .onValue
                .listen((DatabaseEvent event) {
              if (event.snapshot.exists) {
                bloc.noOfLikes = event.snapshot.value as int;
                bloc.add(NovelNoOfLikesUpdateEvent());
              }
            });
          }
        },
        child: BlocBuilder<NovelSummaryBloc, NovelSummaryState>(
          buildWhen: (previous, current) =>
              current is NovelSummaryLoadingState ||
              current is NovelSummaryLoadedState,
          builder: (context, state) {
            return state is NovelSummaryLoadingState
                ? CommonWidget.getLoader()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: CachedNetworkImage(
                            imageUrl: bloc.novel.novelImage!,
                            placeholder: (context, url) => Container(
                              color: Colors.white38,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            imageBuilder: (context, imageProvider) => Container(
                              height: 300,
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.fill),
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<NovelSummaryBloc, NovelSummaryState>(
                            buildWhen: (_, current) =>
                                current is NovelReadProgressUpdateState,
                            builder: (context, state) {
                              return Stack(
                                children: [
                                  Theme(
                                    data: ThemeData(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                    ),
                                    child: CommonWidget.getElevatedButton(
                                        context: context,
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        name: bloc.readProgress == 0.0
                                            ? 'Read'
                                            : 'Resume Reading',
                                        onPressed: () {},
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        borderRadius: 0,
                                        buttonIcon: const Icon(
                                          Icons.receipt,
                                          color: Colors.black,
                                        )),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      child: LinearProgressIndicator(
                                          value: bloc.readProgress,
                                          color: Colors.green,
                                          backgroundColor: Colors.transparent),
                                    ),
                                  )
                                ],
                              );
                            }),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            BlocBuilder<NovelSummaryBloc, NovelSummaryState>(
                                builder: (context, state) {
                              return UserActionItem(
                                  activeIcon: Icons.thumb_up,
                                  inActiveIcon: Icons.thumb_up_outlined,
                                  isIconActive: bloc.isLiked,
                                  text: '${bloc.noOfLikes}',
                                  onTap: () {
                                    bloc.add(NovelLikeUpdateEvent());
                                  });
                            }),
                            BlocBuilder<NovelSummaryBloc, NovelSummaryState>(
                                builder: (context, state) {
                              return UserActionItem(
                                  activeIcon: Icons.check,
                                  inActiveIcon: Icons.add,
                                  isIconActive: bloc.isAddedToMyList,
                                  text: 'My List',
                                  onTap: () {
                                    bloc.add(NovelAddToListUpdateEvent());
                                  });
                            }),
                            BlocBuilder<NovelSummaryBloc, NovelSummaryState>(
                                builder: (context, state) {
                              return UserActionItem(
                                  inActiveIcon: Icons.share,
                                  text: 'Share',
                                  onTap: () {
                                    Share.share("Install Look8Me & Read your favorite novels");
                                  });
                            })
                          ],
                        ),
                        BlocBuilder<NovelSummaryBloc, NovelSummaryState>(
                          buildWhen: (_, current) =>
                              current is NovelSummaryTextTapState,
                          builder: (context, state) {
                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: GestureDetector(
                                onTap: () =>
                                    bloc.add(NovelSummaryTextTapEvent()),
                                child: Text(
                                    !bloc.isFullSummary &&
                                            bloc.summaryText.length > 150
                                        ? '${bloc.summaryText.substring(0, 150)}...'
                                        : bloc.summaryText,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white70)),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
