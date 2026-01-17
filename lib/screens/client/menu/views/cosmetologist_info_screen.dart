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

class CosmetologistInfoScreen extends StatefulWidget {
  final Cosmetologist cosmetologist;

  const CosmetologistInfoScreen({required this.cosmetologist, super.key});

  @override
  State<CosmetologistInfoScreen> createState() => _CosmetologistInfoScreenState();
}

class _CosmetologistInfoScreenState extends State<CosmetologistInfoScreen> {
  List<Procedure> procedures = [];

  @override
  void initState() {
    super.initState();
    loadProcedures();
  }

  Future<void> loadProcedures() async {
    try {
      final list = await ProcedureRepository()
          .getProceduresByCosmetologist(widget.cosmetologist.id);
      setState(() {
        procedures = list ?? [];
      });
    } catch (e) {
      print("Ошибка при загрузке процедур: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final cosmetologist = widget.cosmetologist;

    return CupertinoPageScaffold(
      backgroundColor: MyColors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Container(
                width: 360,
                decoration: BoxDecoration(
                  color: MyColors.card,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Column(children: [
                  SizedBox(height: 20,),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        cosmetologist.avatar ?? '',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(CupertinoIcons.person_circle, size: 120),
                      ),
                    ),
                  ),
                  const SizedBox(height: 17),
                  Center(
                    child: Text(
                      cosmetologist.username,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: MyColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      cosmetologist.specialization,
                      style: TextStyle(
                        fontSize: 18,
                        color: MyColors.textSecondary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                    child: Text(
                      cosmetologist.bio,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: MyColors.textPrimary,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],),
              ),
              const SizedBox(height: 24),
              Text(
                'Процедуры:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: MyColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              ProcedureList(procedures: procedures, onTap: (index) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (context) => AppointmentModal(
                    procedure: procedures[index],
                    appointmentRepository: AppointmentRepository(), cosmetologist: cosmetologist,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
