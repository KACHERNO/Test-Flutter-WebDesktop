


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';

import 'auth_bloc.dart';

part 'hwdict_event.dart';
part 'hwdict_state.dart';


  // hw_types(order_by: {type_desc: asc}) {
  //   type_id
  //   type_desc




const String query = r"""
query HwDicts {
 hw_types(order_by: {type_id: asc}) {
    type_id
    type_desc
    hw_lists_aggregate 
      {
      aggregate 
        {
        count(columns: hw_cfgi_id)
        }
      }
    }
  hw_states(order_by: {state_id: asc}) {
    state_id
    state_desc
  }
  hw_depts(order_by: {dept_desc: asc}) {
    dept_id
    dept_desc
  }
  hw_cfgitems(order_by: {cfgi_desc: asc}) {
    cfgi_id
    cfgi_desc
  }
  hw_list_aggregate {
    aggregate { count }
  }
}
""";

class HwdictBloc extends Bloc<HwdictEvent, HwdictState> {
  HwdictBloc(BuildContext context) : super(HwdictInitial()) {

    on<HwdictClear>((event, emit) {
      emit(HwdictInitial());
    });


    on<HwdictLoad>((event, emit) async {

      String  errmsg = '';
      final client = BlocProvider.of<AuthBloc>(context).state.getClient;
      final result = await client.query(
        QueryOptions
            ( document: gql(query), 
              fetchPolicy: FetchPolicy.networkOnly ,
              /*
                variables: const <String, dynamic>{"variableName": "value"}
                fetchPolicy: FetchPolicy.cacheAndNetwork,
                errorPolicy: ErrorPolicy.none,
                cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
              */
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
         emit(HwdictFailure(errmsg));
       } else if (result.isLoading) {
         emit(HwdictLoading());
       } else {
         emit(HwdictLoaded(result.data));
       }


      // TODO: implement event handler
    });
  }
}
