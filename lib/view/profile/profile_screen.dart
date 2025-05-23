import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/shared_preferences.dart';
import 'package:widya/utils/routes/routes_names.dart';
import 'package:widya/view/profile/widget/profile_info_tile_widget.dart';
import 'package:widya/viewModel/auth_view_model.dart';
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
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final sp = SharedPrefs.instance;
    final prefs = await sp;
    
    if (!mounted) return;
    
    setState(() {
      name = prefs.getString("user_name");
      photo = prefs.getString("user_photo");
      email = prefs.getString("user_email");
      _isDataLoaded = true;
    });
    
    if (mounted) {
      await Provider.of<EnrollmentsViewModel>(context, listen: false).fetchTotalEnrollments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildProfileHeader(),
            Expanded(
              child: _buildProfileContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.primary,
            AppColors.tertiary
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        image: DecorationImage(
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
          _buildProfileImage(),
          const SizedBox(height: 10),
          Text(
            name ?? 'User Name',
            style: AppFont.ralewaySubtitle.copyWith(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min, // Keep row compact
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                Image.asset("assets/logo/google_logo.png", width: 20, height: 20),
                const SizedBox(width: 8), 
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
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    if (!_isDataLoaded) {
      return Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white24,
        ),
        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return ClipOval(
      child: Image.network(
        photo ?? 'https://eduapi.senikita.my.id/storage/defaultpic.png',
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        // Add memory caching
        cacheWidth: 160, // 2x for high res displays
        cacheHeight: 160,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 80,
            height: 80,
            color: Colors.grey,
            child: const Icon(Icons.error, color: Colors.white, size: 40),
          );
        },
      ),
    );
  }

  Widget _buildProfileContent() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(), // More efficient scrolling physics
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildEnrollmentStats(),
              const SizedBox(height: 20),
              _buildSectionHeader('Pengaturan Akun'),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: _buildAccountSettings(),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _buildSectionHeader('Bantuan dan Lainnya'),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildSupportSection(),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          title,
          style: AppFont.nunitoSubtitle.copyWith(
            fontSize: 12,
            color: AppColors.primary.withAlpha(120),
          ),
        ),
      ),
    );
  }

  Widget _buildEnrollmentStats() {
    return Padding(
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
                  icon: Icons.check,
                  title: "Kelas",
                  label: "Selesai",
                  value: isDataLoaded ? "$completed" : "Memuat...",
                  cardColor: AppColors.customGreen.withAlpha(80),
                  borderColor: AppColors.customGreen.withAlpha(60),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InfoCardWidget(
                  icon: Icons.close,
                  title: "Kelas",
                  label: "Belum",
                  value: isDataLoaded ? "$notCompleted" : "Memuat...",
                  cardColor: AppColors.customRed.withAlpha(80),
                  borderColor: AppColors.customRed.withAlpha(60),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAccountSettings() {
    return Column(
      children: [
        ProfileInfoTile(
          icon: const Icon(Icons.email), 
          title: "Email", 
          subtitle: email ?? '', 
          trailing: const Icon(Icons.info_outline, size: 18, color: AppColors.primary)
        ),
        ProfileInfoTile(
          icon: const Icon(Icons.article),
          title: "Sertifikat",
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
          onTap: () {
            Navigator.of(context, rootNavigator: true).pushNamed(RouteNames.certificate);
          },
        ),
        ProfileInfoTile(
          icon: const Icon(Icons.auto_awesome_outlined),
          title: "Temu Batik",
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
          onTap: () {
            Navigator.of(context, rootNavigator: true).pushNamed(RouteNames.temuBatik);
          },
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      children: [
        ProfileInfoTile(
          icon: const Icon(Icons.help),
          title: "Bantuan",
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
          onTap: () {
            Navigator.of(context, rootNavigator: true).pushNamed(RouteNames.helpAndSupport);
          },
        ),
        ProfileInfoTile(
          icon: const Icon(Icons.info),
          title: "Tentang Widya",
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
          onTap: () {
            Navigator.of(context, rootNavigator: true).pushNamed(RouteNames.seniKitaEdu);
          },
        ),
        _buildMarketplaceTile(),
        _buildLogoutTile(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMarketplaceTile() {
    // Pre-loaded asset image for better performance
    final Widget icon = Image.asset(
      'assets/common/loading.png', 
      width: 24, 
      height: 24,
      // Add memory caching
      cacheWidth: 48,
      cacheHeight: 48,
    );
    
    return ProfileInfoTile(
      icon: icon,
      title: "Tentang SeniKita Marketplace",
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
      onTap: () {
        Navigator.of(context, rootNavigator: true).pushNamed(RouteNames.seniKita);
      },
    );
  }
  
  Widget _buildLogoutTile() {
    return ProfileInfoTile(
      icon: const Icon(Icons.logout),
      title: "Log Out",
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
      onTap: () => _showLogoutDialog(),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          children: [
            Column(
              children: [
                Text(
                  'Konfirmasi Logout', 
                  style: AppFont.crimsonTextSubtitle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary, 
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Apakah kamu yakin ingin keluar dari akun ini?',
                  style: AppFont.ralewaySubtitle.copyWith(
                    fontSize: 14,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.secondary,
                          side: BorderSide(color: AppColors.secondary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Batal',
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          authVM.logout(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.customRed,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Ya',
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}