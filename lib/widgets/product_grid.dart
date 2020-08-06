import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import 'layout_shop_product_item.dart';

class ProductsGrids extends StatelessWidget {
  final bool showFavorites;
  ProductsGrids(this.showFavorites);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavorites ? productsData.favoriteItems : productsData.items;
    return OrientationBuilder(
      builder: (context, orientation) => GridView.builder(
        padding:
            const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 90),
        itemCount: products.length,
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: products[index],
          child: ShopProductItemLayout(),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
      ),
    );
  }
}
