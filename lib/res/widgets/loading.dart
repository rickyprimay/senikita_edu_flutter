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
  late Animation<double> _rotationAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 360).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _shimmerAnimation = Tween<double>(begin: -200, end: 200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
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
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value * 3.14159 / 180,
                      child: Image.asset(
                        'assets/logo/widya_logo.png',
                        width: 120,
                        height: 120,
                        color: Colors.white.withAlpha(alpha),
                        colorBlendMode: BlendMode.srcATop,
                      ),
                    );
                  },
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationAnimation.value * 3.14159 / 180,
                          child: Image.asset(
                            'assets/logo/widya_logo.png',
                            width: 120,
                            height: 120,
                            colorBlendMode: BlendMode.srcATop,
                          ),
                        );
                      },
                    ),
                    ClipRect(
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: FractionalTranslation(
                              translation: Offset(_shimmerAnimation.value / 200, 0), 
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.5),
                                      Colors.white.withOpacity(0.1),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
            Text(
              "widya",
              style: AppFont.crimsonTextHeader.copyWith(
                color: AppColors.primary.withAlpha(alpha),
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}