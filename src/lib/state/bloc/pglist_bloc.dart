
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pglist_event.dart';
part 'pglist_state.dart';

class PglistBloc extends Bloc<PglistEvent, PglistState> {
  PglistBloc(BuildContext context) : super(PglistInitial()) {
    on<PglistRebuild>((event, emit) {
      emit(PglistBuilded(event.addCount, event.reverse));
    });
  }
}
