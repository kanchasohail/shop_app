import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail-screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProduct = Provider.of<ProductProvider>(context, listen: false).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight:300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                  tag: loadedProduct.id,
                  child: Image.network(loadedProduct.imageUrl , fit: BoxFit.cover,)),

            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([

              const SizedBox(height: 10,),
              Text('\$${loadedProduct.price}' , style: const TextStyle(color: Colors.grey , fontSize: 20 , fontWeight: FontWeight.bold ,), textAlign: TextAlign.center,),
              const SizedBox(height: 10,),
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(loadedProduct.description , textAlign: TextAlign.center, softWrap: true,)),
              const SizedBox(height: 800,)
            ]),
          ),
        ],
      ),
    );
  }
}
