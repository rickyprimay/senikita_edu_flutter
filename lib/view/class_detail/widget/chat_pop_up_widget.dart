import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/viewModel/in_class_view_model.dart';
import 'package:widya/res/widgets/logger.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

final TextEditingController _chatController = TextEditingController();

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

Widget showChatPopUp(
  BuildContext context,
  String courseName,
  String courseDescription,
  String lessonName,
  String lessonDescription,
  String lessonContent,
) {
  final inClassViewModel = InClassViewModel();

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
          return _ChatBody(
            viewModel: inClassViewModel,
            courseName: courseName,
            courseDescription: courseDescription,
            lessonName: lessonName,
            lessonDescription: lessonDescription,
            lessonContent: lessonContent,
          );
        },
      );
    },
  );

  return Container();
}

class _ChatBody extends StatefulWidget {
  final InClassViewModel viewModel;
  final String courseName;
  final String courseDescription;
  final String lessonName;
  final String lessonDescription;
  final String lessonContent;
  const _ChatBody({
    required this.viewModel,
    required this.courseName,
    required this.courseDescription,
    required this.lessonName,
    required this.lessonDescription,
    required this.lessonContent,
  });

  @override
  State<_ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<_ChatBody> {
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Halo, aku WiChat, asisten virtualmu. Apa yang bisa aku bantu hari ini?',
      isUser: false,
    ),
  ];

  bool _isSending = false;
  final Gemini _gemini = Gemini.instance;
  String? _userPhotoUrl; 

  @override
  void initState() {
    super.initState();
    _loadUserPhoto();
  }

  Future<void> _loadUserPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userPhotoUrl = prefs.getString('user_photo');
    });
  }

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final text = _chatController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(text: text, isUser: true));
        _messages.add(ChatMessage(text: 'Loading...', isUser: false));
        _chatController.clear();
        _isSending = true;
      });

      final String userMessageWithPrompt = getSystemPrompt(text);

      try {
        final response = await _gemini.text(userMessageWithPrompt);
        if (response?.output != null) {
          setState(() {
            _messages.removeLast();
            _messages.add(ChatMessage(text: response!.output!, isUser: false));
          });
        } else {
          setState(() {
            _messages.removeLast();
            _messages.add(ChatMessage(text: 'Maaf, ada masalah dalam memproses pesan.', isUser: false));
          });
          AppLogger.logError('Gemini response output is null');
        }
      } catch (e) {
        setState(() {
          _messages.removeLast();
          _messages.add(ChatMessage(text: 'Terjadi kesalahan: $e', isUser: false));
        });
        AppLogger.logError('Error sending message to Gemini: $e');
      } finally {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  String getSystemPrompt(String userQuestion) {
    List<ChatMessage> recentMessages = _messages.length > 6
        ? _messages.sublist(_messages.length - 6)
        : _messages;

    String chatHistory = "";
    for (var msg in recentMessages) {
      final speaker = msg.isUser ? "Pengguna" : "WiChat";
      chatHistory += "$speaker: ${msg.text}\n";
    }

    return "Peran kamu adalah WiChat, asisten AI di platform pembelajaran kesenian Widya (bagian dari SeniKita, marketplace produk dan jasa kesenian daerah Indonesia). "
           "Tugas kamu adalah mendampingi pengguna dalam belajar seni, seperti musik, tari, kriya, dan masih banyak lagi.\n\n"
           "Berikut adalah konteks kelas yang sedang diikuti pengguna: "
           "- Nama Kelas: '${widget.courseName}' "
           "- Deskripsi Kelas: '${widget.courseDescription}' "
           "- Materi Saat Ini: '${widget.lessonName}' "
           "- Deskripsi Materi: '${widget.lessonDescription}' "
           "- Isi Materi: '${widget.lessonContent}'\n\n"
           "Berikut adalah riwayat percakapan sejauh ini:\n"
           "$chatHistory\n"
           "Pertanyaan terbaru dari pengguna: '$userQuestion'\n\n"
           "Kamu harus menjawab pertanyaan tersebut dengan cara yang ramah, sabar, mendukung, dan menyenangkan. "
           "Berikan jawaban yang jelas, ringkas, dan mudah dipahami.";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
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
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message.isUser;
      
                final bubbleColor = isUser
                    ? AppColors.primary.withOpacity(0.8)
                    : message.text == 'Loading...'
                        ? Colors.grey.shade400
                        : Colors.grey.shade300;
                final textColor = isUser ? Colors.white : Colors.black;
      
                final avatar = isUser
                    ? (_userPhotoUrl != null && _userPhotoUrl!.isNotEmpty
                        ? NetworkImage(_userPhotoUrl!)
                        : const AssetImage('assets/common/default_user.png'))
                    : const AssetImage('assets/common/chatbot.png');
      
                return Row(
                  mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isUser) ...[
                      CircleAvatar(
                        backgroundImage: avatar as ImageProvider,
                        radius: 16,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: bubbleColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: message.text == 'Loading...'
                            ? const LoadingDots()
                            : Text(
                                message.text,
                                style: AppFont.ralewaySubtitle.copyWith(
                                  color: textColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                      ),
                    ),
                    if (isUser) ...[
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundImage: avatar as ImageProvider,
                        radius: 16,
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: _isSending ? Colors.grey : AppColors.primary),
                  onPressed: _isSending ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingDots extends StatefulWidget {
  const LoadingDots({super.key});

  @override
  _LoadingDotsState createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots> {
  late final Timer _timer;
  int _dotCount = 1;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _dotCount = (_dotCount % 3) + 1; 
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String dots = '.' * _dotCount;
    return Text(
      'Loading$dots',
      style: AppFont.ralewaySubtitle.copyWith(
        color: Colors.black,
        fontSize: 14,
      ),
    );
  }
}