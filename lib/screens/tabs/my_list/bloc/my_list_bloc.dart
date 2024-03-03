import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'my_list_event.dart';
part 'my_list_state.dart';

class MyListBloc extends Bloc<MyListEvent, MyListState> {
  MyListBloc() : super(MyListInitial()) {
    on<MyListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
