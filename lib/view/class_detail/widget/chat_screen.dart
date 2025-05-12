import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/logger.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatScreen extends StatefulWidget {
  final String courseName;
  final String courseDescription;
  final String lessonName;
  final String lessonDescription;
  final String lessonContent;
  
  const ChatScreen({
    Key? key,
    required this.courseName,
    required this.courseDescription,
    required this.lessonName,
    required this.lessonDescription,
    required this.lessonContent,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _chatController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  bool _isSending = false;
  final Gemini _gemini = Gemini.instance;
  String? _userPhotoUrl; 

  @override
  void initState() {
    super.initState();
    _loadUserPhoto();
    
    // Add initial welcome message
    _messages.add(ChatMessage(
      text: 'Halo, aku Widya AI, asisten virtualmu. Apa yang bisa aku bantu hari ini?',
      isUser: false,
    ));
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

      // Scroll to bottom after adding new messages
      _scrollToBottom();

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
        // Scroll to bottom after updating messages
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String getSystemPrompt(String userQuestion) {
    List<ChatMessage> recentMessages = _messages.length > 6
        ? _messages.sublist(_messages.length - 6)
        : _messages;

    String chatHistory = "";
    for (var msg in recentMessages) {
      final speaker = msg.isUser ? "Pengguna" : "Widya AI";
      chatHistory += "$speaker: ${msg.text}\n";
    }

    return "Peran kamu adalah Widya AI, asisten AI di platform pembelajaran kesenian Widya (bagian dari SeniKita, marketplace produk dan jasa kesenian daerah Indonesia). "
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
        title: Text(
          'Chat dengan Widya AI',
          style: AppFont.crimsonTextHeader.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message.isUser;
      
                final bubbleColor = isUser
                    ? AppColors.primary.withOpacity(0.8)
                    : message.text == 'Loading...'
                        ? Colors.grey.shade400
                        : Colors.grey.shade200;
                final textColor = isUser ? Colors.white : Colors.black;
      
                final avatar = isUser
                    ? (_userPhotoUrl != null && _userPhotoUrl!.isNotEmpty
                        ? NetworkImage(_userPhotoUrl!)
                        : const AssetImage('assets/common/default_user.png'))
                    : const AssetImage('assets/common/chatbot.png');
      
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
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
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: bubbleColor,
                            borderRadius: BorderRadius.circular(20),
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
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      hintStyle: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _isSending ? null : _sendMessage,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isSending ? Colors.grey.shade300 : AppColors.primary,
                    ),
                    child: Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
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
  const LoadingDots({Key? key}) : super(key: key);

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