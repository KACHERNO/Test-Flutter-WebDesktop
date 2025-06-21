part of 'hwdict_bloc.dart';


class HwdictStore {

  Map<String,dynamic>? _dicts;



  final List<int>    _stateKeys  = [];
  final List<String> _stateVals  = [];
  final List<int>    _typeKeys   = [];
  final List<String> _typeVals   = [];

  final List<int>    _deptKeys   = [];
  final List<String> _deptVals   = [];



  final List<int>    _typeCounts = [];

  Set<int> stateChoice = {};
  Set<int> typeChoice  = {};
  Set<int> cfgiChoice  = {};
  Set<int> deptChoice  = {};
  double   typeChoicePos = 0;

  List<int>     get getStateKeys  => _stateKeys;
  List<String>  get getStateVals  => _stateVals;
  List<int>     get getTypeKeys   => _typeKeys;
  List<String>  get getTypeVals   => _typeVals;

  List<int>     get getDeptKeys   => _deptKeys;
  List<String>  get getDeptVals   => _deptVals;


  List<int>     get getTypeCounts => _typeCounts;

  int           get getHwlistTotal => _dicts?["hw_list_aggregate"]["aggregate"]["count"]??0;

  //   hw_list_aggregate {
  //   aggregate { count }
  // }

  void clearFilters() {
  stateChoice = {};
  typeChoice  = {};
  deptChoice  = {};
  cfgiChoice  = {};
  }

  void parseDictionary() {
    var states = _dicts?["hw_states"];
    for (var row in states) {
      _stateKeys.add(row['state_id']);
      _stateVals.add(row['state_desc']);
    }

    var depts = _dicts?["hw_depts"];
    for (var row in depts) {
      _deptKeys.add(row['dept_id']);
      _deptVals.add(row['dept_desc']);
    }


    var types = _dicts?["hw_types"];
    for (var row in types) {
      _typeKeys.add(row['type_id']);
      _typeVals.add(row['type_desc']);
      _typeCounts.add(row['hw_lists_aggregate']['aggregate']['count']);
    }

  }


}

var storage = HwdictStore();




sealed class HwdictState {

  var store = storage;
  String? _errmsg;
  get getError  => _errmsg;  

  // Map<String,dynamic>? _dicts;

  // List<int>    _stateKeys  = [];
  // List<String> _stateVals  = [];
  // List<int>    _typeKeys   = [];
  // List<String> _typeVals   = [];

  // Set<int> stateChoice = {};
  // Set<int> typeChoice  = {};

  // List<int>     get getStateKeys => _stateKeys;
  // List<String>  get getStateVals => _stateVals;
  // List<int>     get getTypeKeys  => _typeKeys;
  // List<String>  get getTypeVals  => _typeVals;

  // void clearFilters() {
  // stateChoice = {};
  // typeChoice  = {};
  // }

  // void parseDictionary() {
  //   var states = _dicts?["hw_states"];
  //   for (var row in states) {
  //     _stateKeys.add(row['state_id']);
  //     _stateVals.add(row['state_desc']);
  //   }
  //   var types = _dicts?["hw_types"];
  //   for (var row in types) {
  //     _typeKeys.add(row['type_id']);
  //     _typeVals.add(row['type_desc']);
  //   }
  // }

}

final class HwdictInitial extends HwdictState {}

final class HwdictLoading extends HwdictState {}

final class HwdictLoaded  extends HwdictState {
    HwdictLoaded(Map<String,dynamic>? dicts) {
    super.store._dicts = dicts;
    super.store.parseDictionary();
  }
}

final class HwdictFailure extends HwdictState {
  HwdictFailure(String errmsg) {
    super._errmsg = errmsg;
  }
}


