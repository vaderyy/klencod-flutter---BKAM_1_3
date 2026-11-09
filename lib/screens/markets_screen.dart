import 'package:flutter/material.dart';
import '../utils/app_strings.dart';
import '../utils/theme_provider.dart';
import '../main.dart';
import 'market_products_screen.dart';

class MarketsScreen extends StatelessWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = appSettings.lang;
    return Column(
      children: [
        // شريط علوي يحمل اسم المبرمج
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
          child: Text(
            AppStrings.t('developer', lang),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '${AppStrings.t('app_name', lang)} :',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.5,
            children: AppStrings.marketKeys.map((key) {
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MarketProductsScreen(marketKey: key),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    AppStrings.markets[lang]![key]!,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}