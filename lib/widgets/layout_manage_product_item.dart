import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class ManageProductItemLayout extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  ManageProductItemLayout(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 96,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                var isRemoved =
                    await Provider.of<Products>(context, listen: false)
                        .removeProduct(id);
                print('removed: $isRemoved');
                if (!isRemoved)
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (context) {
                        return Text('Error Occured while deleting');
                      });
              },
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
