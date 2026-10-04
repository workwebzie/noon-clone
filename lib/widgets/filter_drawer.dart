import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/noon_theme.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late RangeValues _currentRangeValues;
  late bool _expressOnly;
  late String _sortBy;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AppProvider>(context, listen: false);
    _currentRangeValues = RangeValues(provider.minPrice, provider.maxPrice);
    _expressOnly = provider.expressOnly;
    _sortBy = provider.sortBy;
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appProvider.isArabic ? 'تصفية وترتيب' : 'Filter & Sort Products',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _currentRangeValues = const RangeValues(0, 10000);
                      _expressOnly = false;
                      _sortBy = 'relevance';
                    });
                  },
                  child: Text(
                    appProvider.isArabic ? 'إعادة ضبط' : 'Reset All',
                    style: const TextStyle(color: NoonTheme.saleRed, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),

            // Sort Options
            Text(
              appProvider.isArabic ? 'ترتيب حسب' : 'Sort By',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            RadioGroup<String>(
              groupValue: _sortBy,
              onChanged: (val) {
                if (val != null) setState(() => _sortBy = val);
              },
              child: Column(
                children: [
                  RadioListTile<String>(
                    value: 'relevance',
                    title: Text(appProvider.isArabic ? 'الأكثر ملاءمة' : 'Relevance'),
                  ),
                  RadioListTile<String>(
                    value: 'price_low',
                    title: Text(appProvider.isArabic ? 'السعر: من الأقل للأعلى' : 'Price: Low to High'),
                  ),
                  RadioListTile<String>(
                    value: 'price_high',
                    title: Text(appProvider.isArabic ? 'السعر: من الأعلى للأقل' : 'Price: High to Low'),
                  ),
                  RadioListTile<String>(
                    value: 'rating',
                    title: Text(appProvider.isArabic ? 'الأعلى تقييماً' : 'Highest Customer Rating'),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Express Delivery Toggle Switch
            SwitchListTile(
              value: _expressOnly,
              activeThumbColor: NoonTheme.noonBlack,
              activeTrackColor: NoonTheme.yellowPrimary,
              title: Row(
                children: [
                  const Text('noon ', style: TextStyle(fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    color: NoonTheme.noonBlack,
                    child: const Text('express', style: TextStyle(color: NoonTheme.yellowPrimary, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  Text(appProvider.isArabic ? 'فقط' : 'Only'),
                ],
              ),
              subtitle: Text(appProvider.isArabic ? 'منتجات شحن سريع خلال 24 ساعة' : 'Items delivered free within 24 hours'),
              onChanged: (val) => setState(() => _expressOnly = val),
            ),
            const Divider(),

            // Price Range Slider
            Text(
              appProvider.isArabic ? 'نطاق السعر' : 'Price Range (${appProvider.currency})',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${appProvider.currency} ${_currentRangeValues.start.round()}'),
                Text('${appProvider.currency} ${_currentRangeValues.end.round()}'),
              ],
            ),
            RangeSlider(
              values: _currentRangeValues,
              min: 0,
              max: 10000,
              divisions: 50,
              activeColor: NoonTheme.noonBlack,
              inactiveColor: Colors.grey.shade300,
              labels: RangeLabels(
                '${_currentRangeValues.start.round()}',
                '${_currentRangeValues.end.round()}',
              ),
              onChanged: (values) {
                setState(() => _currentRangeValues = values);
              },
            ),
            const SizedBox(height: 20),

            // Apply Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: NoonTheme.yellowPrimary,
                  foregroundColor: NoonTheme.noonBlack,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  appProvider.setFilters(
                    minP: _currentRangeValues.start,
                    maxP: _currentRangeValues.end,
                    express: _expressOnly,
                    sort: _sortBy,
                  );
                  Navigator.pop(context);
                },
                child: Text(
                  appProvider.isArabic ? 'تطبيق الفلاتر' : 'Apply Filters',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
