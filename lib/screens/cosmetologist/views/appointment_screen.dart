import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../components/const/app_colors.dart';
import '../../../services/appointment/appointment.dart';

class CosmetologistAddAppointmentScreen extends StatefulWidget {
  const CosmetologistAddAppointmentScreen({super.key});

  @override
  State<CosmetologistAddAppointmentScreen> createState() => _CosmetologistAddAppointmentScreenState();
}

class _CosmetologistAddAppointmentScreenState extends State<CosmetologistAddAppointmentScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _pickDate() async {
    final date = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: CupertinoColors.white,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: DateTime.now(),
          minimumDate: DateTime.now().subtract(Duration(seconds: 1)),
          onDateTimeChanged: (val) => setState(() => selectedDate = val),
        ),
      ),
    );

    if (date != null && mounted) {
      setState(() => selectedDate = date);
    }
  }

  Future<void> _pickTime() async {
    final time = await showCupertinoModalPopup<TimeOfDay>(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: CupertinoColors.white,
        child: CupertinoTimerPicker(
          mode: CupertinoTimerPickerMode.hm,
          initialTimerDuration: const Duration(hours: 9),
          onTimerDurationChanged: (duration) {
            setState(() {
              selectedTime = TimeOfDay(hour: duration.inHours, minute: duration.inMinutes % 60);
            });
          },
        ),
      ),
    );

    if (time != null && mounted) {
      setState(() => selectedTime = time);
    }
  }

  Future<void> _createAppointment() async {
    if (selectedDate == null || selectedTime == null) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: const Text('Ошибка'),
            content: const Text('Выберите дату и время'),
            actions: [
              CupertinoDialogAction(
                child: const Text('Ок'),
                onPressed: () {
                  if (mounted) {
                    Navigator.of(context).maybePop();
                  }
                },
              ),
            ],
          ),
        );
      }
      return;
    }

    final dateStr = "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
    final timeStr = "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}:00";

    try {
      await AppointmentRepository().addAppointment(dateStr, timeStr);
      if (mounted) {
        Navigator.of(context).maybePop();
        showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: const Text('Успешно'),
            content: const Text('Аппойнтмент добавлен'),
            actions: [
              CupertinoDialogAction(
                child: const Text('Ок'),
                onPressed: () {
                  if (mounted) {
                    Navigator.of(context).maybePop();
                  }
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: const Text('Ошибка'),
            content: Text('Ошибка: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('Ок'),
                onPressed: () {
                  if (mounted) {
                    Navigator.of(context).maybePop();
                  }
                },
              ),
            ],
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: MyColors.background,
      navigationBar: CupertinoNavigationBar(
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.clear, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Добавить запись',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MyColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(height: 40,),
              Text(
                'Выберите дату:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MyColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              CupertinoButton(
                color: MyColors.accent,
                onPressed: _pickDate,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                child: Text(
                  selectedDate == null ? 'Выбрать дату' : selectedDate!.toLocal().toString().split(' ')[0],
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Выберите время:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MyColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              CupertinoButton(
                color: MyColors.accent,
                onPressed: _pickTime,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                child: Text(
                  selectedTime == null ? 'Выбрать время' : '${selectedTime!.hour}:${selectedTime!.minute}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),

              CupertinoButton.filled(
                onPressed: _createAppointment,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                child: Text(
                  'Добавить запись',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
