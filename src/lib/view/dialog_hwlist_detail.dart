

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/bloc/hwlist_bloc.dart';


                      //  final hwInvnum = row['hw_invnum'];
                      //   final hwRoom   = row['hw_room'];
                      //   final stateId  = row['hw_state_id'];
                      //   //final typeDesc = row['type_desc'];
                      //   final cfgiDesc = row['cfgi_desc'];
                      //   //final deptDesc = row['dept_desc'];
                      //   //final stateDesc = row['state_desc'];





class HwlistDetailDialog extends StatelessWidget {
  final int _index;

  const HwlistDetailDialog({super.key, required int index}): _index = index;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HwlistBloc>(context);
    final row = bloc.state.store.getRows[_index];
    return AlertDialog(
              titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              title: Text('Актив ${row['hw_id']}',),
              
              content: SizedBox( width: 400, height: 600,
                child: ListView( 
                  //padding: const EdgeInsets.all(8),
                  
                  children: [
                    const Divider(),
                    ListTile(
                      title: Text(row['type_desc'], style: const TextStyle(fontWeight: FontWeight.bold),), 
                      subtitle: const Text('Тип', style: TextStyle(fontSize: 12), ),),
                    const Divider(),
                    ListTile(title: Text(row['hw_invnum'], style: const TextStyle(fontWeight: FontWeight.bold),), 
                      subtitle: const Text('Инвентарный номер', style: TextStyle(fontSize: 12),),),
                    const Divider(),
                    ListTile(title: Text(row['state_desc'], style: const TextStyle(fontWeight: FontWeight.bold),), 
                      subtitle: const Text('Состояние', style: TextStyle(fontSize: 12),),),
                    const Divider(),
                    ListTile(title: Text(row['cfgi_desc'], style: const TextStyle(fontWeight: FontWeight.bold),), 
                      subtitle: const Text('Конфигурационная единица', style: TextStyle(fontSize: 12),),),
                    const Divider(),
                    ListTile(title: Text(row['dept_desc'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold),), 
                      subtitle: const Text('Подразделение', style: TextStyle(fontSize: 12),),),
                    const Divider(),
                    ListTile(title: Text(row['hw_room'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold),), 
                      subtitle: const Text('Кабинет', style: TextStyle(fontSize: 12),),),
                    const Divider(),
                  ]
                )
              ),
              actions: [
                FilledButton.tonalIcon(
                    onPressed: () { Navigator.of(context).pop(); },
                    icon: const Icon(Icons.clear),
                    // label: const Text('Закрыть', style: TextStyle(fontSize: 10), ),
                    label: const Text('Закрыть', ),
                    iconAlignment: IconAlignment.start,
                  ),
              ],
    );

  }
}