import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';

import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FliterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); //WON'T WORK
    // Future.delayed(Duration.zero) // Will WORK BUT WE USE DIDCHANGEDEPENDENCIES
    //     .then((value) => Provider.of<Products>(context).fetchAndSetProducts());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text('Another Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FliterOptions selectedValue) {
              setState(() {
                if (selectedValue == FliterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Text('Only Favorites'),
                    if (_showOnlyFavorites)
                      Icon(
                        Icons.done,
                        color: Colors.indigoAccent,
                      ),
                  ],
                ),
                value: FliterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Text('Show All'),
                    if (!_showOnlyFavorites)
                      Icon(
                        Icons.done,
                        color: Colors.indigoAccent,
                      ),
                  ],
                ),
                value: FliterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => widget._refreshProducts(context),
        child: _isLoading
            ? Center(
                child: RefreshProgressIndicator(),
              )
            : ProductsGrid(_showOnlyFavorites),
      ),
    );
    return scaffold;
  }
}
