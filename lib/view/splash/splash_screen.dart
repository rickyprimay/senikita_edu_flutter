// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:senikita_edu/res/widgets/fonts.dart';
import 'package:senikita_edu/viewModel/splash_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late AnimationController _opacityController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Inisialisasi Scale Animation
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );

    // Inisialisasi Opacity Animation
    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _opacityController, curve: Curves.easeOut),
    );

    // Jalankan animasi
    _scaleController.forward();
    _opacityController.forward();

    // Cek autentikasi setelah 4 detik (seperti SwiftUI delay 4 detik)
    Future.delayed(const Duration(seconds: 4), () {
      SplashService.checkAuthentication(context);
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // mirip SwiftUI Color.white
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_scaleController, _opacityController]),
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: Image.asset(
                        'assets/common/loading.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: Text(
                        'senikita',
                        style: AppFont.crimsonHeaderLarge.copyWith(
                          color: const Color(0xFF1E1E1E), // ganti sesuai warna 'primary'
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
