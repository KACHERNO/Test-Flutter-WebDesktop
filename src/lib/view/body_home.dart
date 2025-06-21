import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({super.key, breakPoint = 0}) : _breakPoint = breakPoint;
  final int _breakPoint;

  @override
  Widget build(BuildContext context) {
    var axisCount = 0;
    switch (_breakPoint) {
      case  0: axisCount =  8; break;
      case  1: axisCount =  8; break;
      case  2: axisCount = 10; break;
      case  3: axisCount = 16; break;
      case  4: axisCount = 16; break;
      default: axisCount = 16; break;
    }
    
    return _breakPoint < 3 ?
      Padding(
        padding: const EdgeInsets.fromLTRB(0,8,8,8),
        child: ListView.separated(
          itemCount: 9,
          itemBuilder: (context, index) {
            return Tile(index: index);
          }, 
          separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 4,); },
          ),
      )
      :
      Padding(
        padding: const EdgeInsets.fromLTRB(0,8,8,8),
        child: SizedBox(
          width: 1000,
          child: SingleChildScrollView(
            child: StaggeredGrid.count(
              crossAxisCount: axisCount,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: const [
                StaggeredGridTile.count( crossAxisCellCount: 8, mainAxisCellCount: 4, child: Tile(index: 0), ),
                StaggeredGridTile.count( crossAxisCellCount: 8, mainAxisCellCount: 7, child: Tile(index: 1), ),
                StaggeredGridTile.count( crossAxisCellCount: 8, mainAxisCellCount: 5, child: Tile(index: 2), ),
                StaggeredGridTile.count( crossAxisCellCount: 8, mainAxisCellCount: 5, child: Tile(index: 3), ),
                StaggeredGridTile.count( crossAxisCellCount: 8, mainAxisCellCount: 3, child: Tile(index: 4), ),
                StaggeredGridTile.count( crossAxisCellCount: 8, mainAxisCellCount: 8, child: Tile(index: 5), ),
                StaggeredGridTile.count( crossAxisCellCount: 8, mainAxisCellCount: 4, child: Tile(index: 6), ),
                StaggeredGridTile.count( crossAxisCellCount: 8, mainAxisCellCount: 4, child: Tile(index: 7), ),
                StaggeredGridTile.count( crossAxisCellCount: 16,mainAxisCellCount: 3, child: Tile(index: 8), ),
              ],
            ),
          ),
        ),
      );
    
  }
}


const List<Map<String,String>> entries = [
// 0
{ 'title' : 'Цель', 'text' : '''

Приложение написано в "изучительных" целях для выработки подхода к построению правильной архитектуры приложения FLUTTER (разделения UI и Data-модуля, авторизация, взаимодействие с Graphql JSON-API, использование Adaptive UI, State Management и Dependency Injection ).

Проверено на платформах web-javascript и windows-x64...
''' },
// 1
{ 'title' : 'Разделения UI и Data-модуля', 'text' : '''

Графические компоненты UI Flutter не содержат кода для получения и хранения данных с бэкенда. Функции получения и подкачки данных реализованны в отдельных модулях с использованием вызовов библиотеки flutter_bloc.

Данный подход позволяет снизить количество запросов на получение данных.

В приложении реализованы 2 визуальных компонента для больших и малых экранов: "Выч.Техника Таблица" и "Выч.Техника Список". Оба виджета использую общий Data-модуль.

В реальности так делать нельзя, но было интересно подружить несовместимое...
''' },
// 2
{ 'title' : 'Взаимодействие с Graphql JSON-API', 'text' : '''

Для получения данных с бэкенда использована библиотека flutter_agraphql.

GraphQL - своеобразный язык для клиентского ПО (подобный SQL) для получения данных. Есть все - фильтры, сортировки и порционирование.

В отличие от Rest-API отсутствуют "лишние стобцы" и "многочисленные GET-параметры"...
''' },
// 3
{ 'title' : 'Graphql JSON-API', 'text' : '''

В качестве бэкенда использован облачный сервис NHOST (аналог Firebase для PostgreSQL). На "борту" СУБД PostgreSQL, готовый GraphQL API HASURA и сервис аутентификации.

HASURA - реализация GraphQL API с ролевой моделью разграничения доступа...

Сервис NHOST используется в бесплатном варианте аренды. При длительном бездействии он засыпает (но с возможностью пробуждения)...
''' },
// 4
{ 'title' : 'Adaptive UI', 'text' : '''

Библиотека flutter_adaptive_scaffold позволяет строить адаптивный UI. Поиграйте размерами окна приложения и всё начнет меняться...
''' },
// 5
{ 'title' : 'State Management', 'text' : '''

Менеджер состояния flutter_bloc позволяет создать Модуль загрузки/хранения и управлять им через вызов события, обработчик когорого меняет непрерывный поток состояний.

Связь с модулем внутри виджета выполняется с помощью специальной "CONSUMER-обёртки", которая при изменении состояния сама запустит перестроение целевого UI-виджета.

Реализован механизм фильтров и строкового поиска.


''' },
// 6
{ 'title' : 'Dependency Injection', 'text' : '''

В данной конфигурации при смене геометрии окна происходит пересоздание экземпляра UI-виджетов, что безусловно увеличивает ресурсоемкость.

Для оптимизации задействована библиотека flutter_getid, позволяющая запускать единственный экземпляр того или иного класса на все время жизни приложения.
''' },
// 7
{ 'title' : 'Авторизация', 'text' : '''

В качестве защитного механизма используется JWT-авторизация. В момент парольной аутентификации NHOST отдает в приложение JWT-токен, в "пэйлоаде" которого содержится перечень ролей доступных пользователю.

Доступность объектов СУБД для ролей настраивается через консоль управления HASURA.
''' },
// 8
{ 'title' : 'Не раскрашено', 'text' : '''

Приложение получилось "СКУЧНЫМ". Оно не раскрашено. Используется стандартная тема "Material Design" сгенерированная на основе базового цвета "BlueAccent". 

Оно не для этого...
''' },
];



class Tile extends StatelessWidget {
  const Tile({
    super.key,
    required this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  });

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    // final child = Container(
    //   color: backgroundColor ?? _defaultColor,
    //   height: extent,
    //   child: Center(
    //     child: CircleAvatar(
    //       minRadius: 20,
    //       maxRadius: 20,
    //       backgroundColor: Colors.white,
    //       foregroundColor: Colors.black,
    //       child: Text('$index', style: const TextStyle(fontSize: 20)),
    //     ),
    //   ),
    // );
  
    final child = Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: ListTile(
        title: Text(entries[index]['title']??'', style: TextStyle(fontWeight: FontWeight.bold ,color: Theme.of(context).colorScheme.primary)),
        subtitle: Text(entries[index]['text']??'', textAlign: TextAlign.justify,),
        //subtitleTextStyle: const TextStyle(fontSize: 16, color: Colors.blue),
        //trailing: const Icon(Icons.home),
      ),
    );


    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}
