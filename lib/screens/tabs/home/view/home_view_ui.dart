import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/model/novel_model.dart';
import 'package:look8me/common/services/locator.dart';
import 'package:look8me/common/services/navigation_service.dart';
import 'package:look8me/common/utils/app_strings.dart';
import 'package:look8me/common/utils/common_widgets.dart';
import 'package:look8me/routes/screen_name.dart';
import 'package:look8me/screens/tabs/home/bloc/home_bloc.dart';

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
      body: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) =>
            current is HomeLoadingState || current is HomeLoadedState,
        builder: (context, state) {
          return state is HomeLoadingState
              ? CommonWidget.getLoader()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
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
                                    component.category == AppStrings.topPicks || component.category == AppStrings.continueWatching ? const SizedBox() : const Icon(
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
                                    itemCount: component.category == AppStrings.topPicks || component.category == AppStrings.continueWatching ? component.novels.length : component.novels.length < 15
                                        ? component.novels.length
                                        : 15,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Stack(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: component.novels.elementAt(index).novelImage!,
                                              placeholder: (context, url) =>
                                                  Container(
                                                      color: Colors.black12,
                                                      height: 200,
                                                      width: 170),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                              imageBuilder: (context, imageProvider) =>
                                                  GestureDetector(
                                                    onTap: () {
                                                      locator.get<NavigationService>().navigateTo(ScreenName.novelSummary, arguments: component.novels.elementAt(index));
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
                                            component.category == AppStrings.continueWatching ? SizedBox(
                                              height: 200,
                                              width: 170,
                                              child: Stack(
                                                children: [
                                                  Positioned(right: 0, child: GestureDetector(child: const Icon(Icons.more_vert, size: 25, color: Colors.white))),
                                                  Positioned(width: 170, bottom: 0,child: LinearProgressIndicator(color: Colors.green, value: 0.4,borderRadius: BorderRadius.circular(10.0)))],
                                              ),
                                            ) : const SizedBox()
                                          ],
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
    );
  }
}
