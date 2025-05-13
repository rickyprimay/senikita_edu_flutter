import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:widya/repository/auth_repository.dart';
import 'package:widya/res/widgets/shared_preferences.dart';
import 'package:widya/utils/routes/routes_names.dart';
import 'package:widya/viewModel/category_view_model.dart';
import 'package:widya/viewModel/user_view_model.dart';
import 'package:widya/utils/utils.dart';

class AuthViewModel with ChangeNotifier {
  final _auths = AuthRepository();
  final UserViewModel userViewModel = UserViewModel();
  final CategoryViewModel categoryViewModel = CategoryViewModel();

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: "82646193951-uumjlviabndq5hu8rc9r9tq1auo6fdkt.apps.googleusercontent.com",
  );

  bool _loginLoading = false;
  bool _logoutLoading = false;
  bool isAuthenticated = false;
  
  bool get logoutLoading => _logoutLoading;  
  bool get loading => _loginLoading;

  void setLoginLoading(bool value) {
    _loginLoading = value;
    notifyListeners();
  }

  void setLogoutLoading(bool value) {
    _logoutLoading = value;
    notifyListeners();
  }

  Future<void> authenticateWithGoogle(BuildContext context) async {
    setLoginLoading(true);
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        setLoginLoading(false);
        notifyListeners();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final idToken = googleAuth.idToken;

      if (idToken == null) {
        setLoginLoading(false);
        notifyListeners();
        return;
      }

      await verifyGoogleToken(idToken, context);
    } catch (e) {
      Utils.showToastification('Gagal melakukan Login dengan Google', 'Gagal Login dengan Google, silahkan coba kembali', false, context);
    } finally {
      setLoginLoading(false);
      notifyListeners();
    }
  }

  Future<void> verifyGoogleToken(String idToken, BuildContext context) async {
    try {
      final data = {"id_token": idToken};

      final response = await _auths.apiLogin(data);

      if (response['data'] != null && response['data']['token'] != null) {
        final token = response['data']['token'];
        isAuthenticated = true;
        await saveToken(token, context);
      } else {
        Utils.showToastification('Gagal terkoneksi ke Server', 'Gagal terkoneksi ke Server, silahkan coba kembali', false, context);
      }
    } catch (e) {
      Utils.showToastification('Verfikasi gagal', 'Verifikasi gagal, silahkan coba kembali', false, context);
    } finally {
      setLoginLoading(false);
      notifyListeners();
    }
  }

  Future<void> saveToken(String token, BuildContext context) async {
    await SharedPrefs.setString('auth_token', token);

    await userViewModel.fetchUserDetail(context);
    await categoryViewModel.fetchCategory();

    Utils.showToastification('Login Berhasil', 'Anda berhasil login', true, context);
    Navigator.pushNamed(context, RouteNames.discover);
  }

  Future<void> logout(BuildContext context) async {
    setLogoutLoading(true);

    try {
      await SharedPrefs.remove('auth_token');
      await SharedPrefs.remove('user_name');
      await SharedPrefs.remove('user_email');
      await SharedPrefs.remove('user_photo');
      await _googleSignIn.signOut();

      isAuthenticated = false;

      Utils.showToastification('Log Out berhasil', 'Anda berhasil Logout', true, context);

      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        RouteNames.login,
        (route) => false,
      );
    } catch (e) {
      Utils.showToastification('Gagal Log Out', 'Gagal Logout, silahkan coba kembali', false, context);
    } finally {
      setLogoutLoading(false);
    }
  }
}
