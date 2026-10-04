import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/noon_theme.dart';
import '../widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final wishlist = appProvider.wishlistProducts;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appProvider.isArabic ? 'قائمة المفضلة (${wishlist.length})' : 'My Wishlist (${wishlist.length})',
          style: const TextStyle(fontWeight: FontWeight.bold, color: NoonTheme.noonBlack),
        ),
      ),
      body: wishlist.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border_rounded, size: 70, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    appProvider.isArabic ? 'قائمة المفضلة فارغة' : 'Your wishlist is empty',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    appProvider.isArabic
                        ? 'انقر على رمز القلب في أي منتج لحفظه هنا'
                        : 'Tap the heart icon on any item to save it for later!',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.52,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: wishlist.length,
              itemBuilder: (ctx, idx) {
                return ProductCard(product: wishlist[idx]);
              },
            ),
    );
  }
}
