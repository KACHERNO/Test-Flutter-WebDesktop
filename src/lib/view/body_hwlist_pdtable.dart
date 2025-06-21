
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/bloc/hwdict_bloc.dart';
import '../state/bloc/hwlist_bloc.dart';
import '../state/bloc/pglist_bloc.dart';
import 'dialog_hwlist_detail.dart';
import 'dialog_hwlist_filter.dart';
// import 'package:loader_overlay/loader_overlay.dart';

class HwListPDTable  {
  Widget getPDTable(BuildContext context) {

    final hwlbloc = BlocProvider.of<HwlistBloc>(context);
    //final hwdbloc = BlocProvider.of<HwdictBloc>(context);
    GlobalKey<PaginatedDataTableState> tableKey = GlobalKey<PaginatedDataTableState>();
    // if (hwdbloc.state is HwdictInitial) {
    //   hwdbloc.add(HwdictLoad());
    // }

    if (hwlbloc.state is HwlistInitial) {
      hwlbloc.add(HwlistLoad());
    }
    return //LoaderOverlay( child: 
    
      BlocConsumer<HwlistBloc, HwlistState>(
        listener: (context, hwlstate) { 
         },
        builder:  (context, state) {
        final searchFocusNode = FocusNode();


          return
            ListView(
              children: [
              SizedBox(
                height: 5,
                child: state is HwlistLoading || state is HwlistInitial ? const LinearProgressIndicator() : const SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: tableHeader(context, searchFocusNode)),
                ),
              if (filterText(context) != '')
              ListTile(
                leading: Icon(Icons.filter_alt, color: Theme.of(context).colorScheme.primary,),
                title: Text(filterText(context), style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary,),),),
              if (state is HwlistLoaded)
              PaginatedDataTable(
                key: tableKey,
                columnSpacing: 10,
                
                //header: tableHeader(context, searchFocusNode),
                initialFirstRowIndex: state.store.tableRowIndex ,//> state.store.getRowsCount ? 0 : state.store.tableRowIndex,
                columns: List<DataColumn>.generate(
                  state.store.tableFields.length + 1,
                  (i) { 
                    return i == 0 ?
                    DataColumn(label: const Text(''), onSort: (ind,asc) {})
                    :
                    //DataColumn(label: Text('${state.store.tableFields[i]['label']}'), onSort: (ind,asc) {onsortColum(ind, asc);}); }
                    DataColumn(label: Text('${state.store.tableFields[i-1]['label']}'), onSort: (ind,asc) {onsortColum(context, ind, asc);}); 
                    }
                  ),
                source: HwTableDataSource(context,hwlbloc),
                onPageChanged: (rn) { state.store.tableRowIndex = rn;},
                sortColumnIndex: state.store.tableSortColumn,
                sortAscending: state.store.tableSortAsc,
                showFirstLastButtons: true,
              ),
            
              ]
            );
      
//          }
      
          // if ( state is HwlistInitial) {
          //   return const Center(child: 
          //     //CircularProgressIndicator(),
          //     LinearProgressIndicator(),
          //   ); // LinearProgressIndicator()
          // } 
          // return Container();
        },
      );
    //);
  }


