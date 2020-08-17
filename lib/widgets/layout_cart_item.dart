import 'package:flutter/material.dart';

import '../providers/cart.dart';
import './button_auto_action.dart';

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
  bool _tapDown;
  bool _tapUp;

  void increment() {
    setState(() => widget.incrementQuantity(widget.cartItemKey));
  }

  void decrement() {
    setState(() => widget.decrementQuantity(widget.cartItemKey));
  }

  void autoIncrement() {
    Future.doWhile(() async {
      var toContinue = _tapDown && !_tapUp;
      if (toContinue)
        await Future.delayed(Duration(milliseconds: 250)).then((value) {
          increment();
        });
      return toContinue;
    });
  }

  void autoDecrement() {
    Future.doWhile(() async {
      var toContinue =
          _tapDown && !_tapUp && (widget.cartItemData.quantity > 1);
      if (toContinue)
        await Future.delayed(Duration(milliseconds: 250)).then((value) {
          decrement();
        });
      return toContinue;
    });
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
                      ? AutoActionButton(
                          height: 24,
                          width: 24,
                          child: Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 16,
                          ),
                          onTap: decrement,
                          onLongPress: () {
                            _tapDown = true;
                            _tapUp = false;
                            autoDecrement();
                          },
                          onLongPressUp: () {
                            _tapUp = true;
                            _tapDown = false;
                          },
                        )
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(left: 3, right: 3),
                    child: Text(
                      widget.cartItemData.quantity.toString(),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  AutoActionButton(
                    height: 24,
                    width: 24,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16,
                    ),
                    onTap: increment,
                    onLongPress: () {
                      _tapDown = true;
                      _tapUp = false;
                      autoIncrement();
                    },
                    onLongPressUp: () {
                      _tapUp = true;
                      _tapDown = false;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
