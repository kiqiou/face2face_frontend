import 'package:face2face/screens/cosmetologist/views/appointment_screen.dart';
import 'package:face2face/screens/cosmetologist/views/booking_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../components/const/app_colors.dart';

class CosmetologistMainScreen extends StatefulWidget {
  const CosmetologistMainScreen({super.key});

  @override
  State<CosmetologistMainScreen> createState() => _CosmetologistMainScreenState();
}

class _CosmetologistMainScreenState extends State<CosmetologistMainScreen> {
  @override
  Widget build(BuildContext context) {

    late final List<Widget> pages =  [
      CosmetologistBookingsScreen(),
      CosmetologistAddAppointmentScreen(),
    ];

    return  DefaultTextStyle(
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
              icon: Icon(CupertinoIcons.calendar, size: 26),
              label: 'Календарь',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.plus, size: 26),
              label: 'Добавить',
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