String filterText(BuildContext context) {
  final hwlBloc   = BlocProvider.of<HwlistBloc>(context);
  final hwdBloc   = BlocProvider.of<HwdictBloc>(context);

  String result = '';

  if (hwdBloc.state.store.typeChoice.isNotEmpty) {
    result = 'Тип актива: ';
    for ( 
      var i=0, 
      choices=hwdBloc.state.store.typeChoice,
      keys=hwdBloc.state.store.getTypeKeys,
      vals=hwdBloc.state.store.getTypeVals;
      i < keys.length; i++ ) {
        if (choices.contains(keys[i])) {
          result = '$result "${vals[i]}" ';
        }
      }
  }

  if (hwdBloc.state.store.stateChoice.isNotEmpty) {
    if (result != '') { result = '$result\n'; }
    result = '$resultСостояние: ';
    for ( 
      var i=0, 
      choices=hwdBloc.state.store.stateChoice,
      keys=hwdBloc.state.store.getStateKeys,
      vals=hwdBloc.state.store.getStateVals;
      i < keys.length; i++ ) {
        if (choices.contains(keys[i])) {
          result = '$result "${vals[i]}" ';
        }
      }
  }

  if (hwdBloc.state.store.deptChoice.isNotEmpty) {
    if (result != '') { result = '$result\n'; }
    result = '$resultПодразделение: ';
    for ( 
      var i=0, 
      choices=hwdBloc.state.store.deptChoice,
      keys=hwdBloc.state.store.getDeptKeys,
      vals=hwdBloc.state.store.getDeptVals;
      i < keys.length; i++ ) {
        if (choices.contains(keys[i])) {
          result = '$result "${vals[i]}" ';
        }
      }
  }

  if (hwlBloc.state.store.searchFilter) {
    if (result != '') { result = '$result\n'; }
    result = '$resultСодержит: "${hwlBloc.state.store.searchstr}"';

  }


  return result;
}

void startSearch(BuildContext context)
{
  final hwlBloc   = BlocProvider.of<HwlistBloc>(context);
  final pglBloc   = BlocProvider.of<PglistBloc>(context);
  final hwdBloc   = BlocProvider.of<HwdictBloc>(context);
  var searchTtext = pglBloc.state.store.searchController.text; 

  if ( searchTtext.isNotEmpty) {


    if (!searchTtext.contains('%') && !searchTtext.contains('_')) {
      searchTtext = '%$searchTtext%';  
    }
    pglBloc.state.store.searchController.text = '';  
    hwlBloc.state.store.searchFilter = true;
    hwlBloc.state.store.searchstr = searchTtext;

    //
    hwlBloc.add(HwlistLoad(
      stateFilter: hwdBloc.state.store.stateChoice.isNotEmpty,
      stateIds: hwdBloc.state.store.stateChoice.toList(),
      typeFilter: hwdBloc.state.store.typeChoice.isNotEmpty,
      typeIds: hwdBloc.state.store.typeChoice.toList(),
      deptFilter: hwdBloc.state.store.deptChoice.isNotEmpty,
      deptIds: hwdBloc.state.store.deptChoice.toList(),
      searchFilter: hwlBloc.state.store.searchFilter,
      searchstr: hwlBloc.state.store.searchstr,
      // order: hwlBloc.state.store.order,
      )
    );
  }
}


  Widget tableHeader(BuildContext ctx, FocusNode searchFocusNode) {
    final BuildContext context = ctx;
    final hwlBloc = BlocProvider.of<HwlistBloc>(context);
    final hwdBloc = BlocProvider.of<HwdictBloc>(context);
    final pglBloc = BlocProvider.of<PglistBloc>(context);
    return SizedBox(
      width: 500,
      child: Row(
        children: [
        SizedBox(width: 400,
          child: TextField(
            focusNode: searchFocusNode,
            controller: pglBloc.state.store.searchController,
            autofocus: false,
            textInputAction: TextInputAction.search,
            onEditingComplete: () {
              searchFocusNode.unfocus();
              startSearch(context);
              },
            decoration: const InputDecoration(
              
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              hintText: 'Поиск',
            ),
          ),
        ),
        const SizedBox(width: 5,),
        IconButton.filled(
          style: FilledButton.styleFrom(
             shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2)
             )
          ),
          icon: const Icon(Icons.filter_alt) ,
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const HwlistFilterDialog();
                });
        }, ),
        const SizedBox(width: 5,),
        IconButton.filled(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
             shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2)
             )
          ),
          icon: const Icon(Icons.clear),
          onPressed: () {
            hwdBloc.state.store.clearFilters();
            hwlBloc.state.store.searchController.text = '';
            hwlBloc.state.store.searchFilter = false;
            hwlBloc.state.store.searchstr = '%';
            hwlBloc.state.store.tableRowIndex = 0;
            hwlBloc.state.store.tableSortColumn = 1;
            hwlBloc.state.store.tableSortAsc = true;
            hwlBloc.add(HwlistLoad());

          }, ),
      
      
      
      
      ],
            ),
    );
  }


  void onsortColum(BuildContext ctx, int columnIndex, bool ascending) async {

    final BuildContext context = ctx;
    final bloc = BlocProvider.of<HwlistBloc>(context);

            bloc.state.store.tableRowIndex = 0;


    bloc.state.store.tableSortColumn != columnIndex 
    ? bloc.state.store.tableSortAsc = true : bloc.state.store.tableSortAsc = !bloc.state.store.tableSortAsc;
    //
    bloc.state.store.tableSortColumn = columnIndex; 
    //
    String sortCol = bloc.state.store.tableFields[columnIndex-1]['api_col']!;
    String sortAsc = bloc.state.store.tableSortAsc ? "asc" : "desc";
    //
    bloc.state.store.order = {sortCol : sortAsc };
    bloc.state.store.tableRowIndex = 0;
    bloc.add(HwlistLoad(
      stateFilter:  bloc.state.store.stateFilter,
      stateIds:     bloc.state.store.stateIds,
      typeFilter:   bloc.state.store.typeFilter,
      typeIds:      bloc.state.store.typeIds,
      deptFilter:   bloc.state.store.deptFilter,
      deptIds:      bloc.state.store.deptIds,
      cfgiFilter:   bloc.state.store.cfgiFilter,
      cfgiIds:      bloc.state.store.cfgiIds,
      searchFilter: bloc.state.store.searchFilter,
      searchstr:    bloc.state.store.searchstr,
      order: bloc.state.store.order,
      ));
      //
      await bloc.stream.firstWhere((state) => state is HwlistLoaded,);
      //debugPrint('state column ${bloc.state.store.tableSortColumn} ascending ${bloc.state.store.tableSortAsc}');
      //debugPrint('ORDER ${bloc.state.store.order}');
  }

}

