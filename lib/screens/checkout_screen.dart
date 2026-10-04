import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/noon_theme.dart';
import 'order_details_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'Credit / Debit Card';

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
          appProvider.isArabic ? 'إتمام الطلب' : 'Checkout & Payment',
          style: const TextStyle(fontWeight: FontWeight.bold, color: NoonTheme.noonBlack),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Delivery Address Picker Card
            Text(
              appProvider.isArabic ? '1. عنوان التوصيل' : '1. Delivery Address',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: appProvider.addresses.map((addr) {
                  bool isSelected = appProvider.selectedAddress?.id == addr.id;
                  return InkWell(
                    onTap: () => appProvider.setSelectedAddress(addr),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isSelected ? NoonTheme.yellowPrimary.withValues(alpha: 0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? NoonTheme.yellowPrimary : Colors.grey.shade200,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                            color: isSelected ? NoonTheme.noonBlack : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${addr.label} • ${addr.recipientName} (${addr.phone})',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                Text(
                                  addr.fullAddress,
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Section 2: Payment Method Selector
            Text(
              appProvider.isArabic ? '2. طريقة الدفع' : '2. Payment Method',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  _buildPaymentRadioTile(
                    'Credit / Debit Card',
                    'Visa, Mastercard, AMEX',
                    Icons.credit_card_rounded,
                  ),
                  const Divider(height: 1),
                  _buildPaymentRadioTile(
                    'Apple Pay / Google Pay',
                    'Fast 1-Touch Checkout',
                    Icons.apple_rounded,
                  ),
                  const Divider(height: 1),
                  _buildPaymentRadioTile(
                    'Tabby - Pay in 4',
                    '4 interest-free payments of ${(appProvider.cartTotal / 4).toStringAsFixed(2)} ${appProvider.currency}',
                    Icons.splitscreen_rounded,
                    badgeColor: NoonTheme.tabbyGreen,
                  ),
                  const Divider(height: 1),
                  _buildPaymentRadioTile(
                    'Cash on Delivery',
                    'Pay with cash upon delivery (+ AED 10 COD fee)',
                    Icons.payments_rounded,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section 3: Final Price Summary Box
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
                    appProvider.isArabic ? 'الملخص النهائي' : 'Payment Summary',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal (${appProvider.cartCount} items)', style: const TextStyle(color: Colors.grey)),
                      Text('${appProvider.currency} ${appProvider.cartSubtotal.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Shipping & Tax', style: TextStyle(color: Colors.grey)),
                      Text('${appProvider.currency} ${(appProvider.shippingFee + appProvider.vatAmount).toStringAsFixed(2)}'),
                    ],
                  ),
                  if (appProvider.couponDiscountAmount > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Discount', style: TextStyle(color: Colors.green)),
                        Text('-${appProvider.currency} ${appProvider.couponDiscountAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green)),
                      ],
                    ),
                  ],
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('TOTAL TO PAY', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                      Text(
                        '${appProvider.currency} ${appProvider.cartTotal.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: NoonTheme.noonBlack),
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

      // Sticky Place Order Button
      bottomNavigationBar: Container(
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
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: NoonTheme.yellowPrimary,
                foregroundColor: NoonTheme.noonBlack,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                final order = appProvider.createOrder(paymentMethod: _selectedPaymentMethod);
                _showOrderConfirmationDialog(context, order);
              },
              child: Text(
                appProvider.isArabic ? 'تأكيد ودفع الطلب' : 'PLACE ORDER',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentRadioTile(String title, String subtitle, IconData icon, {Color? badgeColor}) {
    bool isSelected = _selectedPaymentMethod == title;
    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = title),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              color: isSelected ? NoonTheme.noonBlack : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Icon(icon, size: 20, color: isSelected ? NoonTheme.noonBlack : Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      if (badgeColor != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(4)),
                          child: const Text('tabby', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ]
                    ],
                  ),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderConfirmationDialog(BuildContext context, order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Column(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.green, size: 60),
            SizedBox(height: 12),
            Text('Order Placed Successfully!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Order Number: ${order.orderId}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Thank you for shopping with noon! Your order is being processed for express delivery.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: NoonTheme.yellowPrimary,
              foregroundColor: NoonTheme.noonBlack,
            ),
            onPressed: () {
              Navigator.pop(ctx); // Dismiss dialog
              Navigator.pop(context); // Back from checkout
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => OrderDetailsScreen(order: order)),
              );
            },
            child: const Text('TRACK YOUR ORDER', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
