import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../main.dart';
import '../state/bloc/auth_bloc.dart';
import '../state/bloc/hwdict_bloc.dart';
import '../state/bloc/hwlist_bloc.dart';
import '../state/bloc/pglist_bloc.dart';
import '../theme/theme.dart';
import 'body_hwlist_pdtable.dart';
import 'screen_login_adaptive.dart';
import 'body_home.dart';

class App extends StatelessWidget {
  /// Creates a const main application widget.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => AuthBloc(),
          ),
          BlocProvider<HwdictBloc>(
            create: (BuildContext context) => HwdictBloc(context),
          ),
          BlocProvider<HwlistBloc>(
            create: (BuildContext context) => HwlistBloc(context),
          ),
          BlocProvider<PglistBloc>(
            create: (BuildContext context) => PglistBloc(context),
          ),
        ],
        child: MaterialApp(
          theme: theme1,
          localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
  supportedLocales: const [
    Locale('ru'), // English
  ],
          home: const Home(),
        ));
  }
}

/// Creates a basic adaptive page with navigational elements and a body using
/// [AdaptiveScaffold].
class Home extends StatefulWidget {
  /// Creates a const [Home].
  const Home({super.key, this.transitionDuration = 100});

  /// Declare transition duration.
  final int transitionDuration;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>
    with TickerProviderStateMixin, ChangeNotifier {
  int _selectedTab = 0;
  int _transitionDuration = 100;
  ValueNotifier<bool?> showHwlistFilters = ValueNotifier<bool?>(false);

  Widget rightBar(BuildContext context, String text) {
    return Container(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Center(child: Text(text)));
  }

  Widget bodyDispatcher(int menuIndex, int bodyType) {
    switch (menuIndex) {
      // case 0: return InfoPage( breakPoint: bodyType, );
      // case 1: return getIt<HwListPDTable>().getPDTable(context);
      // case 2: return getIt<HWListView>().getList(context);
      // case 3: return BlocViewInfo(bodyType: bodyType,);
      // case 4: return const SizedBox();
      case 0:
        return bodyType < 2 ? 
          const Center( child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text( 'Для табличного представления информации размер экрана слишком мал. Измените размер приложения или запуститесь с другого устройства.', 
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 20), ),
          ))
          : 
          getIt<HwListPDTable>().getPDTable(context);
      case 1:
        return AppInfo(breakPoint: bodyType,);
      // case 2: return getIt<HWListView>().getList(context);
      // case 3: return BlocViewInfo(bodyType: bodyType,);
      // case 4: return const SizedBox();
      default:
        return Container();
    }
  }

  // 0  'smallBody'
  // 1  'body'
  // 2  'mediumLargeBody'
  // 3  'largeBody'
  // 4  'extraLargeBody'

  // WidgetBuilder sbodyDispatcher(BuildContext context, int menuIndex, int bodyType) {
  //     switch (menuIndex) {
  //       case 0:  return AdaptiveScaffold.emptyBuilder;
  //       case 1:  return bodyType > 4 ? (_) => rightBar(context, 'Доп. Столбец Таблица') : AdaptiveScaffold.emptyBuilder;
  //       case 2:  return bodyType > 2 ? (_) => rightBar(context, 'Доп. Столбец Список') : AdaptiveScaffold.emptyBuilder;
  //       case 3:  return AdaptiveScaffold.emptyBuilder;
  //       //case 4:  return AdaptiveScaffold.emptyBuilder;//AdaptiveScaffold.emptyBuilder;
  //       default: return AdaptiveScaffold.emptyBuilder;
  //     }
  // }

  // Initialize transition time variable.
  @override
  void initState() {
    super.initState();
    setState(() {
      _transitionDuration = widget.transitionDuration;
    });
  }

  // #docregion Example
  @override
  Widget build(BuildContext context) {
    showHwlistFilters.value = Breakpoints.mediumLargeAndUp.isActive(context);

//debugPrint(showGridView.toString());

    //_isAuth = BlocProvider.of<AuthBloc>(context).state is Authenticated;
    // Define the children to display within the body at different breakpoints.
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        // final hwlbloc = BlocProvider.of<HwlistBloc>(context);
        // final hwdbloc = BlocProvider.of<HwdictBloc>(context);
        return state is Authenticated
            ? 
                   AdaptiveScaffold(
                    extendedNavigationRailWidth: 240,
                    //bodyRatio:0.70,
                    // An option to override the default transition duration.
                    transitionDuration:
                        Duration(milliseconds: _transitionDuration),
                    leadingUnextendedNavRail: Column(
                      children: [
                        Text('Мини',
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.primary)),
                        Text('ITIL',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary)),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(),
                      ],
                    ),
                    leadingExtendedNavRail: Column(
                      children: [
                        Text('Мини-ITIL',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary)),
                        const Text('Тестовое приложение'),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(),
                      ],
                    ),
                    appBar: AppBar(title: const Text("Мини-ITIL")),
                    appBarBreakpoint: Breakpoints.small,
                    useDrawer: true,
                    selectedIndex: _selectedTab,
                    onSelectedIndexChange: (int index) {
                      setState(() {
                        if (index == 2) {
                          BlocProvider.of<AuthBloc>(context).add(SignOut());
                          _selectedTab = 0;
                        } else {
                          _selectedTab = index;
                        }
                        //debugPrint('_selectedTab = $index');
                      });
                    },
                    destinations: const <NavigationDestination>[
                      NavigationDestination(
                        icon: Icon(Icons.table_view_outlined),
                        selectedIcon: Icon(Icons.table_view),
                        label: 'Список СВТ',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.article_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: 'Информация',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.exit_to_app),
                        selectedIcon: Icon(Icons.exit_to_app),
                        label: 'Выход',
                      ),
                    ],
                    smallBody: (context) {
                      return bodyDispatcher(_selectedTab, 0);
                    },
                    body: (context) {
                      return bodyDispatcher(_selectedTab, 1);
                    },
                    mediumLargeBody: (context) {
                      return bodyDispatcher(_selectedTab, 2);
                    },
                    largeBody: (context) {
                      return bodyDispatcher(_selectedTab, 3);
                    },
                    extraLargeBody: (context) {
                      return bodyDispatcher(_selectedTab, 4);
                    }, //AdaptiveScaffold.emptyBuilder,
                  )

            : const Scaffold(
                body: Center(child: LoginApative()/*LoginScreen()*/),
              );
      },
    );
  }
// #enddocregion Example
}

class InfoPage {
}
