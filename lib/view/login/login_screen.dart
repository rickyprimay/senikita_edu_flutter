import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senikita_edu/res/widgets/fonts.dart';
import 'package:senikita_edu/viewModel/auth_view_model.dart';
import 'package:senikita_edu/res/widgets/loading.dart';
import 'package:senikita_edu/res/widgets/colors.dart';

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
              colors: [Colors.white, AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            // image: DecorationImage(
            //   image: AssetImage('assets/common/hero-texture.png'),
            //   fit: BoxFit.cover,
            // ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          top: -100,
          left: isLogin ? 250 : -100,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          bottom: -100,
          right: isLogin ? 250 : -100,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 120),
                    Image.asset(
                      'assets/logo/senikita_logo.png',
                      height: 180,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      isLogin ? 'Selamat Datang' : 'Buat Akun Baru',
                      style: AppFont.nunitoHeaderMedium.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      icon: Image.asset(
                        'assets/logo/google_logo.png',
                        height: 30,
                        width: 30,
                      ),
                      label: Text(
                        isLogin ? 'Login dengan Google' : 'Daftar dengan Google',
                        style: AppFont.nunitoTitleMedium.copyWith(
                          color: Colors.black,
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
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        elevation: 5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLogin ? 'Belum punya akun?' : 'Sudah punya akun?',
                          style: AppFont.nunitoBodyMedium.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.greyCustom,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.tertiary,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              isLogin ? 'Daftar' : 'Login',
                              style: AppFont.nunitoBodyMedium.copyWith(
                                color: AppColors.tertiary,
                                fontWeight: FontWeight.bold,
                              ),
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
