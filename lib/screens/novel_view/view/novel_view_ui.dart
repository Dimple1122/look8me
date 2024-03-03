import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/utils/common_widgets.dart';
import 'package:look8me/screens/novel_view/bloc/novel_view_bloc.dart';
import 'package:pdfx/pdfx.dart';

import '../../../common/model/novel_model.dart';

class NovelView extends StatelessWidget {
  final Novel novel;
  final double readProgress;

  const NovelView({super.key, required this.novel, required this.readProgress});

  @override
  Widget build(BuildContext context) {
    late final PdfControllerPinch pdfController;
    late int page;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: BlocBuilder<NovelViewBloc, NovelViewState>(
          buildWhen: (prevState, currentState) {
            return currentState is NovelViewLoadedState || currentState is UpdatedPageAndReadProgressState || currentState is NovelViewLoadFailedState;
          },
          builder: (context, state) {
            return AppBar(
              backgroundColor: Colors.black,
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    novel.novelName!,
                    style: const TextStyle(fontSize: 22, color: Colors.white),
                  ),
                  if(state is NovelViewLoadedState || state is UpdatedPageAndReadProgressState)
                    PdfPageNumber(
                      controller: pdfController,
                      // When `loadingState != PdfLoadingState.success`  `pagesCount` equals null_
                      builder: (_, state, loadingState, pagesCount) => Text(
                        '$page/${pagesCount ?? 0}',
                        style: const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    )
                  else
                    Container()
                ],
              ),
              leading: GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              leadingWidth: 0,
            );
          },
        ),
      ),
      body: BlocConsumer<NovelViewBloc, NovelViewState>(
        listener: (context, state) {
          if (state is NovelViewLoadedState) {
            pdfController = PdfControllerPinch(
                document: PdfDocument.openData(state.novelData!));
            page = 1;
            Future.delayed(const Duration(milliseconds: 500), () {
              page =
                  (pdfController.pagesCount! * readProgress).round();
              if (page > 0 && page != pdfController.pagesCount) {
                pdfController.jumpToPage(page);
                context
                    .read<NovelViewBloc>()
                    .add(UpdatePageAndReadProgressEvent(page: page));
              }
            });
          }
          if (state is UpdatedPageAndReadProgressState) {
            page = state.page;
          }
        },
        builder: (context, state) {
          if(state is NovelViewLoadingState) {
            return CommonWidget.getLoader();
          }
          else if (state is NovelViewLoadedState ||
              state is UpdatedPageAndReadProgressState) {
            return Row(
              children: [
                Expanded(
                    child: PdfViewPinch(
                  onDocumentError: (err) {
                    debugPrint('Error on Document Loading: $err');
                  },
                  onPageChanged: (page) {
                    context
                        .read<NovelViewBloc>()
                        .add(UpdatePageAndReadProgressEvent(page: page));
                  },
                  scrollDirection: Axis.vertical,
                  controller: pdfController,
                )),
                RotatedBox(
                  quarterTurns: 1,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    color: Colors.green,
                    value: pdfController.pagesCount != null
                        ? (page / pdfController.pagesCount!)
                        : 0,
                  ),
                )
              ],
            );
          }
          else {
            return Container();
          }
        },
      ),
    );
  }
}
