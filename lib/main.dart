import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'utils/theme_provider.dart';

final appSettings = AppSettings();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appSettings.load();
  runApp(const BkamApp());
}

class BkamApp extends StatelessWidget {
  const BkamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appSettings,
      builder: (context, _) {
        return MaterialApp(
          title: 'بكم؟',
          debugShowCheckedModeBanner: false,
          theme: appSettings.theme,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(appSettings.fontScale),
              ),
              child: Directionality(
                textDirection: appSettings.lang == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: child!,
              ),
            );
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}