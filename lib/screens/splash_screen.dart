import 'package:flutter/material.dart';
import '../utils/app_strings.dart';
import '../utils/theme_provider.dart';
import '../main.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showLang = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _showLang = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = appSettings.theme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [t.colorScheme.primary, t.scaffoldBackgroundColor],
          ),
        ),
        child: Center(
          child: _showLang
              ? const _QuickLanguagePicker()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (b) => LinearGradient(
                        colors: [Colors.white, t.colorScheme.secondary],
                      ).createShader(b),
                      child: const Text(
                        'HELLO',
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: 88,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 6,
                          color: Colors.white,
                          shadows: [
                            Shadow(color: Colors.black26, blurRadius: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'المبرمج أحمد امليمدي',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.9),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ✅ StatelessWidget — الحل: نمرر context دائمًا من onPressed
class _QuickLanguagePicker extends StatelessWidget {
  const _QuickLanguagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.t('select_language', appSettings.lang),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _langBtn(context, 'العربية', 'ar'),
          _langBtn(context, 'English', 'en'),
        ],
      ),
    );
  }

  Widget _langBtn(BuildContext context, String label, String code) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            await appSettings.setLang(code);
            if (!context.mounted) return;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          },
          child: Text(label, style: const TextStyle(fontSize: 17)),
        ),
      ),
    );
  }
}