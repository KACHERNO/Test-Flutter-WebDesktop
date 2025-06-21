import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';

import 'auth_bloc.dart';


part 'hwlist_event.dart';
part 'hwlist_state.dart';








const String query = r"""
query HwlistQuery
(
$state_ids: [Int!], 
$state_filter: Boolean!, 
$type_ids: [Int!], 
$type_filter: Boolean!, 
$dept_ids: [Int!], 
$dept_filter: Boolean!, 
$cfgi_ids: [Int!], 
$cfgi_filter: Boolean!, 
$searchstr: String!, 
$search_filter: Boolean, 
$limit: Int!, 
$offset: Int!, 
$order: [hw_list_view_order_by!]
) 
{
hw_list_view
(
where: 
{_and: [
{_or: [{hw_id: {_is_null: $state_filter}}, {hw_state_id: {_in: $state_ids}}]}, 
{_or: [{hw_id: {_is_null: $type_filter }}, {hw_type_id:  {_in: $type_ids}}]}, 
{_or: [{hw_id: {_is_null: $dept_filter }}, {hw_dept_id:  {_in: $dept_ids}}]}, 
{_or: [{hw_id: {_is_null: $cfgi_filter }}, {hw_cfgi_id:  {_in: $cfgi_ids}}]}, 
{_or: [{hw_id: {_is_null: $search_filter}}, 
       {hw_invnum : {_ilike: $searchstr}}, 
       {type_desc : {_ilike: $searchstr}}, 
       {cfgi_desc : {_ilike: $searchstr}}, 
       {dept_desc : {_ilike: $searchstr}}, 
       {state_desc: {_ilike: $searchstr}}
]}
]}, 
limit: $limit, 
offset: $offset, 
order_by: $order) 
{
hw_id
hw_invnum
hw_prodnum
hw_state_id
state_desc
type_desc
cfgi_desc
dept_desc
hw_room
}
hw_list_view_aggregate
(
where: 
{_and: [
{_or: [{hw_id: {_is_null: $state_filter}}, {hw_state_id: {_in: $state_ids}}]}, 
{_or: [{hw_id: {_is_null: $type_filter}},  {hw_type_id:  {_in: $type_ids}}]}, 
{_or: [{hw_id: {_is_null: $dept_filter}},  {hw_dept_id:  {_in: $dept_ids}}]}, 
{_or: [{hw_id: {_is_null: $cfgi_filter}},  {hw_cfgi_id:  {_in: $cfgi_ids}}]}, 
{_or: [{hw_id: {_is_null: $search_filter}}, 
       {hw_invnum:  {_ilike: $searchstr}}, 
       {type_desc:  {_ilike: $searchstr}}, 
       {cfgi_desc:  {_ilike: $searchstr}}, 
       {dept_desc:  {_ilike: $searchstr}}, 
       {state_desc: {_ilike: $searchstr}}
]}
]} 
)
{
aggregate 
{
count
}
}
}
""";

              /*
                variables: const <String, dynamic>{"variableName": "value"}
                fetchPolicy: FetchPolicy.cacheAndNetwork,
                errorPolicy: ErrorPolicy.none,
                cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
              */


const printDebugLevel = 0;

class HwlistBloc extends Bloc<HwlistEvent, HwlistState> {

void printDebug(String msg) {
  if (printDebugLevel > 0) {
    debugPrint('${DateTime.now()} [HwlistBloc:$hashCode] $msg');
  }
}



