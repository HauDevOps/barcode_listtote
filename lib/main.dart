import 'package:flutter/material.dart';
import 'package:layout/router/customer_router.dart';
import 'package:layout/router/router_name.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: CustomerRouter.allRoutes,
      initialRoute: tote_api,
    );
  }
}

