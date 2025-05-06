import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';

class ClassDetailScreen extends StatefulWidget {
  const ClassDetailScreen({super.key});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  final List<Map<String, dynamic>> lectures = [
    {
      'title': 'Teknik Fingerpicking Lanjutan',
      'type': 'Video',
      'duration': '12:30',
    },
    {
      'title': 'Interpretasi Lagu Klasik: Asturias',
      'type': 'Video',
      'duration': '15:45',
    },
    {
      'title': 'Etude Giuliani Op.48 No.5',
      'type': 'Dokumen',
      'duration': '',
    },
    {
      'title': 'Latihan Harmonisasi Skala',
      'type': 'Video',
      'duration': '9:20',
    },
    {
      'title': 'Quiz: Teori Musik Klasik',
      'type': 'Kuis',
      'duration': '',
    },
  ];

  int? _selectedIndex;

  // Tambah controller YouTube
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    // Ambil videoId dari URL YouTube
    const videoUrl = 'https://youtu.be/agW8jvfTwf4?si=RmO6kOnOYwaYmf4U';
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);

    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId ?? '', // fallback kosong kalau gagal
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === YOUTUBE VIDEO ===
            YoutubePlayer(
              controller: _youtubeController,
              showVideoProgressIndicator: true,
              progressIndicatorColor: AppColors.primary,
            ),

            // === TEKS JUDUL DAN DESKRIPSI ===
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gitar Klasik Lanjutan',
                    style: AppFont.crimsonTextHeader.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kursus tingkat lanjut untuk pemain gitar klasik. Fokus pada teknik fingerpicking tingkat tinggi dan interpretasi musik klasik.',
                    style: AppFont.ralewayHeader.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // === TAB BAR ===
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    child: Text(
                      'Materi',
                      style: AppFont.crimsonTextHeader.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Selengkapnya',
                      style: AppFont.crimsonTextHeader.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey, height: 1),

            // === LIST MATERI ===
            Expanded(
              child: ListView.builder(
                itemCount: lectures.length,
                itemBuilder: (context, index) {
                  final lecture = lectures[index];
                  final isSelected = _selectedIndex == index;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    color: isSelected
                        ? AppColors.primary.withAlpha(55)
                        : Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      onLongPress: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Materi: ${lecture['title']} ditekan lama'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      splashColor: AppColors.primary.withAlpha(44),
                      highlightColor: AppColors.primary.withAlpha(22),
                      child: ListTile(
                        leading: const Icon(Icons.check_circle, color: AppColors.primary),
                        title: Text(
                          lecture['title'],
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          '${lecture['type']}${lecture['duration'] != '' ? ' - ${lecture['duration']}' : ''}',
                          style: AppFont.nunitoSubtitle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