  HwlistBloc(BuildContext context) : super(HwlistInitial()) {

    // on<HwlistSignalLoading>((event, emit) async {
    //   emit(HwlistEndLoading());
    //   //emit(HwlistLoaded());
    // });

  // "searchstr": "%RAYbook Si1510%",
  // "search_filter": true,


    on<HwlistLoad>((event, emit) async {

printDebug('on<HwlistLoad>');

      String  errmsg = '';
      Map<String, dynamic> vars = {};
      state.store.stateFilter  = vars['state_filter']  = event.stateFilter;
      state.store.stateIds     = vars['state_ids']     = event.stateIds;
      state.store.typeFilter   = vars['type_filter']   = event.typeFilter;
      state.store.typeIds      = vars['type_ids']      = event.typeIds;
      state.store.deptFilter   = vars['dept_filter']   = event.deptFilter;
      state.store.deptIds      = vars['dept_ids']      = event.deptIds;
      state.store.cfgiFilter   = vars['cfgi_filter']   = event.cfgiFilter;
      state.store.cfgiIds      = vars['cfgi_ids']      = event.cfgiIds;

      state.store.searchFilter = vars['search_filter'] = event.searchFilter;
      state.store.searchstr    = vars['searchstr']     = event.searchstr;

      state.store.limit        = vars['limit']         = event.limit;
      state.store.offset       = vars['offset']        = event.offset;
      state.store.order        = vars['order']         = event.order;
      

printDebug('emit(HwlistLoading());');
      emit(HwlistLoading());
      //debugPrint('LOAD emit(HwlistLoading());');

      final client = BlocProvider.of<AuthBloc>(context).state.getClient;
      final result = await client.query(
        QueryOptions
            ( document: gql(query), 
              fetchPolicy: event.fetchPolicy,
              variables: vars
              ), 
        );



       if (result.hasException) {
         if (result.exception?.linkException != null) {
           errmsg = '${result.exception?.linkException.toString()}';
         } else if (result.exception?.graphqlErrors != null) {
         errmsg = '${result.exception?.graphqlErrors.first.message}';
         } else {
           errmsg = 'ERROR';
         }
         emit(HwlistFailure(errmsg));
         return;
       } 
       if (result.isLoading) {
         emit(HwlistLoading());
         //debugPrint('if (result.isLoading) {emit(HwlistLoading());}');        
       } 


        state.store.tableRowIndex = 0;
//state.store.searchController.text = '';
printDebug('emit(HwlistLoaded()) vars["limit"]=${vars['limit']} event.limit=${event.limit}');



         emit(HwlistLoaded(
          //result.data?['hw_list_view']??[], 
          result,
          result.data?['hw_list_view_aggregate']['aggregate']['count']??0,
          vars,
          1
          ));
          //debugPrint('LOAD emit(HwlistLoaded(');       
printDebug('STOP emit(HwlistLoaded()) result.data!["hw_list_view"].length=${result.data!['hw_list_view'].length}...');

    });

  on<HwlistLoadMore>((event, emit) async {

printDebug('on<HwlistLoadMore>');

    String  errmsg = '';
    final client = BlocProvider.of<AuthBloc>(context).state.getClient;
    if (state.store.getRowsCount < state.store.getTotal) {
      //
      Map<String, dynamic> varsOrig = {};
      varsOrig['state_filter']  = state.store.stateFilter;
      varsOrig['state_ids']     = state.store.stateIds;
      varsOrig['type_filter']   = state.store.typeFilter;
      varsOrig['type_ids']      = state.store.typeIds;
      varsOrig['dept_filter']   = state.store.deptFilter;
      varsOrig['dept_ids']      = state.store.deptIds;
      varsOrig['cfgi_filter']   = state.store.cfgiFilter;
      varsOrig['cfgi_ids']      = state.store.cfgiIds;

      varsOrig['search_filter'] = state.store.searchFilter;
      varsOrig['searchstr']     = state.store.searchstr;

      varsOrig['limit']         = state.store.limit;
      varsOrig['offset']        = state.store.offset;
      varsOrig['order']         = state.store.order;

      //
      Map<String, dynamic> varsMore = Map<String, dynamic>.from(varsOrig);
      varsMore['limit']  = event.ncount;
      varsMore['offset'] = state.store.getRowsCount;

      //debugPrint('Limit=${event.ncount} Offset=${state.getRowsCount}');

      //
      QueryOptions opts = QueryOptions(
        document: gql(query),
        variables: varsOrig
      );
      //
      FetchMoreOptions fmOpts = FetchMoreOptions(
        variables: varsMore,
        updateQuery: (previousResultData, fetchMoreResultData) {
        final List<dynamic> repos = [
          ...previousResultData?['hw_list_view']  as List<dynamic>,
          ...fetchMoreResultData?['hw_list_view'] as List<dynamic>
          ];
         fetchMoreResultData?['hw_list_view'] = repos;
         return fetchMoreResultData;
        }
      );
      //
printDebug('emit(HwlistLoading());');
      emit(HwlistLoading());
      //debugPrint('MORE emit(HwlistLoading());');
      final result = await client.fetchMore(
        fmOpts, 
        originalOptions: opts,  
        previousResult: state.store.result!
        //previousResult: state._result!
        );
      //
      if (result.hasException) {
         if (result.exception?.linkException != null) {
           errmsg = '${result.exception?.linkException.toString()}';
         } else if (result.exception?.graphqlErrors != null) {
         errmsg = '${result.exception?.graphqlErrors.first.message}';
         } else {
           errmsg = 'ERROR';
         }
         emit(HwlistFailure(errmsg));
         return;
       } 
       
       if (result.isLoading) {
         emit(HwlistLoading()); 
        //debugPrint('MORE LOADING');           
       }
//printDebug('emit(HwlistLoaded())');
      emit(HwlistLoaded(
        result,
        result.data?['hw_list_view_aggregate']['aggregate']['count']??0,
        varsMore,
        2
        )
        );
//printDebug('STOP emit(HwlistLoaded()) result.data!["hw_list_view"].length=${result.data!['hw_list_view'].length}...');
    }
  }
  );


  }
}
