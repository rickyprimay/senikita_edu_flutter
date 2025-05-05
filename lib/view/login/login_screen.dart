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
                    const SizedBox(height: 120),
                    Image.asset(
                      'assets/logo/senikita_logo.png',
                      height: 180,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isLogin ? 'Selamat Datang' : 'Bergabunglah dengan kami',
                      style: AppFont.crimsonHeaderLarge.copyWith(
                        color: AppColors.primary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: Image.asset(
                        'assets/logo/google_logo.png',
                        height: 30,
                        width: 30,
                      ),
                      label: Text(
                        isLogin ? 'Login dengan Google' : 'Daftar dengan Google',
                        style: AppFont.ralewayTitleMedium.copyWith(
                          color: Colors.black,
                          fontSize: 16,
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
                    const SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: Divider(
                            color: Colors.white70,
                            thickness: 1,
                            endIndent: 8, // Jarak ke teks
                          ),
                        ),
                        Text(
                          "Informasi",
                          style: AppFont.ralewayFootnoteSmall.copyWith(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Colors.white70,
                            thickness: 1,
                            indent: 8, // Jarak ke teks
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Dengan mendaftar, Anda akan mendapatkan akses ke semua kursus dan materi pembelajaran seni dan budaya Indonesia",
                      style: AppFont.ralewayFootnoteSmall.copyWith(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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
                            color: AppColors.greyCustom,
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
                              color: AppColors.secondary,
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
