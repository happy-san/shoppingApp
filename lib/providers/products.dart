import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavouriteStatus(String authToken, String userId) async {
    final url =
        'https://myshop-ea824.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(url, body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        throw ('error');
      }
    } catch (error) {
      isFavorite = !isFavorite;
      print(error);
      notifyListeners();
    }
  }
}

class Products with ChangeNotifier {
  List<Product> _items = [];
  String _authToken;
  String _userId;

  get items => [..._items];
  get favoriteItems => _items.where((item) => item.isFavorite).toList();

  setAuthToken(authToken) => _authToken = authToken;
  setUserId(userId) => _userId = userId;

  Product findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    var url = 'https://myshop-ea824.firebaseio.com/products.json?$filterString';
    try {
      final response = await http.get(url);
      url = 'https://myshop-ea824.firebaseio.com/userFavorites/$_userId.json?';
      final userFavoritesResponse = await http.get(url);
      final userFavorites = json.decode(userFavoritesResponse.body);

      List<Product> fetchedProducts = [];
      (json.decode(response.body) as Map<String, dynamic>)
          ?.forEach((productId, productData) {
        fetchedProducts.add(Product(
          id: productId,
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          price: productData['price'],
          title: productData['title'],
          isFavorite:
              userFavorites == null ? false : userFavorites[productId] ?? false,
        ));
      });
      _items = fetchedProducts;
    } catch (error) {
      throw (error);
    }

    // try {
    //   for (Product p in _items) {
    //     url =
    //         'https://myshop-ea824.firebaseio.com/userFavorites/$_userId/${p.id}.json?auth=$_authToken';
    //     final response = await http.get(url);
    //     if (response?.body == 'true') p.isFavorite = true;
    //   }
    // } catch (error) {
    //   throw (error);
    // }

    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://myshop-ea824.firebaseio.com/products.json?auth=$_authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'favorite': product.isFavorite,
          'creatorId': _userId,
        }),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((product) => id == product.id);
    if (prodIndex >= 0) {
      final url =
          'https://myshop-ea824.firebaseio.com/products/$id.json?auth=$_authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
    }
    notifyListeners();
  }

  Future<bool> removeProduct(String id) async {
    final url =
        'https://myshop-ea824.firebaseio.com/products/$id.json?auth=$_authToken';
    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    try {
      var response = await http.delete(url);
      if (response.statusCode >= 400)
        throw HttpException('Could not delete product.');
      existingProduct = null;
      return true;
    } catch (error) {
      print(error.toString());
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      return false;
    }
  }
}
