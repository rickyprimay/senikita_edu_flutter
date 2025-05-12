import 'package:flutter/widgets.dart';
import 'package:widya/repository/certificate_repository.dart';
import 'package:widya/models/certificate/certificate.dart';
import 'package:widya/res/widgets/shared_preferences.dart';

class CertificateViewModel with ChangeNotifier {
  final CertificateRepository _certificateRepository = CertificateRepository();

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Certificate? _certificate;
  Certificate? get certificate => _certificate;

  Future<void> fetchCertificate() async {
    _loading = true;
    _error = null;
    final sp = await SharedPrefs.instance;
    final String? token = sp.getString("auth_token");
    notifyListeners();

    try {
      final response = await _certificateRepository.fetchCertificate(token: token ?? "");
      if (response != null) {
        _certificate = response;
        _error = null;
      } else {
        _error = "Gagal memuat data sertifikat";
      }
    } catch (e) {
      _error = "Terjadi kesalahan: ${e.toString()}";
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}