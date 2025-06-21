part of 'pglist_bloc.dart';

//@immutable
sealed class PglistEvent {}

final class PglistRebuild extends PglistEvent {

  int  addCount = 0;
  bool reverse  = false;


  PglistRebuild({this.addCount = 10, this.reverse = false});
}