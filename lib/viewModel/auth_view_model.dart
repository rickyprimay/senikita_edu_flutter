import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:senikita_edu/repository/auth_repository.dart';
import 'package:senikita_edu/res/widgets/logger.dart';
import 'package:senikita_edu/res/widgets/shared_preferences.dart';
import 'package:senikita_edu/utils/routes/routes_names.dart';
import 'package:senikita_edu/viewModel/user_view_model.dart';
import 'package:senikita_edu/utils/utils.dart';

class AuthViewModel with ChangeNotifier {
  final _auths = AuthRepository();
  final UserViewModel userViewModel = UserViewModel();

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        "82646193951-uumjlviabndq5hu8rc9r9tq1auo6fdkt.apps.googleusercontent.com",
  );

  bool _loginLoading = false;
  bool isAuthenticated = false;

  bool get loading => _loginLoading;

  void setLoginLoading(bool value) {
    _loginLoading = value;
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
      Utils.flushBarErrorMessage(
        'Error during Google sign-in. Please try again.',
        context,
      );
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
        Utils.flushBarErrorMessage(
          'Failed to authenticate with the server. Please try again.',
          context,
        );
      }
    } catch (e) {
      Utils.flushBarErrorMessage(
        'Verification failed. Please try again.',
        context,
      );
    } finally {
      setLoginLoading(false);
      notifyListeners();
    }
  }

  Future<void> saveToken(String token, BuildContext context) async {
    await SharedPrefs.setString('auth_token', token);

    await userViewModel.fetchUserDetail(context);

    Utils.toastMessage('Successfully logged in!');
    Navigator.pushNamed(context, RouteNames.discover);
  }

  Future<void> logout(BuildContext context) async {
    try {
      await SharedPrefs.remove('auth_token');

      await _googleSignIn.signOut();

      isAuthenticated = false;

      Utils.toastMessage('Successfully logged out!');

      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        RouteNames.login,
        (route) => false,
      );
    } catch (e) {
      Utils.flushBarErrorMessage(
        'Error during logout. Please try again.: $e',
        context,
      );
      AppLogger.logError("Error during logout: $e");
    }
  }
}
