import 'package:flutter/material.dart';
import 'package:senikita_edu/res/widgets/colors.dart';
import 'package:senikita_edu/res/widgets/fonts.dart';
import 'package:quickalert/quickalert.dart';

class ProfileInfoTile extends StatelessWidget {
  final Widget icon; 
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ProfileInfoTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    Widget coloredIcon = icon;
    if (icon is Icon) {
      final Icon originalIcon = icon as Icon;
      coloredIcon = Icon(
        originalIcon.icon,
        size: originalIcon.size,
        color: AppColors.primary,
      );
    }

    return ListTile(
      leading: coloredIcon,
      title: Text(
        title,
        style: AppFont.crimsonSubtitle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: subtitle != null ? Text(
        subtitle!, 
        style: AppFont.crimsonSubtitle.copyWith(fontSize: 14),
      ) : null,
      trailing: trailing != null
          ? GestureDetector(
              onTap: () {
                if (onTap != null) {
                  onTap!();
                } else {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    title: 'Peringatan',
                    text: 'Alamat Email ini berdasarkan dari akun Google yang kamu gunakan untuk mendaftar. Jika ada kesalahan, maka tidak dapat diubah.',
                  );
                }
              },
              child: SizedBox(
                width: 30, 
                height: 30, 
                child: trailing,
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}
