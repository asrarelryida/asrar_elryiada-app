import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class MainNewsSlider extends StatefulWidget {
  final List<Map<String, dynamic>> sliderNewsList;
  final Function(BuildContext, Map<String, dynamic>) onNewsTap;

  const MainNewsSlider({
    super.key,
    required this.sliderNewsList,
    required this.onNewsTap,
  });

  @override
  State<MainNewsSlider> createState() => _MainNewsSliderState();
}

class _MainNewsSliderState extends State<MainNewsSlider> {
  late final PageController _sliderController;
  int _currentSliderIndex = 0;
  Timer? _sliderTimer;
  bool _isUserDragging = false;

  @override
  void initState() {
    super.initState();
    _sliderController = PageController();
    _startSliderTimer();
  }

  void _startSliderTimer() {
    _sliderTimer?.cancel();
    if (widget.sliderNewsList.length <= 1) return;

    _sliderTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!mounted) return;
      if (_isUserDragging) return;

      if (_sliderController.hasClients) {
        int nextPage = _currentSliderIndex + 1;
        if (nextPage >= widget.sliderNewsList.length) {
          nextPage = 0;
        }
        
        _sliderController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _sliderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sliderNewsList.isEmpty) {
      return Container(
        height: 360,
        color: Colors.black,
        child: const Center(child: Text('لا توجد أخبار', style: TextStyle(color: Colors.white))),
      );
    }

    return SizedBox(
      height: 360,
      child: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification) {
                _isUserDragging = true;
              } else if (notification is ScrollEndNotification) {
                _isUserDragging = false;
              }
              return false;
            },
            child: PageView.builder(
              controller: _sliderController,
              onPageChanged: (index) {
                if (mounted) {
                  setState(() {
                    _currentSliderIndex = index;
                  });
                }
              },
              itemCount: widget.sliderNewsList.length,
              itemBuilder: (context, index) {
                final mainNews = widget.sliderNewsList[index];
                return InkWell(
                  onTap: () => widget.onNewsTap(context, mainNews),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.black,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildNewsImage(mainNews['imageUrl'] ?? mainNews['image']),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 35,
                          right: 16,
                          left: 16,
                          child: Text(
                            mainNews['title'] ?? 'بدون عنوان',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // مؤشرات النقاط التفاعلية المستقلة
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.sliderNewsList.length > 20 ? 20 : widget.sliderNewsList.length,
                (dotIndex) => InkWell(
                  onTap: () {
                    _sliderController.animateToPage(
                      dotIndex,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: _currentSliderIndex == dotIndex ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: _currentSliderIndex == dotIndex
                            ? const Color(0xFFB71C1C)
                            : Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsImage(dynamic img) {
    String url = (img ?? '').toString().trim();
    
    if (url.startsWith('data:image')) {
      try {
        final base64Str = url.split(',').last;
        final bytes = base64Decode(base64Str);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _errorImagePlaceholder(),
        );
      } catch (_) {}
    }

    if (url.isNotEmpty && url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _errorImagePlaceholder(),
      );
    }
    
    return _errorImagePlaceholder();
  }

  Widget _errorImagePlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Icon(Icons.article, color: Color(0xFFB71C1C), size: 35),
    );
  }
}