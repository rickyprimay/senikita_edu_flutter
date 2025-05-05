// lib/view/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/viewModel/auth_view_model.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/provider/login_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final loginProvider = Provider.of<LoginProvider>(context);

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo/widya_text_logo.png',
                      height: 180,
                      width: 180,
                    ),
                    const SizedBox(height: 40),
                    AnimatedCrossFade(
                      firstChild: _buildLoginContent(),
                      secondChild: _buildRegisterContent(),
                      crossFadeState: loginProvider.isLogin
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 500),
                      firstCurve: Curves.easeInOut,
                      secondCurve: Curves.easeInOut,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: Image.asset(
                        'assets/logo/google_logo.png',
                        height: 30,
                        width: 30,
                      ),
                      label: Text(
                        loginProvider.isLogin
                            ? 'Masuk dengan Google'
                            : 'Daftar dengan Google',
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        loginProvider.isLogin
                            ? "Kami hanya mendukung login melalui Google untuk keamanan dan kemudahan akses"
                            : "Dengan mendaftar, Anda akan mendapatkan akses ke semua kursus dan materi pembelajaran seni dan budaya Indonesia",
                        style: AppFont.ralewayFootnoteSmall.copyWith(
                          color: AppColors.secondary,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          loginProvider.isLogin
                              ? 'Belum memiliki akun?'
                              : 'Sudah memiliki akun?',
                          style: AppFont.ralewayFootnoteLarge.copyWith(
                            color: AppColors.secondary,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            loginProvider.toggleLogin();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            loginProvider.isLogin ? 'Daftar' : 'Login',
                            style: AppFont.ralewayFootnoteLarge.copyWith(
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildLoginContent() {
    return Column(
      children: [
        Text(
          'Selamat Datang Kembali',
          style: AppFont.crimsonTextHeader.copyWith(
            color: AppColors.primary,
            fontSize: 28,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          "Silahkan Masuk untuk melanjutkan perjalanan budaya anda",
          style: AppFont.ralewayFootnoteLarge.copyWith(
            color: AppColors.secondary,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRegisterContent() {
    return Column(
      children: [
        Text(
          'Daftar Sekarang',
          style: AppFont.crimsonTextHeader.copyWith(
            color: AppColors.primary,
            fontSize: 28,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          "Silahkan Daftar untuk melanjutkan perjalanan budaya anda",
          style: AppFont.ralewayFootnoteLarge.copyWith(
            color: AppColors.secondary,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
