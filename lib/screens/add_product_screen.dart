import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../utils/app_strings.dart';
import '../utils/theme_provider.dart';
import '../main.dart';
import '../models/product.dart';
import '../services/database_helper.dart';
import '../services/image_matcher.dart';

class AddProductScreen extends StatefulWidget {
  final String marketKey;
  const AddProductScreen({super.key, required this.marketKey});
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String? _imagePath;

  Future<void> _pick(bool fromCamera) async {
    final picker = ImagePicker();
    final XFile? x = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80,
    );
    if (x != null) {
      final dir = await getApplicationDocumentsDirectory();
      final newPath = path.join(
        dir.path,
        'product_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await File(x.path).copy(newPath);
      setState(() => _imagePath = newPath);
      _continueFlow();
    }
  }

  Future<void> _continueFlow() async {
    final lang = appSettings.lang;
    // 1) اسم المنتج
    final name = await _askText(AppStrings.t('enter_name', lang));
    if (name == null || name.trim().isEmpty) return;

    // 2) الحجم
    final size = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppStrings.t('enter_size', lang)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _sizeBtn(AppStrings.t('size_large', lang), 'large'),
            _sizeBtn(AppStrings.t('size_medium', lang), 'medium'),
            _sizeBtn(AppStrings.t('size_small', lang), 'small'),
            _sizeBtn(AppStrings.t('size_none', lang), 'none'),
          ],
        ),
      ),
    );
    if (size == null) return;

    // 3) السعر
    final priceStr = await _askText(AppStrings.t('enter_price', lang), number: true);
    if (priceStr == null) return;
    final price = double.tryParse(priceStr) ?? 0;

    // 4) هل يريد سعر جملة؟
    final addWhole = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppStrings.t('add_wholesale', lang)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppStrings.t('no', lang)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppStrings.t('wholesale_price', lang)),
          ),
        ],
      ),
    );

    double? wholesale;
    if (addWhole == true) {
      final w = await _askText(AppStrings.t('wholesale_price', lang), number: true);
      if (w == null) return;
      wholesale = double.tryParse(w);
    }

    // 5) حفظ
    final sig = await ImageMatcher.signature(File(_imagePath!));
    final p = Product(
      marketKey: widget.marketKey,
      name: name,
      size: size,
      price: price,
      wholesalePrice: wholesale,
      imagePath: _imagePath!,
      imageSignature: sig,
    );
    await DatabaseHelper.instance.insert(p);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.t('save', lang))),
      );
      Navigator.pop(context);
    }
  }

  Widget _sizeBtn(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context, value),
        child: Text(label),
      ),
    ),
  );

  Future<String?> _askText(String title, {bool number = false}) async {
    final c = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: c,
          keyboardType: number ? TextInputType.number : TextInputType.text,
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('...')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, c.text),
            child: Text(AppStrings.t('save', appSettings.lang)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = appSettings.lang;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.t('add_product', lang)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (_imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(File(_imagePath!), height: 180, fit: BoxFit.cover),
              ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _pick(true),
              icon: const Icon(Icons.camera_alt),
              label: Text(AppStrings.t('capture_product', lang)),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(55)),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () => _pick(false),
              icon: const Icon(Icons.image),
              label: Text(AppStrings.t('retrieve_product', lang)),
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(55)),
            ),
          ],
        ),
      ),
    );
  }
}