//
//
//
class HwTableDataSource extends DataTableSource {
  HwTableDataSource(this.context, this.bloc);//(this.dataRows, this.dataRowCount);
  HwlistBloc bloc;
  BuildContext context;

  // void _checkForNeedLoadMore(int index) async {
  //   if (bloc.state.store.getRowsCount < bloc.state.store.getTotal && index == (bloc.state.store.getRowsCount-1))
  //   {
  //     bloc.add(HwlistLoadMore(50));
  //     await bloc.stream.firstWhere((state) => state is HwlistLoaded,);
  //   }
  // }

  @override
  bool get isRowCountApproximate => false;
  @override
  // int get rowCount => bloc.state.store.getTotal;
  int get rowCount => bloc.state.store.getRowsCount;
  //int get rowCount => state.getRows.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index)  {
    //_checkForNeedLoadMore(index);
    final apiRow = bloc.state.store.getRows[index];
    return DataRow(
      // cells: 
      // List<DataCell>.generate(
      //   bloc.state.store.tableFields.length,
      //   (i) => DataCell(Text('${apiRow[bloc.state.store.tableFields[i]['api_col']]}')),
      //   )
      cells: 
      List<DataCell>.generate(
        bloc.state.store.tableFields.length + 1,
        (i) { 
          return i == 0 ?
          DataCell(IconButton(onPressed: () {
            //debugPrint('VIEW $index');
            showDialog( 
              context: context, 
              builder: (BuildContext context) 
              { return HwlistDetailDialog( index: index, ); 
                });
            }, icon: Icon(Icons.view_list, color: Theme.of(context).colorScheme.primary,)))
          :
          DataCell(Text('${apiRow[bloc.state.store.tableFields[i-1]['api_col']]}')); 
          }
        )
      );
  }
}
