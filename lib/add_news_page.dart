import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'widgets/news_editor_toolbar.dart'; // استدعاء شريط الأدوات المستقل

class AddNewsPage extends StatefulWidget {
  final String authorName;
  final Map<String, dynamic>? existingNews;

  const AddNewsPage({super.key, required this.authorName, this.existingNews});

  @override
  State<AddNewsPage> createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _feedbackLinkController = TextEditingController();
  final TextEditingController _feedbackTitleController = TextEditingController(); // حقل جديد لعنوان الرابط الداخلي
  final TextEditingController _videoLinkController = TextEditingController();
  late TextEditingController _authorNameController;

  String _selectedCategory = 'مقالات';
  
  final List<String> _categories = [
    'مصر',
    'عالمي',
    'الدوري المصري',
    'مقالات',
    'مباريات',
    'ألعاب أخرى',
    'فيديوهات وصور',
    'عام',
  ];

  String _selectedFontFamily = 'Cairo';
  double _fontSize = 14.0;
  TextAlign _contentTextAlign = TextAlign.right;
  Color _fontColor = Colors.black87; 

  Uint8List? _webImageBytes;
  String _imagePath = '';
  
  Uint8List? _authorImageBytes;
  String _authorImagePath = '';

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _authorNameController = TextEditingController(
      text: widget.existingNews?['author'] ?? '',
    );

