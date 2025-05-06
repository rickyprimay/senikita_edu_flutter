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
      'link': 'https://www.youtube.com/embed/yNJNb71MITI'
    },
    {
      'title': 'Interpretasi Lagu Klasik: Asturias',
      'type': 'Video',
      'duration': '15:45',
      'link': 'https://youtu.be/HA91bSyDMcE?si=SEShzBTSwU8iIVQT'
    },
    {
      'title': 'Etude Giuliani Op.48 No.5',
      'type': 'Text',
      'content': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
      'duration': '',
    },
    {
      'title': 'Latihan Harmonisasi Skala',
      'type': 'Video',
      'duration': '9:20',
      'link': 'https://www.youtube.com/embed/yNJNb71MITI'
    },
    {
      'title': 'Latihan Teknik Pizzicato',
      'type': 'Video',
      'duration': '8:15',
      'link': 'https://youtu.be/HA91bSyDMcE?si=SEShzBTSwU8iIVQT'
    },
  ];

  int? _selectedIndex;
  final List<int> _selectedLectureIndices = [];

  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();

    _selectedIndex = 0;
    final firstLecture = lectures[0];

    if (firstLecture['type'] == 'Video') {
      final videoId = YoutubePlayer.convertUrlToId(firstLecture['link']);
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId ?? '',
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    } else {
      _youtubeController = YoutubePlayerController(
        initialVideoId: '',
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    }
  }

  void _updateVideoUrl(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);

    setState(() {
      _youtubeController.load(videoId ?? '');  
    });
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  void _openChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Chat dengan WiChat',
                    style: AppFont.crimsonTextHeader.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: AssetImage('assets/common/chatbot.png'),
                        ),
                        title: Text(
                          'WiChat', 
                          style: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          )
                        ),
                        subtitle: Text(
                          'Halo, aku WiChat, asisten virtualmu. Apa yang bisa aku bantu hari ini?',
                          style: AppFont.nunitoSubtitle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: MediaQuery.of(context).viewInsets.add(
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Ketik pesan...',
                            hintStyle: AppFont.ralewaySubtitle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: AppColors.primary),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
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
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _selectedIndex != null &&
                    lectures[_selectedIndex!]['type'] == 'Video'
                ? YoutubePlayer(
                    controller: _youtubeController,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: AppColors.primary,
                  )
                : _selectedIndex != null &&
                        lectures[_selectedIndex!]['type'] == 'Text'
                    ? Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              lectures[_selectedIndex!]['content'],
                              style: AppFont.ralewaySubtitle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      )
                    : Container(),
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
            Expanded(
              child: ListView.builder(
                itemCount: lectures.length,
                itemBuilder: (context, index) {
                  final lecture = lectures[index];
                  final isSelected = _selectedIndex == index;
                  final isSelectedLecture = _selectedLectureIndices.contains(index); 

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
                        if (lecture['type'] == 'Video') {
                          _updateVideoUrl(lecture['link']);
                        }
                      },
                      splashColor: AppColors.primary.withAlpha(44),
                      highlightColor: AppColors.primary.withAlpha(22),
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(
                            isSelectedLecture ? Icons.check_circle_outline : Icons.circle_outlined,
                            color: AppColors.primary,
                          ),
                          onPressed: () {
                            setState(() {
                              if (isSelectedLecture) {
                                _selectedLectureIndices.remove(index); 
                              } else {
                                _selectedLectureIndices.add(index); 
                              }
                            });
                          },
                        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _openChat,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.chat, color: Colors.white, size: 25),
      ),
    );
  }
}
