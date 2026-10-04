import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/noon_theme.dart';
import '../screens/search_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/wishlist_screen.dart';

class NoonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showSearchBar;

  const NoonAppBar({
    super.key,
    this.showSearchBar = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(showSearchBar ? 115.0 : 60.0);

  void _showCountryPicker(BuildContext context, AppProvider appProvider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    appProvider.isArabic ? 'اختر الدولة' : 'Select Country / Region',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  )
                ],
              ),
              const Divider(),
              ListTile(
                leading: const Text('🇦🇪', style: TextStyle(fontSize: 28)),
                title: const Text('United Arab Emirates (AED)'),
                trailing: appProvider.country == 'UAE'
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                onTap: () {
                  appProvider.setCountry('UAE', '🇦🇪', 'AED');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Text('🇸🇦', style: TextStyle(fontSize: 28)),
                title: const Text('Saudi Arabia (SAR)'),
                trailing: appProvider.country == 'KSA'
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                onTap: () {
                  appProvider.setCountry('KSA', '🇸🇦', 'SAR');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Text('🇪🇬', style: TextStyle(fontSize: 28)),
                title: const Text('Egypt (EGP)'),
                trailing: appProvider.country == 'Egypt'
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                onTap: () {
                  appProvider.setCountry('Egypt', '🇪🇬', 'EGP');
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLocationPicker(BuildContext context, AppProvider appProvider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appProvider.isArabic ? 'عنوان التوصيل' : 'Choose Delivery Location',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...appProvider.addresses.map((addr) {
                bool isSelected = appProvider.selectedAddress?.id == addr.id;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? NoonTheme.yellowPrimary : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Icon(
                      addr.label == 'Home' ? Icons.home_rounded : Icons.work_rounded,
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                    title: Text('${addr.label} - ${addr.recipientName}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(addr.fullAddress),
                    trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.black) : null,
                    onTap: () {
                      appProvider.setSelectedAddress(addr);
                      Navigator.pop(ctx);
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Container(
      color: NoonTheme.yellowPrimary,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Bar: Delivery location + Language toggle + Country flag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              color: NoonTheme.noonBlack.withValues(alpha: 0.04),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => _showLocationPicker(context, appProvider),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 16, color: NoonTheme.noonBlack),
                        const SizedBox(width: 4),
                        Text(
                          appProvider.isArabic ? 'التوصيل إلى: ' : 'Deliver to: ',
                          style: const TextStyle(fontSize: 11, color: Colors.black87),
                        ),
                        Text(
                          appProvider.selectedAddress?.city ?? 'Dubai Marina',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: NoonTheme.noonBlack,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: NoonTheme.noonBlack),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Country Flag Button
                  InkWell(
                    onTap: () => _showCountryPicker(context, appProvider),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Row(
                        children: [
                          Text(appProvider.countryFlag, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 2),
                          Text(
                            appProvider.country,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Dark / Light Toggle
                  GestureDetector(
                    onTap: () => appProvider.toggleTheme(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        appProvider.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                        size: 14,
                        color: NoonTheme.noonBlack,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Language Toggle Button (EN / العربية)
                  InkWell(
                    onTap: () => appProvider.toggleLanguage(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: NoonTheme.noonBlack, width: 0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        appProvider.isArabic ? 'English' : 'العربية',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: NoonTheme.noonBlack,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Bar: Noon Logo + Search Bar + Wishlist + Cart Badge
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  // Noon Brand Text Logo
                  GestureDetector(
                    onTap: () {
                      appProvider.resetFilters();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: const Text(
                        'noon',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: NoonTheme.noonBlack,
                          letterSpacing: -1.2,
                          fontFamily: 'sans-serif',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Search Bar Input Container
                  if (showSearchBar)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (ctx) => const SearchScreen()),
                          );
                        },
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search_rounded, color: Colors.grey, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  appProvider.isArabic
                                      ? 'عن ماذا تبحث؟'
                                      : 'What are you looking for?',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Icon(Icons.camera_alt_outlined, color: Colors.grey.shade600, size: 18),
                              const SizedBox(width: 8),
                              Icon(Icons.mic_none_rounded, color: Colors.grey.shade600, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(width: 8),

                  // Wishlist Icon
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                    icon: const Icon(Icons.favorite_border_rounded, color: NoonTheme.noonBlack, size: 24),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (ctx) => const WishlistScreen()),
                      );
                    },
                  ),

                  // Cart Icon Badge
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.shopping_cart_outlined, color: NoonTheme.noonBlack, size: 25),
                        if (appProvider.cartCount > 0)
                          Positioned(
                            right: -4,
                            top: -4,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: NoonTheme.noonBlack,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                '${appProvider.cartCount}',
                                style: const TextStyle(
                                  color: NoonTheme.yellowPrimary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (ctx) => const CartScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
