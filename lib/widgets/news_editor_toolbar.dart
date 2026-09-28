import 'package:flutter/material.dart';

class NewsEditorToolbar extends StatelessWidget {
  final Function(String prefix, String suffix) onFormatText;
  final TextAlign contentTextAlign;
  final Function(TextAlign) onTextAlignChanged;
  final double fontSize;
  final Function(double) onFontSizeChanged;
  final Color fontColor;
  final Function(Color) onFontColorChanged;

  const NewsEditorToolbar({
    super.key,
    required this.onFormatText,
    required this.contentTextAlign,
    required this.onTextAlignChanged,
    required this.fontSize,
    required this.onFontSizeChanged,
    required this.fontColor,
    required this.onFontColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 1. زر الخط العريض B في أقصى اليمين
            IconButton(
              icon: const Icon(Icons.format_bold, color: Color(0xFFB71C1C)),
              tooltip: 'خط عريض (Bold)',
              onPressed: () => onFormatText('**', '**'),
            ),
            const VerticalDivider(width: 15, thickness: 1),

            // 2. أزرار المحاذاة بجوار بعضها
            IconButton(
              icon: const Icon(Icons.format_align_right),
              tooltip: 'محاذاة لليمين',
              onPressed: () => onTextAlignChanged(TextAlign.right),
            ),
            IconButton(
              icon: const Icon(Icons.format_align_center),
              tooltip: 'توسيط',
              onPressed: () => onTextAlignChanged(TextAlign.center),
            ),
            IconButton(
              icon: const Icon(Icons.format_align_left),
              tooltip: 'محاذاة لليسار',
              onPressed: () => onTextAlignChanged(TextAlign.left),
            ),
            const VerticalDivider(width: 15, thickness: 1),

            // 3. قائمة حجم الخط
            DropdownButton<double>(
              value: fontSize,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 14.0, child: Text('خط صغير (14)')),
                DropdownMenuItem(value: 16.0, child: Text('خط متوسط (16)')),
                DropdownMenuItem(value: 20.0, child: Text('خط كبير (20)')),
              ],
              onChanged: (val) => onFontSizeChanged(val ?? 14.0),
            ),
            const SizedBox(width: 12),

            // 4. قائمة لون الخط في اليسار
            DropdownButton<Color>(
              value: fontColor,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: Colors.black87, child: Text('أسود', style: TextStyle(color: Colors.black87))),
                DropdownMenuItem(value: Color(0xFFB71C1C), child: Text('أحمر', style: TextStyle(color: Color(0xFFB71C1C)))),
                DropdownMenuItem(value: Colors.blue, child: Text('أزرق', style: TextStyle(color: Colors.blue))),
                DropdownMenuItem(value: Colors.green, child: Text('أخضر', style: TextStyle(color: Colors.green))),
              ],
              onChanged: (val) => onFontColorChanged(val ?? Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}