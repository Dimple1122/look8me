import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/services/global_database_helper.dart';
import 'package:look8me/common/utils/common_widgets.dart';
import 'package:look8me/common/utils/enums.dart';
import 'package:look8me/screens/tabs/explore/bloc/explore_bloc.dart';

import '../../../../common/services/locator.dart';
import '../../../../common/services/navigation_service.dart';
import '../../../../routes/screen_name.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 120,
          backgroundColor: Colors.black,
          title: SafeArea(
              child: CommonWidget.getCredentialTextField(
                  context: context,
                  height: 60,
                  isObscure: false,
                  leadingIcon: const Icon(Icons.search, color: Colors.white),
                  type: TextFieldType.name,
                  onChanged: (value) {})),
        ),
        body: SingleChildScrollView(child:
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
                itemCount: GlobalDatabaseHelper.allNovels.length,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: GlobalDatabaseHelper.allNovels
                        .elementAt(index)
                        .novelImage!,
                    placeholder: (context, url) =>
                        Container(color: Colors.black12, height: 150, width: 150),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    imageBuilder: (context, imageProvider) => GestureDetector(
                      onTap: () {
                        locator.get<NavigationService>().navigateTo(
                            ScreenName.novelSummary,
                            arguments:
                                GlobalDatabaseHelper.allNovels.elementAt(index));
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.fill),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )));
  }
}
