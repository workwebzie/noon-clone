import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/noon_theme.dart';
import '../widgets/order_tracker.dart';
import 'order_details_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appProvider.isArabic ? 'حسابي' : 'My Account',
          style: const TextStyle(fontWeight: FontWeight.bold, color: NoonTheme.noonBlack),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [NoonTheme.noonBlack, NoonTheme.noonDarkHeader],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: NoonTheme.yellowPrimary,
                    child: Text('SN', style: TextStyle(fontWeight: FontWeight.w900, color: NoonTheme.noonBlack, fontSize: 18)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Shaan Nuhman',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'shaan.nuhman@example.com',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: NoonTheme.yellowPrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'noon VIP Member • Free Express Delivery',
                            style: TextStyle(color: NoonTheme.noonBlack, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Active Order Tracker Section
            if (appProvider.orders.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    appProvider.isArabic ? 'طلبك النشط' : 'Active Order Tracking',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => OrderDetailsScreen(order: appProvider.orders.first),
                        ),
                      );
                    },
                    child: Text(appProvider.isArabic ? 'التفاصيل' : 'View Details'),
                  ),
                ],
              ),
              OrderTrackerWidget(order: appProvider.orders.first),
              const SizedBox(height: 16),
            ],

            // Menu Settings & Options
            Text(
              appProvider.isArabic ? 'إعدادات الحساب' : 'Account & Preferences',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _buildTile(
              context,
              icon: Icons.receipt_long_rounded,
              title: appProvider.isArabic ? 'طلباتي' : 'My Orders (${appProvider.orders.length})',
              subtitle: appProvider.isArabic ? 'عرض وتتبع الطلبات السابقة' : 'View past purchase receipts & track shipments',
              onTap: () {
                if (appProvider.orders.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => OrderDetailsScreen(order: appProvider.orders.first)),
                  );
                }
              },
            ),

            _buildTile(
              context,
              icon: Icons.location_on_outlined,
              title: appProvider.isArabic ? 'العناوين المحفوظة' : 'Saved Addresses',
              subtitle: appProvider.selectedAddress?.fullAddress ?? 'Manage delivery addresses',
              onTap: () {},
            ),

            _buildTile(
              context,
              icon: Icons.credit_card_rounded,
              title: appProvider.isArabic ? 'رصيد نون باي وبطاقات الشراء' : 'noon Pay & Cards',
              subtitle: 'Balance: AED 250.00',
              onTap: () {},
            ),

            // Language Switcher Tile
            ListTile(
              leading: const Icon(Icons.language_rounded, color: NoonTheme.noonBlack),
              title: Text(appProvider.isArabic ? 'اللغة' : 'App Language'),
              subtitle: Text(appProvider.isArabic ? 'العربية' : 'English'),
              trailing: Switch(
                value: appProvider.isArabic,
                activeThumbColor: NoonTheme.yellowPrimary,
                onChanged: (val) => appProvider.toggleLanguage(),
              ),
            ),
            const Divider(height: 1),

            // Dark Mode Switcher Tile
            ListTile(
              leading: const Icon(Icons.dark_mode_outlined, color: NoonTheme.noonBlack),
              title: Text(appProvider.isArabic ? 'الوضع الداكن' : 'Dark Mode Theme'),
              subtitle: Text(appProvider.isDarkMode ? 'Dark' : 'Light'),
              trailing: Switch(
                value: appProvider.isDarkMode,
                activeThumbColor: NoonTheme.yellowPrimary,
                onChanged: (val) => appProvider.toggleTheme(),
              ),
            ),

            const Divider(height: 20),

            // Customer Support
            Text(
              appProvider.isArabic ? 'المساعدة والدعم' : 'Help & Support',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _buildTile(
              context,
              icon: Icons.help_outline_rounded,
              title: appProvider.isArabic ? 'مركز المساعدة و الأسئلة الشائعة' : 'Help Center & FAQs',
              subtitle: '24/7 Customer Care Assistant',
              onTap: () {},
            ),

            _buildTile(
              context,
              icon: Icons.privacy_tip_outlined,
              title: appProvider.isArabic ? 'الشروط والأحكام والخصوصية' : 'Terms & Privacy Policy',
              subtitle: 'Version 3.35.6 Noon Clone',
              onTap: () {},
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: NoonTheme.noonBlack),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
          trailing: const Icon(Icons.chevron_right_rounded, size: 20),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}
