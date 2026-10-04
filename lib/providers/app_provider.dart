import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/cart_item.dart';
import '../models/coupon.dart';
import '../models/user_address.dart';
import '../models/order.dart';
import '../data/mock_data.dart';

class AppProvider extends ChangeNotifier {
  // Localization & Region
  String _language = 'en';
  String _currency = 'AED';
  String _country = 'UAE';
  String _countryFlag = '🇦🇪';
  ThemeMode _themeMode = ThemeMode.light;

  // Catalog & Data
  List<Product> _products = [];
  List<CategoryItem> _categories = [];
  final Set<String> _wishlistProductIds = {'p1', 'p4'};

  // Cart & Orders
  final List<CartItem> _cart = [];
  Coupon? _appliedCoupon;
  List<UserAddress> _addresses = [];
  UserAddress? _selectedAddress;
  final List<OrderModel> _orders = [];

  // Search & Filters
  String _searchQuery = '';
  String _selectedCategoryId = 'all';
  double _minPrice = 0;
  double _maxPrice = 10000;
  bool _expressOnly = false;
  String _sortBy = 'relevance';

  // Countdown Timer for Yellow Friday Flash Deals
  Timer? _timer;
  Duration _flashSaleRemaining = const Duration(hours: 4, minutes: 28, seconds: 45);

  AppProvider() {
    _initData();
    _startFlashSaleTimer();
  }

  void _initData() {
    _products = List.from(MockData.products);
    _categories = List.from(MockData.categories);
    _addresses = List.from(MockData.defaultAddresses);
    if (_addresses.isNotEmpty) {
      _selectedAddress = _addresses.firstWhere((a) => a.isDefault, orElse: () => _addresses.first);
    }
    // Seed initial cart item
    _cart.add(CartItem(
      product: _products[0],
      selectedColor: 'Natural Titanium',
      selectedSize: '256GB',
      quantity: 1,
    ));

    // Seed past completed order for tracker preview
    _orders.add(OrderModel(
      orderId: 'NOON-98421034',
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
      items: [
        CartItem(product: _products[1], quantity: 1),
      ],
      subtotal: 1749.0,
      discount: 0.0,
      shippingFee: 0.0,
      totalAmount: 1749.0,
      status: OrderStatus.outForDelivery,
      deliveryAddress: _addresses.first,
      paymentMethod: 'Credit Card (**** 4242)',
      estimatedDelivery: 'Today by 8:00 PM',
    ));
  }

