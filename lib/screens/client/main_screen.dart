import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user.dart';
import '../../components/const/app_colors.dart';
import 'menu/views/menu_screen.dart';
import 'profile/views/profile.dart';
import 'package:flutter/material.dart';

final currentUserProvider = StateProvider<MyUser?>((ref) => null);

class UserMainScreen extends ConsumerStatefulWidget {
  const UserMainScreen({super.key});

  @override
  ConsumerState<UserMainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<UserMainScreen> {
  @override
  Widget build(BuildContext context) {

    late final List<Widget> pages =  [
      MenuScreen(),
      ProfileScreen(),
    ];

    return DefaultTextStyle(
      style: const TextStyle(fontFamily: 'Manrope', color: CupertinoColors.black, fontSize: 20),
      child: CupertinoTabScaffold(
        tabBar:CupertinoTabBar(
          height: 50,
          backgroundColor: MyColors.card,
          activeColor: MyColors.accent,
          inactiveColor: MyColors.textSecondary,
          border: Border(
            top: BorderSide(
              color: Colors.black.withOpacity(0.05),
            ),
          ),
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home, size: 26),
              label: 'Запись',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person, size: 26),
              label: 'Профиль',
            ),
          ],
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(
            builder: (context) {
              return pages[index];
            },
          );
        },
      ),
    );
  }
}