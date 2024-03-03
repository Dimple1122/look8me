import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/model/novel_model.dart';
import 'package:look8me/common/services/locator.dart';
import 'package:look8me/common/services/navigation_service.dart';
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
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 22,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: component.novels.length < 15
                                  ? component.novels.length
                                  : 15,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: component.novels
                                        .elementAt(index)
                                        .novelImage!,
                                    placeholder: (context, url) =>
                                        Container(color: Colors.black12, height: 150, width: 150),
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                    imageBuilder:
                                        (context, imageProvider) =>
                                        GestureDetector(
                                          onTap: () {
                                            locator.get<NavigationService>().navigateTo(ScreenName.novelSummary, arguments: component.novels.elementAt(index));
                                          },
                                          child: Container(
                                            width: 150,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                        ),
                                  ),
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
