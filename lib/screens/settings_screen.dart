import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_strings.dart';
import '../utils/theme_provider.dart';
import '../main.dart';
import 'language_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = appSettings.lang;
    final primary = Theme.of(context).colorScheme.primary;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          AppStrings.t('settings', lang),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // تبديل اللغة
        Card(
          child: ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppStrings.t('select_language', lang)),
            trailing: Text(lang == 'ar' ? 'العربية' : 'English'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const LanguageScreen())),
          ),
        ),

        // وضع الشاشة
        Card(
          child: SwitchListTile(
            secondary: const Icon(Icons.brightness_6),
            title: Text(AppStrings.t('theme_light', lang)),
            value: appSettings.isDark,
            onChanged: (v) => appSettings.setDark(v),
          ),
        ),

        // حجم الخط
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.format_size),
                title: Text(AppStrings.t('font_size', lang)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  children: [
                    _fontBtn(context, primary,
                        AppStrings.t('small', lang), 0.85),
                    _fontBtn(context, primary,
                        AppStrings.t('medium', lang), 1.0),
                    _fontBtn(context, primary,
                        AppStrings.t('large', lang), 1.25),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),

        // المساعدة (واتساب)
        Card(
          child: ListTile(
            leading: const Icon(Icons.help_outline, color: Color(0xFF25D366)),
            title: Text(AppStrings.t('help', lang)),
            subtitle: const Text('+218 93 427 4024'),
            onTap: () async {
              final uri = Uri.parse(
                  'https://wa.me/218934274024?text=مرحباً، أحتاج مساعدة في تطبيق بكم');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
        ),

        const SizedBox(height: 40),
        Center(
          child: Text(
            AppStrings.t('developer', lang),
            style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
          ),
        ),
      ],
    );
  }

  Widget _fontBtn(
      BuildContext context, Color primary, String label, double value) {
    final selected = (appSettings.fontScale - value).abs() < 0.01;
    return ElevatedButton(
      onPressed: () => appSettings.setFont(value),
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? primary : null,
      ),
      child: Text(label),
    );
  }
}