import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';

import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import 'providers/product_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth , ProductProvider>(
            create: (ctx) => ProductProvider('' ,'',[]),
            update: (_, auth , previousProduct) => ProductProvider(auth.token ,  auth.userId , previousProduct == null ?  [] : previousProduct.items)
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),

        // ChangeNotifierProvider(create: (context) => Orders()),
        ChangeNotifierProxyProvider<Auth , Orders>(
            create: (ctx) => Orders('' , '' , []),
            update: (_, auth , previousOrders) => Orders(auth.token , auth.userId , previousOrders == null ? [] : previousOrders.orders)
        ),


      ],

      // ChangeNotifierProvider.value(
      //     value: ProductProvider())  // This is an alternative if we don't need the use of context

      // ChangeNotifierProvider(
      //   create: (ctx) => ProductProvider(),

      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Shop app',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              accentColor: Colors.deepOrange,
              textTheme: TextTheme(
                subtitle1: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 22,
                    fontFamily: 'Andika',
                    fontWeight: FontWeight.bold),
              ),
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android : CustomPageTransitionBuilder() ,
              TargetPlatform.iOS : CustomPageTransitionBuilder(),
            })
          ),
          // home: const MyHomePage(title: 'Flutter Demo Home Page'),
          home: auth.isAuth ? ProductsOverviewScreen()  : FutureBuilder( future: auth.tryAutoLogin() , builder: (ctx , authResultSnapshot ) => authResultSnapshot.connectionState == ConnectionState.waiting ?  SplashScreen() : AuthScreen() ) ,
          initialRoute: '/',
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
            AuthScreen.routeName: (context) => AuthScreen(),
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop app"),
      ),
      body: const Text("Hello world"),
    );
  }
}