  void _startFlashSaleTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_flashSaleRemaining.inSeconds > 0) {
        _flashSaleRemaining = _flashSaleRemaining - const Duration(seconds: 1);
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Getters
  String get language => _language;
  bool get isArabic => _language == 'ar';
  String get currency => _currency;
  String get country => _country;
  String get countryFlag => _countryFlag;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  List<Product> get products => _products;
  List<CategoryItem> get categories => _categories;
  List<CartItem> get cart => _cart;
  Coupon? get appliedCoupon => _appliedCoupon;
  List<UserAddress> get addresses => _addresses;
  UserAddress? get selectedAddress => _selectedAddress;
  List<OrderModel> get orders => _orders;

  String get searchQuery => _searchQuery;
  String get selectedCategoryId => _selectedCategoryId;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  bool get expressOnly => _expressOnly;
  String get sortBy => _sortBy;
  Duration get flashSaleRemaining => _flashSaleRemaining;

  // Formatted flash sale string HH:MM:SS
  String get flashSaleFormatted {
    int hours = _flashSaleRemaining.inHours;
    int minutes = _flashSaleRemaining.inMinutes.remainder(60);
    int seconds = _flashSaleRemaining.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}h : ${minutes.toString().padLeft(2, '0')}m : ${seconds.toString().padLeft(2, '0')}s';
  }

  // Cart computations
  int get cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  double get cartSubtotal => _cart.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get couponDiscountAmount {
    if (_appliedCoupon == null) return 0.0;
    return _appliedCoupon!.calculateDiscount(cartSubtotal);
  }

  double get shippingFee {
    if (cartSubtotal >= 100 || cartSubtotal == 0) return 0.0; // Free express shipping over AED 100
    return 10.0;
  }

  double get freeShippingProgress {
    if (cartSubtotal >= 100) return 1.0;
    return cartSubtotal / 100.0;
  }

  double get vatAmount => (cartSubtotal - couponDiscountAmount) * 0.05; // 5% VAT

  double get cartTotal => cartSubtotal - couponDiscountAmount + shippingFee + vatAmount;

  // Actions
  void toggleLanguage() {
    _language = _language == 'en' ? 'ar' : 'en';
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setCountry(String newCountry, String flag, String newCurrency) {
    _country = newCountry;
    _countryFlag = flag;
    _currency = newCurrency;
    notifyListeners();
  }

  // Wishlist Actions
  bool isInWishlist(String productId) => _wishlistProductIds.contains(productId);

  void toggleWishlist(String productId) {
    if (_wishlistProductIds.contains(productId)) {
      _wishlistProductIds.remove(productId);
    } else {
      _wishlistProductIds.add(productId);
    }
    notifyListeners();
  }

  List<Product> get wishlistProducts =>
      _products.where((p) => _wishlistProductIds.contains(p.id)).toList();

  // Cart Actions
  void addToCart(Product product, {String? color, String? size, int quantity = 1}) {
    String key = '${product.id}_${color ?? ""}_${size ?? ""}';
    int existingIndex = _cart.indexWhere((item) => item.itemKey == key);

    if (existingIndex >= 0) {
      _cart[existingIndex].quantity += quantity;
    } else {
      _cart.add(CartItem(
        product: product,
        selectedColor: color,
        selectedSize: size,
        quantity: quantity,
      ));
    }
    notifyListeners();
  }

  void updateCartQuantity(CartItem item, int delta) {
    item.quantity += delta;
    if (item.quantity <= 0) {
      _cart.remove(item);
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cart.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _appliedCoupon = null;
    notifyListeners();
  }

  bool applyCoupon(String code) {
    String upperCode = code.trim().toUpperCase();
    try {
      Coupon coupon = MockData.coupons.firstWhere((c) => c.code == upperCode);
      if (cartSubtotal >= coupon.minSpend) {
        _appliedCoupon = coupon;
        notifyListeners();
        return true;
      }
    } catch (_) {}
    return false;
  }

  void removeCoupon() {
    _appliedCoupon = null;
    notifyListeners();
  }

  // Address Actions
  void setSelectedAddress(UserAddress address) {
    _selectedAddress = address;
    notifyListeners();
  }

  void addAddress(UserAddress address) {
    _addresses.add(address);
    _selectedAddress = address;
    notifyListeners();
  }

  // Order Placement Action
  OrderModel createOrder({required String paymentMethod}) {
    double sub = cartSubtotal;
    double disc = couponDiscountAmount;
    double ship = shippingFee;
    double tot = cartTotal;

    OrderModel newOrder = OrderModel(
      orderId: 'NOON-${(DateTime.now().millisecondsSinceEpoch / 1000).round()}',
      orderDate: DateTime.now(),
      items: List.from(_cart),
      subtotal: sub,
      discount: disc,
      shippingFee: ship,
      totalAmount: tot,
      status: OrderStatus.placed,
      deliveryAddress: _selectedAddress ?? _addresses.first,
      paymentMethod: paymentMethod,
      estimatedDelivery: 'Tomorrow by 2:00 PM',
    );

    _orders.insert(0, newOrder);
    clearCart();
    notifyListeners();
    return newOrder;
  }

  // Search & Filter Actions
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setFilters({
    double? minP,
    double? maxP,
    bool? express,
    String? sort,
  }) {
    if (minP != null) _minPrice = minP;
    if (maxP != null) _maxPrice = maxP;
    if (express != null) _expressOnly = express;
    if (sort != null) _sortBy = sort;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategoryId = 'all';
    _minPrice = 0;
    _maxPrice = 10000;
    _expressOnly = false;
    _sortBy = 'relevance';
    notifyListeners();
  }

  // Filtered Products Output
  List<Product> get filteredProducts {
    return _products.where((p) {
      // Search query matching
      if (_searchQuery.isNotEmpty) {
        String q = _searchQuery.toLowerCase();
        bool titleMatch = p.title.toLowerCase().contains(q);
        bool brandMatch = p.brand.toLowerCase().contains(q);
        bool catMatch = p.category.toLowerCase().contains(q);
        if (!titleMatch && !brandMatch && !catMatch) return false;
      }

      // Category matching
      if (_selectedCategoryId != 'all' && p.category != _selectedCategoryId) {
        return false;
      }

      // Price range matching
      if (p.price < _minPrice || p.price > _maxPrice) {
        return false;
      }

      // Express tag matching
      if (_expressOnly && !p.isExpress) {
        return false;
      }

      return true;
    }).toList()
      ..sort((a, b) {
        if (_sortBy == 'price_low') {
          return a.price.compareTo(b.price);
        } else if (_sortBy == 'price_high') {
          return b.price.compareTo(a.price);
        } else if (_sortBy == 'rating') {
          return b.rating.compareTo(a.rating);
        }
        return 0; // relevance / default
      });
  }
}
