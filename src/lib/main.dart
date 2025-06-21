//import 'dart:ui';
//import 'package:web/web.dart';


import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'view/app.dart';
import 'view/body_hwlist_pdtable.dart';





GetIt getIt = GetIt.instance;

void main() {
  //final div = document.querySelector('div')!;
  //div.textContent = 'Flutter Test WebAssembly WEB-Application. Use only Chromium Web Browser... ';

  //getIt.registerSingleton(HwListPDTable());
  //getIt.registerSingleton(HWListView());
  runApp(const App());
}

/// The main application widget for this example.
