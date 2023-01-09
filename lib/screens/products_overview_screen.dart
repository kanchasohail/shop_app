import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';

import '../providers/cart.dart';
import '../providers/product_provider.dart';
import '../widgets/product_grid.dart';

enum filterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  // @override
  // void initState() {
  //   // Provider.of<ProductProvider>(context).fetchAndSetProducts();
  //   //This won't work because its using the context
  //   // Here is an alternative hack
  //   Future.delayed(Duration.zero).then((_) {
  //     Provider.of<ProductProvider>(context).fetchAndSetProducts();
  //   });
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<ProductProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<ProductProvider>(context , listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shop"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: filterOptions.favorites,
                  child: Text("Show only favorites",
                      style: TextStyle(
                          fontFamily: 'Andika',
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500))),
              const PopupMenuItem(
                  value: filterOptions.all,
                  child: Text(
                    "Show all",
                    style: TextStyle(
                        fontFamily: 'Andika',
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  )),
            ],
            icon: const Icon(Icons.more_vert),
            onSelected: (filterOptions selectedItem) {
              setState(() {
                if (selectedItem == filterOptions.favorites) {
                  // productsContainer.showFavoritesOnly();
                  _showOnlyFavorites = true;
                } else {
                  // productsContainer.showAll();
                  _showOnlyFavorites = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (context, cartItem, ch) => Badge(
              value: cartItem.itemCount.toString(),
              child: ch!,
            ),
            child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.routeName);
                }),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showOnlyFavorites),
    );
  }
}
