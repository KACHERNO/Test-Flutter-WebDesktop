

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/bloc/hwdict_bloc.dart';
import '../state/bloc/hwlist_bloc.dart';

class HwlistFilterDialog extends StatefulWidget {
  const HwlistFilterDialog({super.key});

  @override
  State<HwlistFilterDialog> createState() => _HwFilterDialogState();
}

class _HwFilterDialogState extends State<HwlistFilterDialog> {

  void applyFilter(HwdictBloc bloc) {
        final hwlBloc = BlocProvider.of<HwlistBloc>(context);
        hwlBloc.add(
          HwlistLoad(
            stateFilter: bloc.state.store.stateChoice.isNotEmpty,
            stateIds: bloc.state.store.stateChoice.toList(),
            typeFilter: bloc.state.store.typeChoice.isNotEmpty,
            typeIds: bloc.state.store.typeChoice.toList(),
            cfgiFilter: bloc.state.store.cfgiChoice.isNotEmpty,
            cfgiIds: bloc.state.store.cfgiChoice.toList(),
            deptFilter: bloc.state.store.deptChoice.isNotEmpty,
            deptIds: bloc.state.store.deptChoice.toList(),
            searchFilter: hwlBloc.state.store.searchFilter,
            searchstr: hwlBloc.state.store.searchstr,
            order: hwlBloc.state.store.order,
            )
          );

  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HwdictBloc>(context);
    if (bloc.state is HwdictInitial) {
      bloc.add(HwdictLoad());
    }
    return 
    BlocConsumer<HwdictBloc, HwdictState>(

      listener: (context, state) {
      },
      builder: (context, state) {

        if (bloc.state is HwdictFailure) {
          return Text('Error: ${bloc.state.getError}');
        }
        if  (bloc.state is HwdictLoaded) {        
      
          return AlertDialog(
            //child: SingleChildScrollView(
              title: const Text('Фильтр:'),
              
              content: SizedBox( width: 400, height: 600,
                child: ListView( 
                  padding: const EdgeInsets.all(8),
                  children: [
                    ExpansionTile(
                      dense: false,
                      title: Text('Состояние (${bloc.state.store.stateChoice.length})'),
                      //subtitle: const Text('Состояние'),
                      children: 
                        [ for ( 
                          var i=0,
                          choices=bloc.state.store.stateChoice,
                          keys=bloc.state.store.getStateKeys,
                          vals=bloc.state.store.getStateVals;
                          i < keys.length; 
                          i++ ) 
                        
                        CheckboxListTile( 
                          dense: true,
                          value: choices.contains(keys[i]),
                          onChanged: (bool? value) {setState(() { choices.contains(keys[i]) ? choices.remove(keys[i]) : choices.add(keys[i]);});},
                          title: Text(vals[i]),  
                          ),
                        ],
                    ),
                    ExpansionTile(
                      dense: false,
                      title: Text('Тип Актива (${bloc.state.store.typeChoice.length})'),
                      //subtitle: const Text('Тип КЕ'),
                      children: 
                        [ for ( 
                          var i=0, 
                          choices=bloc.state.store.typeChoice,
                          keys=bloc.state.store.getTypeKeys,
                          vals=bloc.state.store.getTypeVals;
                          i < keys.length; i++ ) 
                        CheckboxListTile(
                          dense: true,
                          value: choices.contains(keys[i]),
                          onChanged: (bool? value) {setState(() { choices.contains(keys[i]) ? choices.remove(keys[i]) : choices.add(keys[i]);});},
                          title: Text(vals[i]),  
                          ),
                        ],
                    ),
                    ExpansionTile(
                      dense: false,
                      title: Text('Подразделение (${bloc.state.store.deptChoice.length})'),
                      //subtitle: const Text('Состояние'),
                      children: 
                        [ for ( 
                          var i=0,
                          choices=bloc.state.store.deptChoice,
                          keys=bloc.state.store.getDeptKeys,
                          vals=bloc.state.store.getDeptVals;
                          i < keys.length; 
                          i++ ) 
                        CheckboxListTile(
                          dense: true,
                          value: choices.contains(keys[i]),
                          onChanged: (bool? value) {setState(() { choices.contains(keys[i]) ? choices.remove(keys[i]) : choices.add(keys[i]);});},
                          title: Text(vals[i]),  
                          ),
                        ],
                    ),
                  ],
                ),
              ),
          actions: [
            FilledButton.tonalIcon(
                    onPressed: () { 
                      applyFilter(bloc);
                      Navigator.of(context).pop(); 
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Применить',),
                    iconAlignment: IconAlignment.start,
                  ),
            FilledButton.tonalIcon(
                    onPressed: () {
                    setState(() {
                      bloc.state.store.clearFilters();
                      applyFilter(bloc);
                      Navigator.of(context).pop();
                      // bloc.state.stateChoice = {};
                      // bloc.state.typeChoice = {};
                      // bloc.state.cfgiChoice = {};
                      // bloc.state.deptChoice = {};
                    });

                    },
                    icon: const Icon(Icons.clear),
                    label: const Text('Очистить'),
                    iconAlignment: IconAlignment.start,
                  ),
          ],
            
            //),
              
          );
      
        } else {return const Text('');}
      },
      
    );
  }
}
