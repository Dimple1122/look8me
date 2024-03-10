import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/services/locator.dart';
import 'package:look8me/common/services/navigation_service.dart';
import 'package:look8me/common/utils/common_widgets.dart';
import 'package:look8me/screens/novel_view/bloc/novel_view_bloc.dart';
import 'package:pdfx/pdfx.dart';

class NovelView extends StatelessWidget with WidgetsBindingObserver {
  const NovelView({super.key});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NovelViewBloc>(context);
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
              titleSpacing: 5,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        bloc.add(UpdateContinueReadingDbEvent());
                        locator.get<NavigationService>().pop(bloc.readProgress);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  Column(
                    children: [
                      Text(
                        bloc.novel.novelName!,
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
                  const SizedBox()
                ],
              ),
              automaticallyImplyLeading: false,
            );
          },
        ),
      ),
      body: PopScope(
        onPopInvoked: (didPop) {
          if(didPop) {
            bloc.add(UpdateContinueReadingDbEvent());
          }
        },
        child: BlocConsumer<NovelViewBloc, NovelViewState>(
          listener: (context, state) {
            if (state is NovelViewLoadedState) {
              pdfController = PdfControllerPinch(
                  document: PdfDocument.openData(state.novelData!));
              page = 1;
              Future.delayed(const Duration(milliseconds: 500), () {
                page =
                    (pdfController.pagesCount! * bloc.readProgress).round();
                if (page > 0 && page != pdfController.pagesCount) {
                  pdfController.jumpToPage(page);
                  context
                      .read<NovelViewBloc>()
                      .add(UpdatePageAndReadProgressEvent(page: page, readProgress: page/pdfController.pagesCount!));
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
                          .add(UpdatePageAndReadProgressEvent(page: page, readProgress: page/pdfController.pagesCount!));
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
      ),
    );
  }
}
