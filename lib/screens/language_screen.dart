import 'package:flutter/material.dart';
import '../utils/app_strings.dart';
import '../utils/theme_provider.dart';
import '../main.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اللغة / Language')),
      body: Column(
        children: [
          ListTile(
            title: const Text('العربية'),
            trailing: appSettings.lang == 'ar'
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () async {
              await appSettings.setLang('ar');
              if (context.mounted) Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('English'),
            trailing: appSettings.lang == 'en'
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () async {
              await appSettings.setLang('en');
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}