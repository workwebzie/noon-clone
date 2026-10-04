import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/noon_theme.dart';
import '../widgets/noon_app_bar.dart';
import '../widgets/product_card.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  String _selectedFilter = 'ALL';

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    // Filter deals products with discounts
    final dealsProducts = appProvider.products.where((p) {
      if (p.effectiveDiscount <= 0) return false;
      if (_selectedFilter == 'TECH' && p.category != 'electronics' && p.category != 'mobiles') return false;
      if (_selectedFilter == 'FASHION' && p.category != 'fashion') return false;
      if (_selectedFilter == 'BEAUTY' && p.category != 'beauty') return false;
      if (_selectedFilter == 'HOME' && p.category != 'home') return false;
      return true;
    }).toList()
      ..sort((a, b) => b.effectiveDiscount.compareTo(a.effectiveDiscount));

    return Scaffold(
      appBar: const NoonAppBar(showSearchBar: true),
      body: CustomScrollView(
        slivers: [
          // Yellow Friday Mega Sale Header Banner
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: NoonTheme.saleRed, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        appProvider.isArabic ? 'عروض الجمعة الصفراء' : 'YELLOW FRIDAY SALE',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: NoonTheme.noonBlack,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        appProvider.isArabic ? 'تنتهي الفعالية خلال: ' : 'ENDS IN: ',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: NoonTheme.noonBlack),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: NoonTheme.noonBlack,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          appProvider.flashSaleFormatted,
                          style: const TextStyle(
                            color: NoonTheme.yellowPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Deals Category Pills Bar
          SliverToBoxAdapter(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  _buildFilterChip('ALL', appProvider.isArabic ? 'جميع العروض' : 'All Deals'),
                  _buildFilterChip('TECH', appProvider.isArabic ? 'عروض التكنولوجيا' : 'Tech Deals'),
                  _buildFilterChip('FASHION', appProvider.isArabic ? 'تخفيضات الأزياء' : 'Fashion Deals'),
                  _buildFilterChip('BEAUTY', appProvider.isArabic ? 'عروض العطور والجمال' : 'Beauty & Fragrances'),
                  _buildFilterChip('HOME', appProvider.isArabic ? 'مستلزمات المنزل' : 'Home Deals'),
                ],
              ),
            ),
          ),

          // Discount Products Grid
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.52,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ProductCard(product: dealsProducts[index]);
                },
                childCount: dealsProducts.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    bool isSelected = _selectedFilter == key;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? NoonTheme.noonBlack : Colors.grey.shade800,
          ),
        ),
        selected: isSelected,
        selectedColor: NoonTheme.yellowPrimary,
        backgroundColor: Theme.of(context).cardColor,
        onSelected: (selected) {
          if (selected) setState(() => _selectedFilter = key);
        },
      ),
    );
  }
}
