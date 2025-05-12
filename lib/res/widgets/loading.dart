import 'package:flutter/material.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';

class Loading extends StatefulWidget {
  final double opacity;
  const Loading({Key? key, required this.opacity}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),  // Faster shimmer effect
      vsync: this,
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int alpha = (widget.opacity * 255).round();
    
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(widget.opacity),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/logo/widya_logo.png',
                  width: 120,
                  height: 120,
                ),
                
                // Shimmer effect overlay
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return ClipRect(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.6),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                            begin: Alignment(-1.0 + _shimmerAnimation.value * 2, 0.0),
                            end: Alignment(1.0 + _shimmerAnimation.value * 2, 0.0),
                          ),
                          backgroundBlendMode: BlendMode.srcATop,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "widya",
              style: AppFont.crimsonTextHeader.copyWith(
                color: AppColors.primary.withAlpha(alpha),
                letterSpacing: 2,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 120,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary.withAlpha(alpha)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}