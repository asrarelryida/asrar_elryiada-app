import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class WelcomeClockOverlay extends StatefulWidget {
  final Widget child;

  const WelcomeClockOverlay({super.key, required this.child});

  @override
  State<WelcomeClockOverlay> createState() => _WelcomeClockOverlayState();
}

class _WelcomeClockOverlayState extends State<WelcomeClockOverlay> with SingleTickerProviderStateMixin {
  bool _showClock = true;
  late Timer _timer;
  DateTime _dateTime = DateTime.now();
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // تحديث الوقت
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _dateTime = DateTime.now();
        });
      }
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // حركة انزلاق خفيفة للأسفل
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    // تكبير وانكماش (هيبدأ من نقطة اللوجو بفضل الـ Alignment)
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // 1. الموقع يفتح فوراً، والساعة تبدأ في الظهور والخروج من اللوجو بعد (ثانية واحدة)
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _controller.forward();
      }
    });

    // 2. بعد 5 ثواني (1 ثانية انتظار + 4 ثواني ظهور)، تنسحب وتدخل جوه اللوجو تاني
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _controller.reverse().then((_) {
          setState(() {
            _showClock = false;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الموقع شغال وظاهر بالكامل بدون أي غطاء أو تعتيم
        widget.child,

        // الساعة التفاعلية
        if (_showClock)
          Positioned(
            top: 75, // أسفل الهيدر مباشرة
            right: 25, // محاذاة مع اللوجو في أقصى اليمين
            child: IgnorePointer( // لعدم منع المستخدم من التفاعل مع الموقع خلف الساعة
              child: ScaleTransition(
                alignment: Alignment.topRight, // السحر هنا: نقطة الانطلاق والعودة هي اللوجو (أعلى اليمين)
                scale: _scaleAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: 200, // حجم كبير ومناسب للعرض الجانبي
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFB71C1C).withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CustomPaint(
                        painter: AseClockPainter(dateTime: _dateTime),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class AseClockPainter extends CustomPainter {
  final DateTime dateTime;

  AseClockPainter({required this.dateTime});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    final outerRingPaint = Paint()
      ..color = const Color(0xFFB71C1C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawCircle(center, radius - 4, outerRingPaint);

    final textSpan = const TextSpan(
      text: 'ASE',
      style: TextStyle(
        color: Color(0xFFB71C1C),
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textOffset = Offset(center.dx - (textPainter.width / 2), center.dy - radius + 30);
    textPainter.paint(canvas, textOffset);

    final tickPaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * pi / 180;
      final start = Offset(
        center.dx + (radius - 14) * cos(angle),
        center.dy + (radius - 14) * sin(angle),
      );
      final end = Offset(
        center.dx + (radius - 6) * cos(angle),
        center.dy + (radius - 6) * sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);
    }

    final hourAngle = ((dateTime.hour % 12) + dateTime.minute / 60) * 30 * pi / 180 - pi / 2;
    final hourPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, Offset(center.dx + 40 * cos(hourAngle), center.dy + 40 * sin(hourAngle)), hourPaint);

    final minuteAngle = (dateTime.minute + dateTime.second / 60) * 6 * pi / 180 - pi / 2;
    final minutePaint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, Offset(center.dx + 60 * cos(minuteAngle), center.dy + 60 * sin(minuteAngle)), minutePaint);

    final secondAngle = dateTime.second * 6 * pi / 180 - pi / 2;
    final secondPaint = Paint()
      ..color = const Color(0xFFB71C1C)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, Offset(center.dx + 70 * cos(secondAngle), center.dy + 70 * sin(secondAngle)), secondPaint);

    final centerDotPaint = Paint()..color = const Color(0xFFB71C1C);
    canvas.drawCircle(center, 5, centerDotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}