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
import 'choose_cosmetologist_screen.dart';
import 'cosmetologist_info_screen.dart';
import '../components/map.dart';
import '../components/promo_banner.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  final userRepository = UserRepository(authStorage: AuthStorage());
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
      backgroundColor: MyColors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Face2Face',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Pacifico',
                  color: MyColors.textPrimary,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 20),
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
                height: 290,
                decoration: BoxDecoration(
                  color: MyColors.card,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            'Специалистки • ${cosmetologists.length}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: MyColors.textPrimary,
                            ),
                          ),
                        ),
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
                                        builder: (_) => CosmetologistInfoScreen(
                                          cosmetologist: cosmetologist,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(
                                        color: MyColors.textSecondary,
                                      ),
                                      color: MyColors.card,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              60,
                                            ),
                                            child: Image.network(
                                              cosmetologist.avatar ?? '',
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  Icon(
                                                    CupertinoIcons
                                                        .person_circle,
                                                    size: 60,
                                                  ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            cosmetologist.username,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: MyColors.textPrimary,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            cosmetologist.specialization,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: MyColors.textSecondary,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (_) =>
                                                      CosmetologistInfoScreen(
                                                        cosmetologist:
                                                            cosmetologist,
                                                      ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 35,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    MyColors.accent,
                                                    MyColors.accentLight,
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: MyColors.accent
                                                        .withOpacity(0.25),
                                                    blurRadius: 12,
                                                    offset: Offset(0, 6),
                                                  ),
                                                ],
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
                                          ),
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
              SizedBox(height: 20),
              ProcedureList(
                procedures: procedures,
                onTap: (index) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => ChooseCosmetologistScreen(
                        cosmetologists: cosmetologists,
                        selectedProcedure: procedures[index],
                        procedures: procedures,
                        selectedIndex: index,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 50),
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
