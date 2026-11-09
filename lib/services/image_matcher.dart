import 'dart:io';
import 'package:image/image.dart' as img;

class ImageMatcher {
  /// يولّد بصمة 64-بت من الصورة (تحويل إلى 8×8 رمادي ثم متوسط)
  static Future<String> signature(File file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return '';
    final small = img.copyResize(image, width: 8, height: 8, interpolation: img.Interpolation.average);
    final gray = img.grayscale(small);
    final pixels = <int>[];
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        final p = gray.getPixel(x, y);
        pixels.add(((p.r + p.g + p.b) / 3).round());
      }
    }
    final avg = pixels.reduce((a, b) => a + b) / pixels.length;
    final bits = pixels.map((p) => p >= avg ? '1' : '0').join();
    return bits; // 64 خانة
  }
}