import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/services/locator.dart';
import 'package:look8me/common/services/navigation_service.dart';
import 'package:look8me/common/utils/common_widgets.dart';
import 'package:look8me/routes/screen_name.dart';
import 'package:look8me/screens/tabs/my_list/bloc/my_list_bloc.dart';

class MyList extends StatelessWidget {
  const MyList({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MyListBloc>(context);
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'My List',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: BlocBuilder<MyListBloc, MyListState>(
          builder: (context, state) {
            return state is MyListLoadingState
                ? CommonWidget.getLoader()
                : bloc.myList.isEmpty && state is MyListLoadedState
                    ? const Center(
                        child: Text('Add Your Favorites here!',
                            style: TextStyle(
                                fontSize: 26,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold)))
                    : ListView.builder(
                        itemCount: bloc.myList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => locator.get<NavigationService>().navigateTo(ScreenName.novelSummary, arguments: bloc.myList.elementAt(index)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl:
                                        bloc.myList.elementAt(index).novelImage!,
                                    placeholder: (context, url) => Container(
                                      color: Colors.white38,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fill),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          bloc.myList.elementAt(index).novelName!,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                              color:
                                                  Colors.white.withOpacity(0.9))),
                                      Text(
                                          bloc.myList
                                              .elementAt(index)
                                              .novelCategory!,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color:
                                                  Colors.white.withOpacity(0.9)))
                                    ],
                                  )),
                                  GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                          bloc.myList.elementAt(index).novelName!,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 24,
                                                              color: Colors.white.withOpacity(0.9))),
                                                      const Divider(color: Colors.grey, thickness: 0.5),
                                                      const SizedBox(height: 5),
                                                      GestureDetector(
                                                          onTap: () {
                                                            locator.get<NavigationService>().goBack();
                                                            bloc.add(RemoveNovelFromMyListEvent(bloc.myList.elementAt(index).novelId!));
                                                          },
                                                          child: Row(mainAxisSize: MainAxisSize.max,children: [
                                                            const Icon(
                                                                Icons.check,
                                                                color: Colors.white70, size: 30),
                                                            const SizedBox(width: 5),
                                                            Text(
                                                                'Remove from My List',
                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                    color: Colors.white.withOpacity(0.9)))
                                                          ])),
                                                      const SizedBox(height: 10),
                                                      GestureDetector(
                                                          onTap: () {
                                                            locator.get<NavigationService>().goBack();
                                                            locator.get<NavigationService>().navigateTo(ScreenName.novelSummary, arguments: bloc.myList.elementAt(index));
                                                          },
                                                          child: Row(mainAxisSize: MainAxisSize.max, children: [
                                                            const Icon(
                                                                Icons.info_outline,
                                                                color: Colors.white70, size: 30),
                                                            const SizedBox(width: 5),
                                                            Text(
                                                                'View Details',
                                                                style: TextStyle(
                                                                    fontSize: 20,
                                                                    color: Colors.white.withOpacity(0.9)))
                                                          ]))
                                                    ]),
                                              );
                                            },
                                            shape:
                                                const ContinuousRectangleBorder(),
                                            backgroundColor:
                                                const Color(0xFF1e2529));
                                      },
                                      child: const Icon(Icons.more_vert,
                                          color: Colors.white70, size: 30))
                                ],
                              ),
                            ),
                          );
                        });
          },
        ));
  }
}
