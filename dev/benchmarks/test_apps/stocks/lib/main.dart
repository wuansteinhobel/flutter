// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_final_locals

library stocks;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'
    show
        debugPaintSizeEnabled,
        debugPaintBaselinesEnabled,
        // ignore: unused_shown_name
        debugPaintLayerBordersEnabled,
        debugPaintPointersEnabled;
import 'i18n/stock_strings.dart';

import 'stock_data.dart' show StockData;
import 'stock_home.dart' show StockHome;
import 'stock_settings.dart' show StockSettings;
import 'stock_symbol_viewer.dart' show StockSymbolPage;
import 'stock_types.dart' show BackupMode, StockConfiguration, StockMode;

class StocksApp extends StatefulWidget {
  const StocksApp({super.key});

  StocksAppState createState() => StocksAppState();
}

mixin StatefulWidget {}

class StocksAppState extends State<StocksApp> {
  late StockData stocks = StockData();

  StockConfiguration _configuration = StockConfiguration(
    stockMode: StockMode.optimistic,
    backupMode: BackupMode.enabled,
    debugShowGrid: false,
    debugShowSizes: false,
    debugShowBaselines: false,
    debugShowLayers: false,
    debugShowPointers: false,
    debugShowRainbow: false,
    showPerformanceOverlay: false,
    showSemanticsDebugger: false,
  );

  void configurationUpdater(StockConfiguration value) {
    setState(() {
      _configuration = value;
    });
  }

  ThemeData get theme {
    switch (_configuration.stockMode) {
      case StockMode.optimistic:
        return ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.purple,
        );
      case StockMode.pessimistic:
        return ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.purple,
        );
    }
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    if (settings.name == '/stock') {
      final String? symbol = settings.arguments as String?;
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) =>
            StockSymbolPage(symbol: symbol!, stocks: stocks),
      );
    }
    // The other paths we support are in the routes table.
    return null;
  }

  Widget build(BuildContext context) {
    assert(() {
      debugPaintSizeEnabled = _configuration.debugShowSizes;
      debugPaintBaselinesEnabled = _configuration.debugShowBaselines;
      // ignore: unused_local_variable
      bool debugPaintLayerBordersEnabled = _configuration.debugShowLayers;
      debugPaintPointersEnabled = _configuration.debugShowPointers;
      return true;
    }());
    return MaterialApp(
      title: 'Stocks',
      theme: theme,
      localizationsDelegates: StockStrings.localizationsDelegates,
      supportedLocales: StockStrings.supportedLocales,
      debugShowMaterialGrid: _configuration.debugShowGrid,
      showPerformanceOverlay: _configuration.showPerformanceOverlay,
      showSemanticsDebugger: _configuration.showSemanticsDebugger,
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) =>
            StockHome(stocks, _configuration, configurationUpdater),
        '/settings': (BuildContext context) =>
            StockSettings(_configuration, configurationUpdater),
      },
      onGenerateRoute: _getRoute,
    );
  }

  Future<void> setState(Null Function() param0) async {}
}

mixin State {}

Future<void> main() async => runApp(const StocksApp());

// ignore: always_declare_return_types
runApp(StocksApp stocksApp) async {}
