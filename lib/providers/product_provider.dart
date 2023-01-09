import 'package:flutter/cupertino.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

import 'product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //   'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //   'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavoritesOnly = false ;

  final String authToken;
  final String userId ;
  ProductProvider(this.authToken ,this.userId , this._items);

  List<Product> get favoriteItems {
    return _items.where((productItem) => productItem.isFavorite).toList();
  }

  List<Product> get items {
    // if(_showFavoritesOnly){
    //   return _items.where((productItem) => productItem.isFavorite).toList();
    // }
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  // void showFavoritesOnly(){
  //   _showFavoritesOnly = true ;
  //   notifyListeners();
  // }
  //
  // void showAll(){
  //   _showFavoritesOnly = false ;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {

    var filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '' ;

    // final url = Uri.parse(
    //     'https://shopapp-ee6ec-default-rtdb.firebaseio.com/pruducts.json?auth=$authToken');

    final url = Uri.parse(
        'https://shopapp-ee6ec-default-rtdb.firebaseio.com/pruducts.json?auth=$authToken&$filterString');



    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final favUrl = Uri.parse(
          'https://shopapp-ee6ec-default-rtdb.firebaseio.com/userFavorites/$userId/.json?auth=$authToken');

      final favoriteResponse = await http.get(favUrl) ;
      final favoriteData = jsonDecode(favoriteResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print("Failed to get data");
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shopapp-ee6ec-default-rtdb.firebaseio.com/pruducts.json?auth=$authToken');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId' : userId ,
          }));
      final newProduct = Product(
          id: jsonDecode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      // _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product updatedProduct) async{
    // print("Update product called");
    final prodIndex = _items.indexWhere((item) => item.id == id);

    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://shopapp-ee6ec-default-rtdb.firebaseio.com/pruducts/$id.json?auth=$authToken');
    await  http.patch(url , body: json.encode({
        'title': updatedProduct.title,
        'description': updatedProduct.description,
        'imageUrl': updatedProduct.imageUrl,
        'price': updatedProduct.price,
        'isFavorite': updatedProduct.isFavorite,

      }));
      _items[prodIndex] = updatedProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async{

   final url = Uri.parse(
        'https://shopapp-ee6ec-default-rtdb.firebaseio.com/pruducts/$id.json?auth=$authToken');

   final existingProductIndex = _items.indexWhere((item) => item.id == id);
   Product? existingProduct = _items[existingProductIndex];

   _items.removeAt(existingProductIndex);
   notifyListeners();


  final response = await http.delete(url);
      if(response.statusCode >= 400){
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpException('Could not delete product.');
      }

  }
}
