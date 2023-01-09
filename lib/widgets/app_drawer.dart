import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import '../providers/auth.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            color: Theme.of(context).accentColor,
            child: Center(child: Text("My Shop" , style: Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 38),)),
          ),
          Container(
            height: 500,
            child: Column(
              children: [
                ListTile(
                  leading : const Icon(Icons.shop) ,
                  title: Text("Your Shop" , style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold , color: Theme.of(context).accentColor), ),
                  onTap: (){
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
                const Divider(),
                ListTile(
                  leading : const Icon(Icons.payment) ,
                  title: Text("Your Orders" , style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold , color: Theme.of(context).accentColor), ),
                  onTap: (){
                    Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
                    // Navigator.of(context).pushReplacement(CustomRoute(builder: (ctx) => OrdersScreen())) ;
                  },
                ),
                const Divider(),
                ListTile(
                  leading : const Icon(Icons.edit) ,
                  title: Text("Manage Products" , style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold , color: Theme.of(context).accentColor), ),
                  onTap: (){
                    Navigator.pushReplacementNamed(context, UserProductsScreen.routeName);
                  },
                ),
                const Divider(),
                ListTile(
                  leading : const Icon(Icons.exit_to_app) ,
                  title: const Text("LogOut" , style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold , color: Colors.grey), ),
                  onTap: (){
                    // Navigator.pushReplacementNamed(context, UserProductsScreen.routeName);
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/');
                    Provider.of<Auth>(context , listen: false ).logOut() ;
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}