import 'package:flutter/material.dart';

enum StateType {
  error,
  empty,
  chatActive,
}

class LessonStateWidget extends StatelessWidget {
  final StateType type;
  final String? customMessage;

  const LessonStateWidget({
    Key? key,
    required this.type,
    this.customMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case StateType.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              customMessage ?? "Error: Gagal Koneksi Ke Server",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      case StateType.empty:
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              customMessage ?? "Belum ada materi yang tersedia di kelas ini silahkan kembali lagi nanti",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      case StateType.chatActive:
        return const Center(
          child: Text(
            'Chat sedang aktif.\nKonten kelas dijeda sementara.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
    }
  }
}