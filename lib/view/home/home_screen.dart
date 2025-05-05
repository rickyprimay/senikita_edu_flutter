import 'package:flutter/material.dart';
import 'package:senikita_edu/res/widgets/colors.dart';
import 'package:senikita_edu/res/widgets/fonts.dart';
import 'package:senikita_edu/res/widgets/shared_preferences.dart';
import 'package:senikita_edu/view/home/widget/category_slider_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? name;
  String? photo;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final sp = SharedPrefs.instance;
    final prefs = await sp;
    name = prefs.getString("user_name");
    photo = prefs.getString("user_photo");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                image: DecorationImage(
                  image: AssetImage('assets/common/hero-texture.png'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.menu, color: Colors.white),
                      Text(
                        'SENIKITA EDU',
                        style: AppFont.crimsonTitleMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      ClipOval(
                        child: Image.network(
                          photo ?? 'https://placehold.co/150x150/png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey,
                              child: const Icon(Icons.error, color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Halo, $name👋',
                    style: AppFont.nunitoSubtitle.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Siapkah kamu untuk melestarikan Kesenian Indonesia? Mari Belajar Seni dan Budaya Nusantara Bersama Ahlinya',
                    style: AppFont.nunitoSubtitle.copyWith(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Cari Pembelajaran...',
                        hintStyle: AppFont.ralewaySubtitle.copyWith(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        suffixIcon: const Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const CategorySliderWidget(),
            const SizedBox(height: 20),
            // Course Cards Section
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  courseCard(
                    color: Colors.orange.shade100,
                    title: "Memainkan Gamelan",
                    subtitle: "Belajar memainkan alat musik tradisional gamelan dengan cara yang menyenangkan.",
                    duration: "1hr 9mnt",
                    icon: Icons.music_note,
                  ),
                  const SizedBox(height: 20),
                  courseCard(
                    color: Colors.blue.shade100,
                    title: "Mencanting Batik",
                    subtitle: "Belajar mencanting batik dengan teknik yang benar dan mudah dipahami.",
                    duration: "2hr 1mnt",
                    icon: Icons.brush,
                  ),
                  const SizedBox(height: 20),
                  courseCard(
                    color: Colors.orange.shade200,
                    title: "Belajar Tari Tradisional",
                    subtitle: "Belajar gerakan dasar tari tradisional Indonesia dengan mudah.",
                    duration: "1hr 5mnt",
                    icon: Icons.energy_savings_leaf,
                  ),
                  const SizedBox(height: 20),
                  courseCard(
                    color: Colors.green.shade200,
                    title: "Tari Piring Minangkabau",
                    subtitle: "Belajar Tari Piring Minangkabau dengan langkah-langkah yang mudah.",
                    duration: "1hr 5mnt",
                    icon: Icons.military_tech_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget courseCard({
    required Color color,
    required String title,
    required String subtitle,
    required String duration,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, size: 40, color: Colors.black87),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFont.ralewayHeaderMedium.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: AppFont.nunitoHeaderMedium.copyWith(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 14, color: Colors.orange[300]),
                      const SizedBox(width: 4),
                      Text(
                        duration,
                        style: AppFont.nunitoSubtitle.copyWith(
                          color: Colors.orange[400],
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
