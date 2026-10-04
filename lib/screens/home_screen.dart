import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/noon_theme.dart';
import '../widgets/noon_app_bar.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/flash_sale_section.dart';
import '../widgets/product_card.dart';
import '../widgets/filter_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final products = appProvider.filteredProducts;

    final List<Map<String, String>> brands = [
      {'name': 'Apple', 'logo': '🍎'},
      {'name': 'Samsung', 'logo': '📱'},
      {'name': 'Sony', 'logo': '🎮'},
      {'name': 'Nike', 'logo': '👟'},
      {'name': 'Dyson', 'logo': '🌀'},
      {'name': 'Ninja', 'logo': '🥷'},
      {'name': 'Lattafa', 'logo': '✨'},
      {'name': 'Ray-Ban', 'logo': '🕶️'},
    ];

    return Scaffold(
      appBar: const NoonAppBar(showSearchBar: true),
      body: CustomScrollView(
        slivers: [
          // 1. Horizontal Category Quick Navigation Bar
          SliverToBoxAdapter(
            child: Container(
              color: Theme.of(context).cardColor,
              height: 95,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: appProvider.categories.length,
                itemBuilder: (ctx, index) {
                  final cat = appProvider.categories[index];
                  bool isSelected = appProvider.selectedCategoryId == cat.id;

                  return GestureDetector(
                    onTap: () {
                      appProvider.setSelectedCategory(cat.id);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: isSelected ? NoonTheme.yellowPrimary : cat.color.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? NoonTheme.noonBlack : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: NoonTheme.yellowPrimary.withValues(alpha: 0.5),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      )
                                    ]
                                  : [],
                            ),
                            child: Icon(
                              cat.icon,
                              color: isSelected ? NoonTheme.noonBlack : cat.color,
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            appProvider.isArabic ? cat.nameAr : cat.name,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? NoonTheme.noonBlack : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 2. Main Hero Promotional Banner Carousel
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: BannerCarousel(),
            ),
          ),

          // 3. Trust & Value Proposition Pills Banner
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: NoonTheme.noonDarkHeader,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTrustItem(Icons.verified_rounded, appProvider.isArabic ? 'منتجات أصلية 100%' : '100% Authentic'),
                  _buildTrustItem(Icons.flash_on_rounded, appProvider.isArabic ? 'شحن سريع express' : 'noon express Delivery'),
                  _buildTrustItem(Icons.replay_rounded, appProvider.isArabic ? 'إرجاع سهل خلال 15 يوم' : '15-Day Easy Returns'),
                ],
              ),
            ),
          ),

          // 4. Flash Sale / Mega Deals Timer Carousel Section
          const SliverToBoxAdapter(
            child: FlashSaleSection(),
          ),

          // 5. Brands in Spotlight Row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appProvider.isArabic ? 'أبرز العلامات التجارية' : 'TOP FEATURED BRANDS',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 65,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: brands.length,
                      itemBuilder: (ctx, idx) {
                        final b = brands[idx];
                        return GestureDetector(
                          onTap: () {
                            appProvider.setSearchQuery(b['name']!);
                          },
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300, width: 0.8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(b['logo']!, style: const TextStyle(fontSize: 20)),
                                const SizedBox(height: 2),
                                Text(
                                  b['name']!,
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 6. Products Grid Title + Filter Button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appProvider.selectedCategoryId == 'all'
                            ? (appProvider.isArabic ? 'موصى به لك' : 'RECOMMENDED FOR YOU')
                            : (appProvider.categories
                                .firstWhere((c) => c.id == appProvider.selectedCategoryId)
                                .name
                                .toUpperCase()),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        '${products.length} ${appProvider.isArabic ? "منتج متوفر" : "items found"}',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  ),

                  // Filter Modal Trigger Button
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: NoonTheme.noonBlack, width: 1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                    icon: const Icon(Icons.tune_rounded, size: 16, color: NoonTheme.noonBlack),
                    label: Text(
                      appProvider.isArabic ? 'تصفية' : 'Filter',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: NoonTheme.noonBlack),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (ctx) => const FilterBottomSheet(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 7. Responsive Products Grid View
          products.isEmpty
              ? SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        const Icon(Icons.search_off_rounded, size: 60, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          appProvider.isArabic
                              ? 'لم يتم العثور على منتجات مطابقة'
                              : 'No products match your filter criteria.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: NoonTheme.yellowPrimary),
                          onPressed: () => appProvider.resetFilters(),
                          child: Text(
                            appProvider.isArabic ? 'إعادة ضبط الفلاتر' : 'Reset Filters',
                            style: const TextStyle(color: NoonTheme.noonBlack),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.52,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return ProductCard(product: products[index]);
                      },
                      childCount: products.length,
                    ),
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildTrustItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: NoonTheme.yellowPrimary, size: 14),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
