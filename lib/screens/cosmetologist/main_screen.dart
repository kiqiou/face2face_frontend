import 'package:face2face/screens/cosmetologist/views/appointment_screen.dart';
import 'package:face2face/screens/cosmetologist/views/booking_screen.dart';
import 'package:flutter/cupertino.dart';

class CosmetologistMainScreen extends StatefulWidget {
  const CosmetologistMainScreen({super.key});

  @override
  State<CosmetologistMainScreen> createState() => _CosmetologistMainScreenState();
}

class _CosmetologistMainScreenState extends State<CosmetologistMainScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(fontFamily: 'Manrope', color: CupertinoColors.black, fontSize: 20),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_2),
              label: 'Записи',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.calendar),
              label: 'Добавить запись',
            ),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(builder: (_) => const CosmetologistBookingsScreen());
            case 1:
              return CupertinoTabView(builder: (_) => const CosmetologistAddAppointmentScreen());
            default:
              return Container();
          }
        },
      ),
    );
  }
}
