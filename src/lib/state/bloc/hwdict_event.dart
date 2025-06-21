part of 'hwdict_bloc.dart';


sealed class HwdictEvent {}

class HwdictLoad extends HwdictEvent {}
class HwdictClear extends HwdictEvent {}
