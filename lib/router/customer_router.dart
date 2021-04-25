import 'package:flutter/material.dart';
import 'file:///D:/TestAndroid/layout/lib/base/base_bloc.dart';
import 'package:layout/page/home_bloc.dart';
import 'package:layout/page/home_page.dart';
import 'package:layout/router/router_name.dart';

class CustomerRouter {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    switch (settings.name) {
      case tote_api:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              child: HomePage(),
              bloc: HomeBloc(),
            ));
        return MaterialPageRoute(builder: (_) => null);
    }
  }
}