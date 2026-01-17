import '../../../../models/procedure.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../components/const/app_colors.dart';

class ProcedureList extends StatelessWidget {
  final List<Procedure> procedures;
  final void Function(int index) onTap;

  const ProcedureList({super.key, required this.procedures, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: procedures.length,
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        final procedure = procedures[index];

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: MyColors.card,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: MyColors.accentLight,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.spa, color: MyColors.accent),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      procedure.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: MyColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${procedure.price} BYN • ${_formatDuration(procedure.duration)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: MyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => onTap(index),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
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
                  child: Text(
                    'Записаться',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(String duration) {
    final parts = duration.split(':');
    if (parts.length != 2) return duration;
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;

    if (hours > 0) {
      return '${hours}ч ${minutes}м';
    } else {
      return '${minutes} мин';
    }
  }

}
