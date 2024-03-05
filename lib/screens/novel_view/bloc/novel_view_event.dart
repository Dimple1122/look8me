part of 'novel_view_bloc.dart';

abstract class NovelViewEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class NovelViewInitializationEvent extends NovelViewEvent {}

class UpdatePageAndReadProgressEvent extends NovelViewEvent {
  final int page;
  final double readProgress;
  UpdatePageAndReadProgressEvent({required this.page, required this.readProgress});
}