import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'theme/noon_theme.dart';
import 'screens/main_tab_navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const NoonApp(),
    ),
  );
}

class NoonApp extends StatelessWidget {
  const NoonApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return MaterialApp(
      title: 'noon - Online Shopping UAE, KSA, Egypt',
      debugShowCheckedModeBanner: false,
      theme: NoonTheme.lightTheme(appProvider.language),
      darkTheme: NoonTheme.darkTheme(appProvider.language),
      themeMode: appProvider.themeMode,
      home: const MainTabNavigation(),
    );
  }
}
