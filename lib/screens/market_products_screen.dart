import 'package:flutter/material.dart';
import 'dart:io';
import '../utils/app_strings.dart';
import '../utils/theme_provider.dart';
import '../main.dart';
import '../models/product.dart';
import '../services/database_helper.dart';
import 'add_product_screen.dart';

class MarketProductsScreen extends StatefulWidget {
  final String marketKey;
  const MarketProductsScreen({super.key, required this.marketKey});
  @override
  State<MarketProductsScreen> createState() => _MarketProductsScreenState();
}

class _MarketProductsScreenState extends State<MarketProductsScreen> {
  List<Product> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await DatabaseHelper.instance.byMarket(widget.marketKey);
    setState(() { _items = list; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final lang = appSettings.lang;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.markets[lang]![widget.marketKey]!),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(
            builder: (_) => AddProductScreen(marketKey: widget.marketKey),
          ));
          _load();
        },
        icon: const Icon(Icons.add),
        label: Text(AppStrings.t('add_product', lang)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? Center(child: Text(AppStrings.t('empty_market', lang)))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 90),
                  itemCount: _items.length,
                  itemBuilder: (c, i) {
                    final p = _items[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(p.imagePath),
                            width: 56, height: 56, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image, size: 40),
                          ),
                        ),
                        title: Text(p.name),
                        subtitle: Text(
                          '${AppStrings.t('price', lang)}: ${p.price}'
                          '${p.wholesalePrice != null ? ' | ${AppStrings.t('wholesale', lang)}: ${p.wholesalePrice}' : ''}'
                          '\n${p.size}',
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }
}