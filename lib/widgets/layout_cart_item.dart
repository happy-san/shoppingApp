import 'package:flutter/material.dart';

import '../providers/cart.dart';

class CartItemLayout extends StatelessWidget {
  final String cartItemKey;
  final CartItemData cartItemData;
  final Function removeItem;

  CartItemLayout(this.cartItemKey, this.cartItemData, this.removeItem);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItemData.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, color: Colors.white, size: 40),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        removeItem(cartItemKey);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Item will be removed from the cart!'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Deny'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('Agree'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  )
                ],
              );
            });
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text('₹${cartItemData.price}')),
              ),
            ),
            title: Text(cartItemData.title),
            subtitle:
                Text('Total: ₹${(cartItemData.price * cartItemData.quantity)}'),
            trailing: Text('${cartItemData.quantity} x'),
          ),
        ),
      ),
    );
  }
}
