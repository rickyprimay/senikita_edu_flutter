import 'package:flutter/material.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SeniKitaEduScreen extends StatefulWidget {
  const SeniKitaEduScreen({super.key});

  @override
  State<SeniKitaEduScreen> createState() => _SeniKitaEduScreenState();
}

class _SeniKitaEduScreenState extends State<SeniKitaEduScreen> {
  Future<void>? _launched;
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  final Uri toLaunch = Uri(scheme: 'https', host: 'www.senikita.my.id', path: '/');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.tertiary,
              ],
            ),
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.tertiary.withAlpha(120),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        title: Text(
          'Widya',
          style: AppFont.crimsonTextSubtitle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.language, 
              color: Colors.white,
            ),
            onPressed: () => setState(() {
              _launched = _launchInBrowser(toLaunch);
            }),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(30)),
                image: const DecorationImage(
                  image: AssetImage('assets/common/hero-texture2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tentang Widya',
                      style: AppFont.ralewayHeaderMedium.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Platform pembelajaran seni dan budaya Indonesia',
                      style: AppFont.ralewaySubtitle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Text(
                    'SeniKita didirikan pada tahun 2024 dengan tujuan untuk memberdayakan seniman lokal di Indonesia. Berawal dari komunitas kecil seniman yang ingin memperluas jangkauan karya mereka, SeniKita tumbuh menjadi marketplace seni yang menghubungkan seniman dengan pembeli dari seluruh penjuru negeri. Hingga saat ini, SeniKita terus berkomitmen untuk mendukung perkembangan seni dan budaya melalui teknologi dan inovasi.',
                    style: AppFont.ralewaySubtitle.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.8,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20),

                  _buildCard(
                    title: 'Visi',
                    description:
                        'Menjadi platform seni terkemuka di Indonesia yang memberikan akses luas kepada seniman lokal untuk berkembang dan menjangkau pasar global.',
                  ),
                  const SizedBox(height: 16),

                  _buildCard(
                    title: 'Misi',
                    description:
                        'Membangun ekosistem seni yang inklusif, mendukung seniman lokal dengan sarana inovatif, dan menciptakan akses mudah bagi pembeli untuk mendapatkan karya seni berkualitas tinggi.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required String description}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(44),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.tertiary],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppFont.ralewayHeaderMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.greyCustom,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: AppFont.ralewaySubtitle.copyWith(
                color: AppColors.greyCustom,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
