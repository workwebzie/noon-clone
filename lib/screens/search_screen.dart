import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/noon_theme.dart';
import '../widgets/product_card.dart';
import '../widgets/filter_drawer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _recentSearches = [
    'iPhone 16 Pro Max',
    'PlayStation 5',
    'AirPods Pro',
    'Nike Shoes',
    'Dyson Vacuum',
    'Lattafa Perfumes',
  ];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AppProvider>(context, listen: false);
    _controller.text = provider.searchQuery;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final results = appProvider.filteredProducts;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: NoonTheme.yellowPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: NoonTheme.noonBlack),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Container(
          height: 40,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _controller,
            autofocus: true,
            onChanged: (val) {
              appProvider.setSearchQuery(val);
            },
            decoration: InputDecoration(
              hintText: appProvider.isArabic ? 'ابحث في نون...' : 'Search noon...',
              hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
              prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey, size: 20),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                      onPressed: () {
                        _controller.clear();
                        appProvider.setSearchQuery('');
                      },
                    )
                  : const Icon(Icons.mic_none_rounded, color: Colors.grey, size: 18),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: NoonTheme.noonBlack),
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
      body: Column(
        children: [
          // Recent Searches Horizontal Chips if Search Query is Empty
          if (_controller.text.isEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        appProvider.isArabic ? 'عمليات البحث الأخيرة' : 'Recent Searches',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() => _recentSearches.clear());
                        },
                        child: Text(
                          appProvider.isArabic ? 'مسح الكل' : 'Clear All',
                          style: const TextStyle(color: NoonTheme.saleRed, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _recentSearches.map((term) {
                      return GestureDetector(
                        onTap: () {
                          _controller.text = term;
                          appProvider.setSearchQuery(term);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.history_rounded, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(term, style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
          ],

          // Search Results Counter & Status
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _controller.text.isEmpty
                      ? (appProvider.isArabic ? 'جميع المنتجات' : 'Popular Products')
                      : '${appProvider.isArabic ? "نتائج البحث عن:" : "Results for"} "${_controller.text}"',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  '${results.length} ${appProvider.isArabic ? "منتج" : "items"}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          // Search Results Grid
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded, size: 60, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          appProvider.isArabic
                              ? 'لا توجد نتائج تطابق بحثك'
                              : 'No products found for "${_controller.text}"',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          appProvider.isArabic
                              ? 'جرب البحث عن كلمات أخرى مثل "iphone" أو "sony"'
                              : 'Try searching for "iphone", "sony", or "shoes"',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.52,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                    ),
                    itemCount: results.length,
                    itemBuilder: (ctx, idx) {
                      return ProductCard(product: results[idx]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
