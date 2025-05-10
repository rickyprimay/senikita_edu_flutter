import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/shared_preferences.dart';
import 'package:widya/utils/routes/routes_names.dart';
import 'package:widya/view/profile/widget/profile_info_tile_widget.dart';
import 'package:widya/viewModel/auth_view_model.dart';
import 'package:quickalert/quickalert.dart';
import 'package:widya/view/profile/widget/info_card_widget.dart';
import 'package:widya/viewModel/enrollments_view_model.dart';

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
    await Provider.of<EnrollmentsViewModel>(context, listen: false).fetchTotalEnrollments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                          style: AppFont.crimsonTextSubtitle.copyWith(
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
                      photo ?? 'https://eduapi.senikita.my.id/storage/defaultpic.png',
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
                    style: AppFont.ralewaySubtitle.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    email ?? '',
                    style: AppFont.ralewaySubtitle.copyWith(
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
                      child: Consumer<EnrollmentsViewModel>(
                        builder: (context, viewModel, child) {
                          final totalEnrollments = viewModel.totalEnrollments;
                          final notCompleted = totalEnrollments?.data.totalCourse;
                          final completed = totalEnrollments?.data.totalCourseCompleted;
                    
                          bool isDataLoaded = notCompleted != null && completed != null;
                    
                          return Row(
                            children: [
                              Expanded(
                                child: InfoCardWidget(
                                  title: "Kelas dimiliki",
                                  icon: Icons.library_books,
                                  label: isDataLoaded
                                      ? "$notCompleted Belum selesai"
                                      : "Memuat...",
                                  value: isDataLoaded
                                      ? "$completed Sudah selesai"
                                      : "Memuat...",
                                ),
                              ),
                            ],
                          );
                        },
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
                    ProfileInfoTile(icon: const Icon(Icons.email), title: "Email", subtitle: email ?? '', trailing: const Icon(Icons.info_outline, size: 18, color: AppColors.primary)),
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
                    ProfileInfoTile(icon: const Icon(Icons.help), title: "Bantuan", trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary)),
                    ProfileInfoTile(
                      icon: const Icon(Icons.info),
                      title: "Tentang Widya",
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pushNamed(RouteNames.seniKitaEdu);
                      },
                    ),
                    ProfileInfoTile(
                      icon: Image.asset('assets/common/loading.png', width: 24, height: 24,),
                      title: "Tentang SeniKita Marketplace",
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pushNamed(RouteNames.seniKita);
                      },
                    ),
                    ProfileInfoTile(
                      icon: const Icon(Icons.logout),
                      title: "Log Out",
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
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
