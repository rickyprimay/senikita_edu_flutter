import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/viewModel/auth_view_model.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:widya/res/widgets/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            // image: DecorationImage(
            //   image: AssetImage('assets/common/hero-texture.png'),
            //   fit: BoxFit.cover,
            // ),
          ),
        ),
        // AnimatedPositioned(
        //   duration: const Duration(milliseconds: 500),
        //   top: -100,
        //   left: isLogin ? 250 : -100,
        //   child: Container(
        //     width: 280,
        //     height: 280,
        //     decoration: BoxDecoration(
        //       color: AppColors.primary.withAlpha(77),
        //       shape: BoxShape.circle,
        //     ),
        //   ),
        // ),
        // AnimatedPositioned(
        //   duration: const Duration(milliseconds: 500),
        //   bottom: -100,
        //   right: isLogin ? 250 : -100,
        //   child: Container(
        //     width: 240,
        //     height: 240,
        //     decoration: BoxDecoration(
        //       color: AppColors.primary.withAlpha(77),
        //       shape: BoxShape.circle,
        //     ),
        //   ),
        // ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Image.asset(
                      'assets/logo/widya_text_logo.png',
                      height: 180,
                      width: 180,
                    ),
                    const SizedBox(height: 60),
                    Text(
                      isLogin ? 'Selamat Datang Kembali' : 'Daftar Sekarang',
                      style: AppFont.crimsonTextHeader.copyWith(
                        color: AppColors.primary,
                        fontSize: 28,
                        // fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isLogin ? "Silahkan Masuk untuk melanjutkan perjalanan budaya anda" : "Silahkan Daftar untuk melanjutkan perjalanan budaya anda",
                      style: AppFont.ralewayFootnoteLarge.copyWith(
                        color: AppColors.secondary,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: Image.asset(
                        'assets/logo/google_logo.png',
                        height: 30,
                        width: 30,
                      ),
                      label: Text(
                        isLogin ? 'Masuk dengan Google' : 'Daftar dengan Google',
                        style: AppFont.ralewayTitleMedium.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        authVM.authenticateWithGoogle(context);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: Divider(
                            color: AppColors.secondary,
                            thickness: 1,
                            endIndent: 8,
                          ),
                        ),
                        Text(
                          "INFORMASI",
                          style: AppFont.ralewayFootnoteSmall.copyWith(
                            color: AppColors.secondary,
                            fontSize: 14,
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: AppColors.secondary,
                            thickness: 1,
                            indent: 8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isLogin ? "Kami hanya mendukung login melalui Google untuk keamanan dan kemudahan akses" : "Dengan mendaftar, Anda akan mendapatkan akses ke semua kursus dan materi pembelajaran seni dan budaya Indonesia",
                      style: AppFont.ralewayFootnoteSmall.copyWith(
                        color: AppColors.secondary,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLogin ? 'Belum memiliki akun?' : 'Sudah memiliki akun?',
                          style: AppFont.ralewayFootnoteLarge.copyWith(
                            color: AppColors.secondary,
                            fontSize: 16,
                          ),
                        ),
                        // const SizedBox(width: 2),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            isLogin ? 'Daftar' : 'Login',
                            style: AppFont.ralewayFootnoteLarge.copyWith(
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (authVM.loading) const Loading(opacity: 0.8),
      ],
    );
  }
}
