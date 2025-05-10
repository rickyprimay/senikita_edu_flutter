import 'package:flutter/material.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';

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
        style: AppFont.crimsonTextSubtitle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: subtitle != null ? Text(
        subtitle!, 
        style: AppFont.ralewaySubtitle.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
      ) : null,
      trailing: trailing != null
          ? GestureDetector(
              onTap: () {
                if (onTap != null) {
                  onTap!();
                } else {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext dialogContext) {
                      return SimpleDialog(
                        contentPadding: const EdgeInsets.all(30),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        children: [
                          Column(
                            children: [
                              Text(
                                'Peringatan', 
                                style: AppFont.crimsonTextSubtitle.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary, 
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Alamat Email ini berdasarkan dari akun Google yang kamu gunakan untuk mendaftar. Jika ada kesalahan, maka tidak dapat diubah.',
                                style: AppFont.ralewaySubtitle.copyWith(
                                  fontSize: 14,
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w500
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Saya Mengerti',
                                  style: AppFont.ralewaySubtitle.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
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
