import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ShopProductItemLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return Stack(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: product.id);
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            leading: Consumer<Product>(
              builder: (context, product, _) => IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  product.toggleFavouriteStatus(auth.token);
                },
              ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added item to cart!',
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.decrementCartItemCount(product.id);
                      },
                    ),
                  ),
                );
              },
            ),
            backgroundColor: Colors.black87,
          ),
        ),
      ),
      ClipRRect(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
        child: Container(
          child: Text(
            '₹ ${product.price.toString()}',
            style: Theme.of(context).textTheme.headline6,
          ),
          decoration: BoxDecoration(color: Colors.white54),
        ),
      ),
    ]);
  }
}
