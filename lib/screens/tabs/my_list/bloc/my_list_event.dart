part of 'my_list_bloc.dart';

abstract class MyListEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class LoadMyListEvent extends MyListEvent {}

class RemoveNovelFromMyListEvent extends MyListEvent {
  final String novelId;
  RemoveNovelFromMyListEvent(this.novelId);
}