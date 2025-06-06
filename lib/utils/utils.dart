
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:toastification/toastification.dart';

class Utils {
  static void changeNodeFocus(BuildContext context, {FocusNode? current, FocusNode? next}) {
    current!.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  static toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        message: message,
        duration: const Duration(seconds: 3),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.BOTTOM,
        backgroundColor: Colors.red,
        reverseAnimationCurve: Curves.easeInOut,
        positionOffset: 20,
        icon: const Icon(
          Icons.error,
          size: 28,
          color: Colors.white,
        ),
      )..show(context),
    );
  }

  static snackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)));
  }

  static showToastification(String message, String description, bool isSuccess, BuildContext context) {
    return toastification.show(
      context: context,
      title: Text(
        message,
        style: AppFont.crimsonTextSubtitle.copyWith(
          fontSize: 16,
          color: Colors.white
        ),
      ),
      description: Text(
        description,
        style: AppFont.crimsonTextSubtitle.copyWith(
          fontSize: 14,
          color: Colors.white
        ),
      ),
      autoCloseDuration: const Duration(seconds: 5),
      style: ToastificationStyle.fillColored, 
      primaryColor: AppColors.secondary,
      backgroundColor: isSuccess ? AppColors.customGreen : AppColors.customRed,
      foregroundColor: AppColors.greyCustom,
      showProgressBar: true,
    );
  }

  static double averageRatings(List<int> ratings) {
    double avg = 0;
    for (int i = 0; i < ratings.length; i++) {
      avg += ratings[i];
    }
    avg /= ratings.length;

    return avg;
  }
}