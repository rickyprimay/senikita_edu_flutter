import 'package:flutter/material.dart';
import 'package:senikita_edu/res/widgets/colors.dart';
import 'package:senikita_edu/res/widgets/fonts.dart';
import 'package:senikita_edu/res/widgets/shared_preferences.dart';
import 'package:senikita_edu/view/profile/widget/profile_info_tile_widget.dart';
import 'package:senikita_edu/viewModel/auth_view_model.dart';
import 'package:quickalert/quickalert.dart';
import 'package:senikita_edu/view/profile/widget/info_card_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authVM = AuthViewModel();

  String? name;
  String? photo;
  String? email;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final sp = SharedPrefs.instance;
    final prefs = await sp;
    setState(() {
      name = prefs.getString("user_name");
      photo = prefs.getString("user_photo");
      email = prefs.getString("user_email");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                image: const DecorationImage(
                  image: AssetImage('assets/common/hero-texture2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Profil Akun',
                          style: AppFont.crimsonTitleMedium.copyWith(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ClipOval(
                    child: Image.network(
                      photo ?? 'https://via.placeholder.com/150',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey,
                          child: const Icon(Icons.error, color: Colors.white, size: 40),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name ?? 'User Name',
                    style: AppFont.nunitoSubtitle.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    email ?? '',
                    style: AppFont.nunitoSubtitle.copyWith(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: InfoCardWidget(
                              title: "Kelas dimiliki",
                              icon: Icons.library_books,
                              label: "Belum selesai",
                              value: "2 Sudah selesai",
                              tag: "4",
                              tagColor: AppColors.customRed,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: InfoCardWidget(
                              title: "Kelas tersedia",
                              icon: Icons.school,
                              label: "Kamu Miliki",
                              value: "30 tersedia",
                              tag: "6",
                              tagColor: AppColors.customGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Pengaturan Akun',
                          style: AppFont.nunitoSubtitle.copyWith(
                            fontSize: 12,
                            color: AppColors.primary.withAlpha(120),
                          ),
                        ),
                      ),
                    ),
                    ProfileInfoTile(icon: const Icon(Icons.email), title: "Email", subtitle: email ?? '', trailing: const Icon(Icons.info_outline, size: 18, color: AppColors.lightBrick)),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Bantuan dan Lainnya',
                          style: AppFont.nunitoSubtitle.copyWith(
                            fontSize: 12,
                            color: AppColors.primary.withAlpha(120),
                          ),
                        ),
                      ),
                    ),
                    ProfileInfoTile(icon: const Icon(Icons.help), title: "Bantuan", trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.lightBrick)),
                    ProfileInfoTile(icon: const Icon(Icons.info), title: "Tentang SeniKitaEdu", trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.lightBrick)),
                    ProfileInfoTile(icon: Image.asset('assets/common/loading.png', width: 24, height: 24,), title: "Tentang SeniKita Marketplace", trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.lightBrick)),
                    ProfileInfoTile(
                      icon: const Icon(Icons.logout),
                      title: "Log Out",
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.lightBrick),
                      onTap: () {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          title: 'Konfirmasi',
                          text: 'Apakah kamu yakin ingin keluar dari akun ini?',
                          confirmBtnText: 'Ya',
                          confirmBtnColor: AppColors.customGreen,
                          onConfirmBtnTap: () {
                            authVM.logout(context);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
