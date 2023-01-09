import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

import 'package:shop_app/widgets/product_item.dart';

class ProductGrid extends StatelessWidget{
final bool showFavs ;

ProductGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    final products = showFavs ?  productsData.favoriteItems : productsData.items  ;
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
          // create: (context) => products[index] ,
          value: products[index],
          child: ProductItem(
            // id: products[index].id,
            // title: products[index].title,
            // imageUrl: products[index].imageUrl,
          ),
        ));
  }

}