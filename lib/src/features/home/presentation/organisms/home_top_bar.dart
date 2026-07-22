import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_spacing.dart';
import 'package:taekwondo_azuay/src/features/home/presentation/atoms/brand_mark.dart';
import 'package:taekwondo_azuay/src/features/profile/presentation/dialogs/login_dialog.dart';
import 'package:taekwondo_azuay/src/features/profile/presentation/pages/profile_page.dart';
import 'package:taekwondo_azuay/src/features/profile/presentation/cubit/auth_cubit.dart';

import '../../../../core/theme/text_style.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 5, left: 5, right: 5),
      child: Row(
        children: [
          const BrandMark(),
          const SizedBox(width: EliteMartialSpacing.base),
          Expanded(
            child: Text(
              'TAEKWONDO AZUAY',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyle.blueTitleMStyle,
            ),
          ),
          const SizedBox(width: EliteMartialSpacing.base),
          kIsWeb
              ? InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => BlocProvider.value(
                        value: context.read<AuthCubit>(),
                        child: const LoginDialog(),
                      ),
                    ).then((user) {
                      if (user != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: context.read<AuthCubit>(),
                              child: const ProfilePage(),
                            ),
                          ),
                        );
                      }
                    });
                  },
                  child: const ProfileAvatar(),
                )
              : const ProfileAvatar(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(150.0);
}
