import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/noon_theme.dart';
import '../widgets/noon_app_bar.dart';
import '../widgets/product_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int _selectedCategoryIndex = 1; // Default to Mobiles & Tech

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final categories = appProvider.categories.where((c) => c.id != 'all').toList();
    final selectedCategory = categories[_selectedCategoryIndex];

    final categoryProducts = appProvider.products
        .where((p) => p.category == selectedCategory.id)
        .toList();

    return Scaffold(
      appBar: const NoonAppBar(showSearchBar: true),
      body: Row(
        children: [
          // Left Side Vertical Navigation Rail
          Container(
            width: 105,
            color: Theme.of(context).cardColor,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (ctx, index) {
                final cat = categories[index];
                bool isSelected = index == _selectedCategoryIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedCategoryIndex = index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).scaffoldBackgroundColor
                          : Theme.of(context).cardColor,
                      border: Border(
                        left: isSelected && !appProvider.isArabic
                            ? const BorderSide(color: NoonTheme.yellowPrimary, width: 4)
                            : BorderSide.none,
                        right: isSelected && appProvider.isArabic
                            ? const BorderSide(color: NoonTheme.yellowPrimary, width: 4)
                            : BorderSide.none,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          cat.icon,
                          color: isSelected ? NoonTheme.noonBlack : Colors.grey.shade600,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appProvider.isArabic ? cat.nameAr : cat.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? Theme.of(context).textTheme.bodyLarge?.color
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Vertical Separator Line
          VerticalDivider(width: 1, color: Colors.grey.shade300),

          // Right Side Main Content View
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Category Banner Card
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          selectedCategory.color.withValues(alpha: 0.8),
                          selectedCategory.color.withValues(alpha: 0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appProvider.isArabic ? selectedCategory.nameAr : selectedCategory.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${categoryProducts.length} ${appProvider.isArabic ? "منتج متوفر" : "products available"}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),

                // Subcategories Quick Chips
                if (selectedCategory.subcategories.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: selectedCategory.subcategories.length,
                        itemBuilder: (ctx, idx) {
                          final sub = selectedCategory.subcategories[idx];
                          return Container(
                            margin: const EdgeInsets.only(right: 6),
                            child: ActionChip(
                              label: Text(sub, style: const TextStyle(fontSize: 11)),
                              backgroundColor: Theme.of(context).cardColor,
                              side: BorderSide(color: Colors.grey.shade300),
                              onPressed: () {
                                appProvider.setSearchQuery(sub);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                // Category Products Grid
                categoryProducts.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Center(
                            child: Text(
                              appProvider.isArabic
                                  ? 'قريباً في هذه الفئة'
                                  : 'More items coming soon in this category!',
                              style: const TextStyle(color: Colors.grey),
                            ),
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
                              return ProductCard(product: categoryProducts[index]);
                            },
                            childCount: categoryProducts.length,
                          ),
                        ),
                      ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
