import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
//import 'package:flutter/rendering.dart';

import './models/product.dart';
import './pages/authentication.dart';
import './pages/product.dart';
import './pages/products.dart';
import './pages/products_admin.dart';
import './scoped-models/main.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool isAuthenticated = false;
  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        // debugShowMaterialGrid: true,
        theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.deepPurple,
            accentColor: Colors.lime,
            buttonColor: Colors.lightGreenAccent),
        // home: AuthenticationPage(),
        routes: {
          '/': (BuildContext context) =>
              !isAuthenticated ? AuthenticationPage() : ProductsPage(_model),
          '/admin': (BuildContext context) => !isAuthenticated
              ? AuthenticationPage()
              : ProductsAdminPage(_model),
        },
        onGenerateRoute: (RouteSettings settings) {
          if (!isAuthenticated) {
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => AuthenticationPage(),
            );
          }
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];
            final Product product =
                _model.allProducts.firstWhere((Product product) {
              return product.id == productId;
            });
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => !isAuthenticated
                  ? AuthenticationPage()
                  : ProductPage(product),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => !isAuthenticated
                  ? AuthenticationPage()
                  : ProductsPage(_model));
        },
      ),
    );
  }
}
