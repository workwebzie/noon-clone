import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/noon_theme.dart';
import 'product_card.dart';

class FlashSaleSection extends StatelessWidget {
  const FlashSaleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final flashProducts = appProvider.products.where((p) => p.effectiveDiscount >= 15).toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            NoonTheme.yellowPrimary.withValues(alpha: 0.15),
            Colors.white,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Flame Icon + Countdown Timer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department_rounded, color: NoonTheme.dealOrange, size: 24),
                const SizedBox(width: 4),
                Text(
                  appProvider.isArabic ? 'صفقات الخاطفة' : 'MEGA DEALS',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: NoonTheme.noonBlack,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: NoonTheme.yellowPrimary, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        appProvider.flashSaleFormatted,
                        style: const TextStyle(
                          color: NoonTheme.yellowPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    appProvider.setSelectedCategory('all');
                  },
                  child: Row(
                    children: [
                      Text(
                        appProvider.isArabic ? 'عرض الكل' : 'SEE ALL',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: NoonTheme.noonBlack,
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, size: 18, color: NoonTheme.noonBlack),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Horizontal Products List
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: flashProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  product: flashProducts[index],
                  isHorizontal: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
