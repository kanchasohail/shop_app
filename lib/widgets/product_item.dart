import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  //
  // final String title;
  //
  // final String imageUrl;
  //
  // ProductItem({
  //   required this.id,
  //   required this.title,
  //   required this.imageUrl,
  // });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context , listen: false);
    final cart = Provider.of<Cart>(context , listen: false);
    final authData = Provider.of<Auth>(context , listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black26,
          leading: Consumer<Product>(builder: (context , index , child) =>
          // We use consumer if we want to update the changed data into a single widget Instead of rebuilding the whole widget tree
          // child: // We can also add a child widget that we don't want to change even if the data in the consumer change
            IconButton(
                icon: Icon(
                 product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  product.toggleFavoriteStatus(authData.token , authData.userId) ;
                }),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style:
                Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 14),
          ),
          trailing: IconButton(
            icon:
                Icon(Icons.shopping_cart, color: Theme.of(context).accentColor),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                   duration: const Duration(seconds: 2),
                  content: const Text('Item added to the Cart!'),
                  action: SnackBarAction(label: "UNDO" , onPressed: (){
                    cart.removeSingleItem(product.id) ;
                  }),
                ),
              );

              // Fluttertoast.showToast(
              //     msg: "Item added to the Cart!",
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.BOTTOM,
              //     timeInSecForIosWeb: 1,
              //     textColor: Colors.white,
              //     fontSize: 16.0
              // );

            },
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(placeholder: const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
              ),
          )

        ),
      ),
    );
  }
}

// class ScreenArguments {
//   final String title;
//
//   final String description;
//
//   ScreenArguments(this.title, this.description);
// }
