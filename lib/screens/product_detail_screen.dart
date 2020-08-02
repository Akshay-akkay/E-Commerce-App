import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/screens/cart_screen.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';
  final String productId;

  ProductDetailScreen(this.productId);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final loadedProduct = Provider.of<Products>(
      context,
      // listen: false
    ).findById(widget.productId);
    final authData = Provider.of<Auth>(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      //   actions: [
      //     IconButton(
      //       icon: Icon(loadedProduct.isFavorite
      //           ? Icons.favorite
      //           : Icons.favorite_border),
      //       onPressed: () {
      //         setState(() {
      //           loadedProduct.toggleFavoriteStatus(
      //               authData.token, authData.userId);
      //         });
      //       },
      //     )
      //   ],
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id,
                child: Container(
                  width: 290.0,
                  height: 290.0,
                  decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(loadedProduct.imageUrl),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 80),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        cart.removeSingleItem(widget.productId);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.indigoAccent[100],
                        child: Icon(Icons.remove),
                      ),
                    ),
                    SizedBox(width: 25),
                    Text(
                      cart.items[widget.productId] == null
                          ? '0'
                          : cart.items[widget.productId].quantity.toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(width: 25),
                    InkWell(
                      onTap: () {
                        cart.addItem(
                          widget.productId,
                          loadedProduct.price,
                          loadedProduct.title,
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.indigoAccent[100],
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text(
                '\$${loadedProduct.price}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 50),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  loadedProduct.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Container(
                height: 310,
                child: Center(child: Text('DETAILED DESCRIPTION')),
              ),
              SizedBox(height: 80),
              Row(
                children: [
                  Spacer(),
                  FloatingActionButton(
                    // color: Colors.indigoAccent,
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  )
                ],
              ),
              SizedBox(
                width: 25,
              )
            ]),
          ),
        ],
      ),
    );
  }
}