    if (widget.existingNews != null) {
      _titleController.text = widget.existingNews!['title'] ?? '';
      _contentController.text = widget.existingNews!['content'] ?? widget.existingNews!['description'] ?? '';
      _feedbackLinkController.text = widget.existingNews!['feedbackLink'] ?? '';
      _feedbackTitleController.text = widget.existingNews!['feedbackTitle'] ?? '';
      _videoLinkController.text = widget.existingNews!['videoUrl'] ?? widget.existingNews!['videoLink'] ?? '';
      
      String cat = widget.existingNews!['category'] ?? 'مقالات';
      if (_categories.contains(cat)) {
        _selectedCategory = cat;
      } else {
        _selectedCategory = 'مقالات';
      }

      _imagePath = widget.existingNews!['imageUrl'] ?? widget.existingNews!['image'] ?? '';
      _authorImagePath = widget.existingNews!['authorImage'] ?? '';
      _selectedFontFamily = widget.existingNews!['fontFamily'] ?? 'Cairo';
      _fontSize = (widget.existingNews!['fontSize'] ?? 14.0).toDouble();
    }
  }

  void _formatText(String prefix, String suffix) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    
    if (selection.isValid && !selection.isCollapsed) {
      final selectedText = text.substring(selection.start, selection.end);
      final newText = text.replaceRange(selection.start, selection.end, '$prefix$selectedText$suffix');
      
      setState(() {
        _contentController.text = newText;
        _contentController.selection = TextSelection.collapsed(
          offset: selection.end + prefix.length + suffix.length,
        );
      });
    } else {
      final cursorPosition = selection.isValid ? selection.baseOffset : text.length;
      final newText = text.replaceRange(cursorPosition, cursorPosition, '$prefix$suffix');
      
      setState(() {
        _contentController.text = newText;
        _contentController.selection = TextSelection.collapsed(
          offset: cursorPosition + prefix.length,
        );
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var bytes = await image.readAsBytes();
        String base64Image = 'data:image/png;base64,${base64Encode(bytes)}';
        
        setState(() {
          _webImageBytes = bytes;
          _imagePath = base64Image;
        });
      }
    } catch (e) {
      debugPrint('Error picking news image: $e');
    }
  }

  Future<void> _pickAuthorImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var bytes = await image.readAsBytes();
        String base64Image = 'data:image/png;base64,${base64Encode(bytes)}';
        
        setState(() {
          _authorImageBytes = bytes;
          _authorImagePath = base64Image;
        });
      }
    } catch (e) {
      debugPrint('Error picking author image: $e');
    }
  }

  void _saveNews() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال عنوان وتفاصيل المقال على الأقل'), backgroundColor: Colors.red),
      );
      return;
    }

    DateTime now = DateTime.now();
    String formattedDateTime = '${now.year}-${now.month}-${now.day} – ${now.hour}:${now.minute}';

    Map<String, dynamic> newsItem = {
      'title': _titleController.text.trim(),
      'content': _contentController.text.trim(),
      'category': _selectedCategory,
      'imageUrl': _imagePath,
      'image': _imagePath,
      'authorImage': _authorImagePath,
      'videoUrl': _videoLinkController.text.trim(),
      'videoLink': _videoLinkController.text.trim(),
      'feedbackLink': _feedbackLinkController.text.trim(),
      'feedbackTitle': _feedbackTitleController.text.trim(), // حفظ عنوان الرابط الداخلي
      'dateTime': formattedDateTime,
      'author': _authorNameController.text.trim(),
      'fontFamily': _selectedFontFamily,
      'fontSize': _fontSize,
      'fontColor': _fontColor.value,
    };

    Navigator.pop(context, newsItem);
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    bool isEditing = widget.existingNews != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'تعديل المقال أو الخبر' : 'إضافة مقال أو خبر جديد', style: const TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFFB71C1C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('تاريخ النشر: ${now.year}-${now.month}-${now.day}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const Divider(height: 24),
                
                const Text('اسم الكاتب', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _authorNameController,
                  decoration: InputDecoration(
                    hintText: 'اكتب اسم كاتب المقال...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),

                const Text('صورة الكاتب (من الكمبيوتر)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _pickAuthorImage,
                      icon: const Icon(Icons.person, color: Color(0xFFB71C1C)),
                      label: const Text('اختيار صورة الكاتب'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        _authorImagePath.isNotEmpty ? 'تم اختيار صورة الكاتب بنجاح' : 'لم يتم اختيار صورة للكاتب بعد',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (_authorImageBytes != null) ...[
                  const SizedBox(height: 12),
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: MemoryImage(_authorImageBytes!),
                  ),
                ],
                const SizedBox(height: 16),

                const Text('عنوان المقال / الخبر', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'اكتب عنواناً جذاباً...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('تصنيف القسم', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                      onChanged: (val) => setState(() => _selectedCategory = val!),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                const Text('تفاصيل المقال / الخبر', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                NewsEditorToolbar(
                  onFormatText: (prefix, suffix) {
                    _formatText(prefix, suffix);
                  },
                  contentTextAlign: _contentTextAlign,
                  onTextAlignChanged: (align) {
                    setState(() {
                      _contentTextAlign = align;
                    });
                  },
                  fontSize: _fontSize,
                  onFontSizeChanged: (size) {
                    setState(() {
                      _fontSize = size;
                    });
                  },
                  fontColor: _fontColor,
                  onFontColorChanged: (color) {
                    setState(() {
                      _fontColor = color;
                    });
                  },
                ),

                TextField(
                  controller: _contentController,
                  maxLines: 6,
                  textAlign: _contentTextAlign,
                  style: TextStyle(
                    fontSize: _fontSize, 
                    color: _fontColor,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'اكتب التفاصيل كاملاً هنا...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // قسم إدخال رابط داخلي (Backlink) احترافي
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('إضافة رابط داخلي (Backlink) لخبر سابق', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB71C1C))),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _feedbackTitleController,
                        decoration: InputDecoration(
                          hintText: 'نص الرابط (مثال: اقرأ أيضاً: سقوط الأهلي أمام فيزبريم)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _feedbackLinkController,
                        decoration: InputDecoration(
                          hintText: 'رابط الخبر (مثال: https://asrarelriyada.github.io/asrar_elryiada/)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const Text('صورة المقال/الخبر الرئيسية (من الكمبيوتر)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _pickImage,
                      icon: const Icon(Icons.upload_file, color: Color(0xFFB71C1C)),
                      label: const Text('اختيار صورة الخبر'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        _imagePath.isNotEmpty ? 'تم اختيار صورة الخبر بنجاح' : 'لم يتم اختيار صورة للخبر بعد',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (_webImageBytes != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(image: MemoryImage(_webImageBytes!), fit: BoxFit.cover),
                    ),
                  ),
                ],
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB71C1C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _saveNews,
                    child: Text(isEditing ? 'حفظ التعديلات' : 'نشر وحفظ المقال', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}