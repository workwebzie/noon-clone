import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../providers/app_provider.dart';
import '../theme/noon_theme.dart';
import '../widgets/noon_express_badge.dart';
import 'cart_screen.dart';
import 'checkout_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  String? _selectedColor;
  String? _selectedSize;

  @override
  void initState() {
    super.initState();
    if (widget.product.colors.isNotEmpty) {
      _selectedColor = widget.product.colors.first;
    }
    if (widget.product.sizes.isNotEmpty) {
      _selectedSize = widget.product.sizes.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final p = widget.product;
    final isWishlisted = appProvider.isInWishlist(p.id);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: NoonTheme.noonBlack),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isWishlisted ? Colors.red : NoonTheme.noonBlack,
            ),
            onPressed: () => appProvider.toggleWishlist(p.id),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: NoonTheme.noonBlack),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product link copied to clipboard!')),
              );
            },
          ),
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart_outlined, color: NoonTheme.noonBlack),
                if (appProvider.cartCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: NoonTheme.noonBlack,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                      child: Text(
                        '${appProvider.cartCount}',
                        style: const TextStyle(color: NoonTheme.yellowPrimary, fontSize: 9, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const CartScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel Preview
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: 300,
                  child: PageView.builder(
                    itemCount: p.images.length,
                    onPageChanged: (index) => setState(() => _selectedImageIndex = index),
                    itemBuilder: (ctx, idx) {
                      return CachedNetworkImage(
                        imageUrl: p.images[idx],
                        fit: BoxFit.contain,
                        placeholder: (c, u) => Container(color: Colors.grey.shade100),
                      );
                    },
                  ),
                ),

                // Indicator Dots
                if (p.images.length > 1)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        p.images.length,
                        (idx) => Container(
                          width: _selectedImageIndex == idx ? 16 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _selectedImageIndex == idx ? NoonTheme.noonBlack : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const Divider(),

            // Product Information Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        p.brand.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const Spacer(),
                      if (p.isExpress) const NoonExpressBadge(fontSize: 11),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    p.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.3),
                  ),
                  const SizedBox(height: 10),

                  // Rating Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${p.rating}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            const SizedBox(width: 2),
                            const Icon(Icons.star_rounded, size: 12, color: Colors.white),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${p.reviewCount} ${appProvider.isArabic ? "تقييمات العملاء" : "Ratings & Reviews"}',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price Card Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${appProvider.currency} ',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              p.price.toStringAsFixed(2),
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(width: 10),
                            if (p.originalPrice != null && p.originalPrice! > p.price) ...[
                              Text(
                                '${appProvider.currency} ${p.originalPrice!.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: NoonTheme.saleRed,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'SAVE ${(p.originalPrice! - p.price).toStringAsFixed(0)} ${appProvider.currency}',
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appProvider.isArabic ? 'شامل ضريبة القيمة المضافة (VAT)' : 'Price inclusive of VAT',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Delivery Estimate Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: NoonTheme.yellowPrimary),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_shipping_rounded, color: NoonTheme.noonBlack),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appProvider.isArabic
                                    ? 'احصل عليه غداً، إذا طلبت خلال ساعتين'
                                    : 'FREE Express Delivery Tomorrow!',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: NoonTheme.noonBlack),
                              ),
                              Text(
                                appProvider.isArabic
                                    ? 'توصيل سريع مجاني للطلبات فوق 100 درهم'
                                    : 'Order within 2 hrs 15 mins to receive by tomorrow.',
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade800),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Variants Selectors (Color & Size)
                  if (p.colors.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      appProvider.isArabic ? 'اللون' : 'Color: $_selectedColor',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: p.colors.map((c) {
                        bool isSel = _selectedColor == c;
                        return ChoiceChip(
                          label: Text(c),
                          selected: isSel,
                          selectedColor: NoonTheme.yellowPrimary,
                          labelStyle: TextStyle(
                            color: isSel ? NoonTheme.noonBlack : Colors.grey.shade800,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (val) => setState(() => _selectedColor = c),
                        );
                      }).toList(),
                    ),
                  ],

                  if (p.sizes.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      appProvider.isArabic ? 'الحجم / السعة' : 'Size / Storage: $_selectedSize',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: p.sizes.map((s) {
                        bool isSel = _selectedSize == s;
                        return ChoiceChip(
                          label: Text(s),
                          selected: isSel,
                          selectedColor: NoonTheme.yellowPrimary,
                          labelStyle: TextStyle(
                            color: isSel ? NoonTheme.noonBlack : Colors.grey.shade800,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (val) => setState(() => _selectedSize = s),
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 20),
                  const Divider(),

                  // Seller & Return Policy Card
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundColor: NoonTheme.yellowPrimary,
                      child: Icon(Icons.storefront_rounded, color: NoonTheme.noonBlack),
                    ),
                    title: Text(
                      'Sold by ${p.seller}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    subtitle: const Text('4.9 ★ Seller Rating | 15-Day Free Returns'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                  ),
                  const Divider(),

                  // Specifications Table
                  const SizedBox(height: 10),
                  Text(
                    appProvider.isArabic ? 'المواصفات والخصائص' : 'Specifications',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: p.specs.entries.map((entry) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 110,
                                child: Text(
                                  entry.key,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey.shade700),
                                ),
                              ),
                              Expanded(
                                child: Text(entry.value, style: const TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Overview Description
                  Text(
                    appProvider.isArabic ? 'تفاصيل المنتج' : 'Product Overview',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    p.description,
                    style: TextStyle(fontSize: 13, height: 1.4, color: Colors.grey.shade800),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),

      // Sticky Bottom Add to Cart & Buy Now Buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Add to Cart Button
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NoonTheme.yellowPrimary,
                      foregroundColor: NoonTheme.noonBlack,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      appProvider.addToCart(
                        p,
                        color: _selectedColor,
                        size: _selectedSize,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: NoonTheme.noonBlack,
                          content: Text(appProvider.isArabic ? 'تمت إضافة المنتج إلى السلة' : 'Added to cart!'),
                          action: SnackBarAction(
                            label: 'VIEW CART',
                            textColor: NoonTheme.yellowPrimary,
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (c) => const CartScreen()));
                            },
                          ),
                        ),
                      );
                    },
                    child: Text(
                      appProvider.isArabic ? 'إضافة إلى العربة' : 'ADD TO CART',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Buy Now Button
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NoonTheme.noonBlack,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      appProvider.addToCart(
                        p,
                        color: _selectedColor,
                        size: _selectedSize,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (ctx) => const CheckoutScreen()),
                      );
                    },
                    child: Text(
                      appProvider.isArabic ? 'شراء الآن' : 'BUY NOW',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
