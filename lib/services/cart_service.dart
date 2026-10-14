import '../models/menu_item.dart';
import '../models/cart_item.dart';

class CartService {

  static final List<CartItem> cart = [];

  static void addItem(MenuItem item) {

    for (var cartItem in cart) {

      if (cartItem.menuItem.name == item.name) {

        cartItem.quantity++;
        return;

      }

    }

    cart.add(
      CartItem(
        menuItem: item,
      ),
    );

  }

  static void increaseQuantity(int index) {
    cart[index].quantity++;
  }

  static void decreaseQuantity(int index) {

    if (cart[index].quantity > 1) {

      cart[index].quantity--;

    } else {

      cart.removeAt(index);

    }

  }

  static List<CartItem> getItems() {
    return cart;
  }

  static int getCount() {

    int total = 0;

    for (var item in cart) {

      total += item.quantity;

    }

    return total;

  }

  static void clearCart() {
    cart.clear();
  }

}