import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/app_provider.dart';
import '../theme/noon_theme.dart';
import '../widgets/noon_express_badge.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: NoonTheme.noonBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          appProvider.isArabic
              ? 'عربة التسوق (${appProvider.cartCount})'
              : 'Shopping Cart (${appProvider.cartCount})',
          style: const TextStyle(fontWeight: FontWeight.bold, color: NoonTheme.noonBlack),
        ),
        actions: [
          if (appProvider.cart.isNotEmpty)
            TextButton(
              onPressed: () {
                appProvider.clearCart();
              },
              child: Text(
                appProvider.isArabic ? 'إفراغ السلة' : 'Clear All',
                style: const TextStyle(color: NoonTheme.saleRed, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: appProvider.cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    appProvider.isArabic ? 'عربة التسوق فارغة' : 'Your cart is empty',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    appProvider.isArabic
                        ? 'أضف منتجات رائعة من الصفحة الرئيسية'
                        : 'Explore products and start adding items to your cart!',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NoonTheme.yellowPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      appProvider.isArabic ? 'متابعة التسوق' : 'Start Shopping',
                      style: const TextStyle(color: NoonTheme.noonBlack, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Free Shipping Progress Card Bar
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.local_shipping_rounded, color: NoonTheme.noonBlack, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                appProvider.cartSubtotal >= 100
                                    ? (appProvider.isArabic
                                        ? 'مبروك! تأهلت للشحن السريع المجاني 🎉'
                                        : 'You unlocked FREE Express Shipping! 🎉')
                                    : '${appProvider.isArabic ? "أضف" : "Add"} ${appProvider.currency} ${(100 - appProvider.cartSubtotal).toStringAsFixed(0)} ${appProvider.isArabic ? "أكثر للحصول على شحن مجاني" : "more for FREE Express Delivery!"}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: appProvider.freeShippingProgress,
                            minHeight: 6,
                            backgroundColor: Colors.grey.shade300,
                            color: appProvider.cartSubtotal >= 100 ? Colors.green : NoonTheme.yellowPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Cart Items List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: appProvider.cart.length,
                    itemBuilder: (ctx, index) {
                      final item = appProvider.cart[index];
                      final p = item.product;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: p.images.first,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),

                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            p.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                                          onPressed: () {
                                            appProvider.removeFromCart(item);
                                          },
                                        )
                                      ],
                                    ),
                                    if (item.selectedColor != null || item.selectedSize != null)
                                      Text(
                                        'Variant: ${item.selectedColor ?? ""} ${item.selectedSize ?? ""}',
                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                      ),
                                    const SizedBox(height: 4),
                                    if (p.isExpress) const NoonExpressBadge(fontSize: 9),
                                    const SizedBox(height: 8),

                                    // Price & Quantity Stepper
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${appProvider.currency} ${item.totalPrice.toStringAsFixed(2)}',
                                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                                        ),

                                        // Stepper Widget
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.shade300),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () => appProvider.updateCartQuantity(item, -1),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  child: Icon(Icons.remove, size: 16),
                                                ),
                                              ),
                                              Text(
                                                '${item.quantity}',
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                              ),
                                              InkWell(
                                                onTap: () => appProvider.updateCartQuantity(item, 1),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  child: Icon(Icons.add, size: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // Coupon / Promo Code Input Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appProvider.isArabic ? 'كوبون الخصم' : 'Apply Coupon Code',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 42,
                                child: TextField(
                                  controller: _couponController,
                                  textCapitalization: TextCapitalization.characters,
                                  decoration: InputDecoration(
                                    hintText: 'e.g. YELLOW20',
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              height: 42,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: NoonTheme.noonBlack,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                ),
                                onPressed: () {
                                  bool success = appProvider.applyCoupon(_couponController.text);
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Coupon applied successfully! 🎉')),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Invalid coupon code or minimum spend not met.')),
                                    );
                                  }
                                },
                                child: Text(appProvider.isArabic ? 'تطبيق' : 'APPLY'),
                              ),
                            ),
                          ],
                        ),

                        if (appProvider.appliedCoupon != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_rounded, color: Colors.green, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  'Coupon ${appProvider.appliedCoupon!.code} Active',
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () => appProvider.removeCoupon(),
                                  child: const Text('Remove', style: TextStyle(color: Colors.red, fontSize: 11)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Order Summary Breakdown
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appProvider.isArabic ? 'ملخص الطلب' : 'Order Summary',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        _buildSummaryRow(appProvider, 'Subtotal', appProvider.cartSubtotal),
                        if (appProvider.couponDiscountAmount > 0)
                          _buildSummaryRow(appProvider, 'Coupon Discount', -appProvider.couponDiscountAmount, isDiscount: true),
                        _buildSummaryRow(
                          appProvider,
                          'Shipping Fee',
                          appProvider.shippingFee,
                          subtitle: appProvider.shippingFee == 0 ? 'FREE' : null,
                        ),
                        _buildSummaryRow(appProvider, 'Estimated VAT (5%)', appProvider.vatAmount),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              appProvider.isArabic ? 'الإجمالي الكلي' : 'Total Amount',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              '${appProvider.currency} ${appProvider.cartTotal.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: NoonTheme.noonBlack),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),

      // Sticky Checkout CTA Button
      bottomNavigationBar: appProvider.cart.isEmpty
          ? const SizedBox.shrink()
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -3),
                  )
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appProvider.isArabic ? 'المبلغ الإجمالي' : 'Total',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                        Text(
                          '${appProvider.currency} ${appProvider.cartTotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 48,
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: NoonTheme.yellowPrimary,
                          foregroundColor: NoonTheme.noonBlack,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (ctx) => const CheckoutScreen()),
                          );
                        },
                        child: Text(
                          appProvider.isArabic ? 'الانتقال للدفع' : 'CHECKOUT',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSummaryRow(AppProvider provider, String title, double amount, {bool isDiscount = false, String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
          Text(
            subtitle ?? '${provider.currency} ${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDiscount ? Colors.green : (subtitle == 'FREE' ? Colors.green : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
