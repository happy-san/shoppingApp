import 'package:flutter/material.dart';

import '../providers/cart.dart';

class CartItemLayout extends StatefulWidget {
  final String cartItemKey;
  final CartItemData cartItemData;
  final Function removeItem;
  final Function incrementQuantity;
  final Function decrementQuantity;

  CartItemLayout(
    this.cartItemKey,
    this.cartItemData,
    this.removeItem,
    this.incrementQuantity,
    this.decrementQuantity,
  );

  @override
  _CartItemLayoutState createState() => _CartItemLayoutState();
}

class _CartItemLayoutState extends State<CartItemLayout> {
  Widget customButton(Function onTap, IconData icon) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Color.fromRGBO(255, 190, 58, 1),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          onTap: onTap,
          child: Icon(
            icon,
            color: Colors.white,
            size: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.cartItemData.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, color: Colors.white, size: 40),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        widget.removeItem(widget.cartItemKey);
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
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text('₹${widget.cartItemData.price}')),
              ),
            ),
            title: Text(widget.cartItemData.title),
            subtitle: Text(
                'Total: ₹${(widget.cartItemData.price * widget.cartItemData.quantity).toStringAsFixed(2)}'),
            trailing: FittedBox(
              child: Row(
                children: <Widget>[
                  widget.cartItemData.quantity > 1
                      ? customButton(() {
                          setState(() {
                            widget.decrementQuantity(widget.cartItemKey);
                          });
                        }, Icons.remove)
                      : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(left: 3, right: 3),
                    child: Text(
                      widget.cartItemData.quantity.toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  customButton(() {
                    setState(() {
                      widget.incrementQuantity(widget.cartItemKey);
                    });
                  }, Icons.add),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
