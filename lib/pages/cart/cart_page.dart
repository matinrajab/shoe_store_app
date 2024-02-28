import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoe_store_app/models/cart_model.dart';
import 'package:shoe_store_app/pages/cart/widgets/cart_bottom_nav_bar.dart';
import 'package:shoe_store_app/pages/cart/widgets/cart_tile.dart';
import 'package:shoe_store_app/pages/widgets/empty_item.dart';
import 'package:shoe_store_app/pages/widgets/my_app_bar.dart';
import 'package:shoe_store_app/providers/cart_provider.dart';
import 'package:shoe_store_app/shared/theme.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';

  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor3,
      appBar: const MyAppBar(
        text: 'Your Cart',
        leadingIcon: Icons.close_rounded,
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, _) => cartProvider.carts.isEmpty
            ? const SizedBox()
            : CartBottomNavBar(
                price: cartProvider.totalPrice(),
              ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          List<CartModel> carts = cartProvider.carts;
          return Center(
            child: carts.isEmpty
                ? const EmptyItem(
                    iconAsset: 'assets/icon/icon_empty_cart.png',
                    title: 'Oops! Your Cart is Empty',
                    subtitle: 'Let\'s find your favorite shoes',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: pagePadding,
                    ),
                    itemCount: carts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CartTile(cart: carts[index]);
                    },
                  ),
          );
        },
      ),
    );
  }
}
