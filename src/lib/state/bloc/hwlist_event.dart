part of 'hwlist_bloc.dart';

/*
    {_or: [{hw_state_id: {_is_null: $state_filter}}, {hw_state_id: {_in: $state_ids}}]},
    {_or: [{hw_type_id: {_is_null: $type_filter}}, {hw_type_id: {_in: $type_ids}}]},
    {_or: [{hw_dept_id: {_is_null: $dept_filter}}, {hw_dept_id: {_in: $dept_ids}}]},
    {_or: [{hw_cfgi_id: {_is_null: $cfgi_filter}}, {hw_cfgi_id: {_in: $cfgi_ids}}]},

*/



sealed class HwlistEvent {}

// class HwlistSignalLoading extends HwlistEvent {
//   HwlistSignalLoading();
// }

class HwlistLoad extends HwlistEvent {
  //
  bool      stateFilter = false;
  List<int> stateIds    = [];
  //
  bool      typeFilter = false;
  List<int> typeIds    = [];
  //
  bool      deptFilter = false;
  List<int> deptIds    = [];
  //
  bool      cfgiFilter = false;
  List<int> cfgiIds    = [];
  //
  bool      searchFilter = false;
  String    searchstr    = '%';

  //
  int limit = 500, offset = 0;
  Map<String,String> order = {"hw_invnum":"asc"};
  FetchPolicy? fetchPolicy;
  //


  // "searchstr": "%",
  // "search_filter": false,



  HwlistLoad({
    this.stateFilter = false, 
    this.stateIds = const [],
    this.typeFilter = false, 
    this.typeIds = const [],
    this.deptFilter = false, 
    this.deptIds = const [],
    this.cfgiFilter = false, 
    this.cfgiIds = const [],
    this.searchFilter = false,
    this.searchstr = '%',
    this.limit = 500, 
    this.offset = 0, 
    this.order = const {"hw_invnum":"asc"},
    this.fetchPolicy = FetchPolicy.networkOnly  //FetchPolicy.networkOnly //FetchPolicy.cacheFirst
    });
}
class HwlistLoadMore  extends HwlistEvent {
  int ncount = 10;
  HwlistLoadMore(this.ncount);
}



//variables { "state_id": 2, "limit" : 5, "offset": 10}