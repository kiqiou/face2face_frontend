import 'package:face2face/bloc/auth/helper/helper.dart';
import 'package:face2face/models/cosmetologist.dart';
import 'package:face2face/models/procedure.dart';
import 'package:face2face/screens/client/menu/components/procedures.dart';
import 'package:face2face/services/user/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../../components/const/app_colors.dart';
import '../../../../services/procedure/procedure.dart';
import 'cosmetologist_info_screen.dart';
import '../components/map.dart';
import '../components/promo_banner.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  final userRepository = UserRepository(authStorage: AuthStorage(),);
  final procedureRepository = ProcedureRepository();
  List<Cosmetologist> cosmetologists = [];
  List<Procedure> procedures = [];

  @override
  void initState() {
    super.initState();
    loadCosmetologists();
    loadProcedures();
  }

  Future<void> loadCosmetologists() async {
    try {
      final list = await userRepository.getCosmetologists();
      setState(() {
        cosmetologists = list ?? [];
      });
    } catch (e) {
      print("Ошибка при загрузке косметологов: $e");
    }
  }

  Future<void> loadProcedures() async {
    try {
      final list = await procedureRepository.getProcedures();
      setState(() {
        procedures = list ?? [];
      });
    } catch (e) {
      print("Ошибка при загрузке процедур: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Color(0xFFF2F2F2),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Face2Face',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w200,
                    fontFamily: 'Pacifico',
                    color: CupertinoColors.black,
                  ),
                ),
                SizedBox(height: 20,),
                PromoBanner(
                  banners: [
                    'assets/banners/banner-1.jpg',
                    'assets/banners/banner-2.jpg',
                    'assets/banners/banner-3.jpg',
                    'assets/banners/banner-4.jpg',
                    'assets/banners/banner-5.jpg',
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: 360,
                  height: 250,
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('На карте'),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => const ObjectMapScreen(
                                  lat: 53.905623,
                                  lng: 27.527476,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFFF8DC),
                                  MyColors.accent,
                                  Color(0xFFFFF8DC),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Container(
                              height: 170,
                              decoration: BoxDecoration(
                                color: MyColors.background,
                                borderRadius: BorderRadius.circular(
                                  22,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: Image.asset(
                                  'assets/images/maps.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  width: 360,
                  height: 290,
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Специалистки ${cosmetologists.length}'),
                          SizedBox(height: 20),
                          SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: cosmetologists.length,
                              itemBuilder: (context, index) {
                                final cosmetologist = cosmetologists[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (_) => CosmetologistInfoScreen(cosmetologist: cosmetologist,),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(22),
                                        border: Border.all(color: CupertinoColors.systemGrey),
                                        color: CupertinoColors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(60),
                                              child: Image.network(
                                                cosmetologist.avatar ?? '',
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) => Icon(CupertinoIcons.person_circle, size: 60),
                                              )
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              cosmetologist.username,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              cosmetologist.specialization,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (_) => CosmetologistInfoScreen(cosmetologist: cosmetologist,),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 35,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(25),
                                                  color: MyColors.accent,
                                                  gradient: const LinearGradient(
                                                    colors: [
                                                      MyColors.accent,
                                                      Color(0xFFEDDAB5),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Записаться',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                ProcedureList(procedures: procedures, onTap: (index) {
                  // showModalBottomSheet(
                  //   context: context,
                  //   isScrollControlled: true,
                  //   backgroundColor: Colors.white,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  //   ),
                  //   builder: (context) => AppointmentModal(
                  //     procedure: procedure,
                  //     repository: AppointmentRepository(authStorage: AuthStorage()),
                  //   ),
                  // );
                },),
                SizedBox(height: 50,),
              ],
            ),
          ),
      ),
    );
  }
}

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final carousalCurrentIndex = 0.obs;

  void updatePageIndicator(index) {
    carousalCurrentIndex.value = index;
  }
}
