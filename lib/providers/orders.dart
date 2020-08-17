import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'cart.dart';
import '../models/http_exception.dart';

class OrderItemData {
  final String id;
  final double amount;
  final List<CartItemData> products;
  final DateTime dateTime;

  OrderItemData({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItemData> _orders = [];
  String _authToken;
  String _userId;

  List<OrderItemData> get orders {
    return [..._orders];
  }

  setAuthToken(authToken) => _authToken = authToken;
  setUserId(userId) => _userId = userId;

  Future<void> fetchOrders() async {
    final url =
        'https://myshop-ea824.firebaseio.com/orders/$_userId.json?auth=$_authToken';
    List<OrderItemData> fetchedOrders = [];
    try {
      if (_userId == null) throw (HttpException('AnonymousUser'));
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData?.forEach((orderId, orderItemData) {
        fetchedOrders.add(OrderItemData(
            id: orderId,
            amount: orderItemData['amount'],
            products: (orderItemData['productIds'] as List<dynamic>)
                .map((item) => CartItemData(
                      id: item['id'],
                      price: item['price'],
                      quantity: item['quantity'],
                      title: item['title'],
                    ))
                .toList(),
            dateTime: DateTime.parse(orderItemData['dateTime'])));
      });
      _orders = fetchedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> addOrder(List<CartItemData> cartProducts, double total) async {
    final url =
        'https://myshop-ea824.firebaseio.com/orders/$_userId.json?auth=$_authToken';
    final timestamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'productIds': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList()
          }));

      _orders.insert(
        0,
        OrderItemData(
            id: json.decode(response.body)['name'],
            amount: total,
            dateTime: timestamp,
            products: cartProducts),
      );
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
