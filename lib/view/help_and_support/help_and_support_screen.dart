import 'package:flutter/material.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  final List<Map<String, String>> faqs = [
    {
      'question': 'Bagaimana cara memulai pembelajaran?',
      'answer': 'Silakan pilih kursus yang Anda minati di halaman beranda, lalu klik "Daftar Kelas" untuk memulai pembelajaran.'
    },
    {
      'question': 'Bagaimana sistem pengumpulan submission?',
      'answer': 'Submission dapat dikumpulkan melalui halaman kelas pembelajaran pada bagian tugas. Upload file tugas Anda atau link video youtube dan tunggu penilaian dari mentor.'
    },
    {
      'question': 'Apakah saya bisa mengunduh materi pembelajaran?',
      'answer': 'Tidak, sebagian besar materi pembelajaran di Widya hanya bisa di akses melalui platform Mobile atau Web kami saja.'
    },
    {
      'question': 'Bagaimana cara mendapatkan sertifikat?',
      'answer': 'Sertifikat akan otomatis diberikan melalui email atau anda download dari aplikasi setelah Anda menyelesaikan semua modul dan tugas dengan nilai minimum yang ditentukan.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
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
                color: Colors.white.withAlpha(60),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        title: Text(
          'Bantuan & Dukungan',
          style: AppFont.crimsonTextSubtitle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 140,
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
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.support_agent,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ada yang bisa kami bantu?',
                      style: AppFont.crimsonTextSubtitle.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Temukan jawaban atas pertanyaan Anda di bawah ini',
                      style: AppFont.ralewaySubtitle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Pertanyaan Umum',
                style: AppFont.ralewaySubtitle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        title: Text(
                          faqs[index]['question']!,
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.secondary,
                          ),
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.secondary,
                          size: 24,
                        ),
                        children: [
                          Text(
                            faqs[index]['answer']!,
                            style: AppFont.ralewaySubtitle.copyWith(
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.grey.shade800,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),            
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildContactCard(),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.tertiary,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage('assets/common/hero-texture2.png'),
          fit: BoxFit.cover,
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hubungi Kami',
            style: AppFont.crimsonTextTitle.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 12),
          _buildContactItem(Icons.email, 'officialsenikita@gmail.com'),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.call_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Text(
                '+62 895-3631-85264',
                style: AppFont.nunitoSubtitle.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildContactItem(Icons.access_time, 'Senin - Jumat: 08.00 - 17.00 WIB'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 10),
        Text(
          text,
          style: AppFont.ralewaySubtitle.copyWith(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

}