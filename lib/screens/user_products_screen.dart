import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';

  Future<void> _fetchData(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your products"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _fetchData(context),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () {
                      return _fetchData(context);
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Consumer<ProductProvider>(
                          builder: (ctx, productData, _) => ListView.builder(
                            itemCount: productData.items.length,
                            itemBuilder: (ctx, index) => Column(
                              children: [
                                UserProductItem(
                                    productData.items[index].id,
                                    productData.items[index].title,
                                    productData.items[index].imageUrl),
                                const Divider(),
                              ],
                            ),
                          ),
                        )),
                  ),
      ),
    );
  }
}
