import 'dart:ui';

import 'package:face2face/screens/client/menu/components/procedures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../bloc/auth/helper/helper.dart';
import '../../../../components/const/app_colors.dart';
import '../../../../models/cosmetologist.dart';
import '../../../../models/procedure.dart';
import '../../../../services/appointment/appointment.dart';
import '../../../../services/procedure/procedure.dart';
import 'appointment_screen.dart';

class ChooseCosmetologistScreen extends StatefulWidget {
  final List<Cosmetologist> cosmetologists;
  final List<Procedure> procedures;
  final int selectedIndex;
  final Procedure selectedProcedure;

  const ChooseCosmetologistScreen({
    required this.cosmetologists,
    super.key,
    required this.selectedProcedure, required this.procedures, required this.selectedIndex,
  });

  @override
  State<ChooseCosmetologistScreen> createState() =>
      _ChooseCosmetologistScreenState();
}

class _ChooseCosmetologistScreenState extends State<ChooseCosmetologistScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: MyColors.background,
      child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text('Выберите косметолога', style: TextStyle(color: MyColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w600,),),
              SizedBox(height: 24,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: MyColors.card,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.cosmetologists.length,
                        itemBuilder: (context, index) {
                          final cosmetologist = widget.cosmetologists[index];
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              width: 165,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: MyColors.textSecondary),
                                color: MyColors.card,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
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
                                    SizedBox(height: 10,),
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
                                    SizedBox(height: 20,),
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                          ),
                                          builder: (context) => AppointmentModal(
                                            procedure: widget.procedures[widget.selectedIndex],
                                            appointmentRepository: AppointmentRepository(), cosmetologist: cosmetologist,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 35,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
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
                                              color: MyColors.accent.withOpacity(0.25),
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
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
