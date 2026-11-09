import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../utils/app_strings.dart';
import '../utils/theme_provider.dart';
import '../main.dart';
import '../models/product.dart';
import '../services/database_helper.dart';
import '../services/image_matcher.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  Future<void> _shoot() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (x == null) return;

    // لا يُحفظ في المعرض — يُحفظ مؤقتًا فقط
    final sig = await ImageMatcher.signature(File(x.path));
    final match = await DatabaseHelper.instance.matchSignature(sig);

    if (!mounted) return;
    if (match == null) {
      _showNotFound();
    } else {
      _showMatch(match);
    }
  }

  void _showNotFound() {
    final lang = appSettings.lang;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppStrings.t('camera', lang)),
        content: Text(AppStrings.t('product_not_found', lang)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.t('cancel', lang)),
          ),
        ],
      ),
    );
  }

  void _showMatch(Product p) {
    final lang = appSettings.lang;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(p.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${AppStrings.t('price', lang)}: ${p.price}'),
            if (p.wholesalePrice != null)
              Text('${AppStrings.t('wholesale', lang)}: ${p.wholesalePrice}'),
            Text('${AppStrings.t('enter_size', lang)}: ${p.size}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = appSettings.lang;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 100,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              '${AppStrings.t('capture_product', lang)} 👇',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _shoot,
              icon: const Icon(Icons.camera),
              label: Text(AppStrings.t('camera', lang)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(220, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}