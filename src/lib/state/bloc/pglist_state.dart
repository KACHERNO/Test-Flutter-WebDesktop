part of 'pglist_bloc.dart';


class PglistStorage {
  int  _listCount    = 20;
  bool _listReverse  = false;
  int  _listIndex    = 0;
 



  int  get getListCount   => _listCount;
  bool get getListReverse => _listReverse;
  int  get getListIndex   => _listIndex;
  
  set setListIndex(int idx)        { _listIndex   = idx;     }
  set setListCount(int cnt)        { _listCount   = cnt;     }
  set setListReverse(bool reverse) { _listReverse = reverse; }
  var searchController = TextEditingController();
  //var scrollController = ScrollController();

}

var pglistStorage = PglistStorage();



@immutable
sealed class PglistState {
  final store = pglistStorage;
  

}

final class PglistInitial extends PglistState {}
final class PglistBuilded extends PglistState {
  PglistBuilded(int addCount, bool reverse) {
    super.store.setListCount   = super.store.getListCount + addCount;
    super.store.setListReverse = reverse;
    //debugPrint('Ещё $addCount...');
  }
}