import 'package:face2face/bloc/auth/helper/helper.dart';
import 'package:face2face/services/booking/booking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:face2face/models/appointment.dart';
import 'package:face2face/models/cosmetologist.dart';

import '../../../../components/const/app_colors.dart';
import '../../../../components/widgets/my_button.dart';
import '../../../../models/procedure.dart';
import '../../../../services/appointment/appointment.dart';
import '../components/warning_message.dart';

class AppointmentModal extends StatefulWidget {
  final Procedure procedure;
  final Cosmetologist cosmetologist;
  final AppointmentRepository appointmentRepository;

  const AppointmentModal({
    required this.procedure,
    required this.cosmetologist,
    required this.appointmentRepository,
    super.key,
  });

  @override
  State<AppointmentModal> createState() => _AppointmentModalState();
}

class _AppointmentModalState extends State<AppointmentModal> {
  int selectedDateIndex = 0;
  List<DateTime> availableDates = [];
  List<Appointment> appointmentsForDate = [];
  bool loading = false;
  Appointment? selectedAppointment;

  @override
  void initState() {
    super.initState();
    loadAvailableDates();
  }

  Future<void> loadAvailableDates() async {
    setState(() {
      loading = true;
    });
    final allAppointments = await widget.appointmentRepository
        .getAppointmentsByCosmetologist(widget.cosmetologist.id);


    final uniqueDates = <DateTime>{};
    for (var appt in allAppointments) {
      if (appt.status == true)
      {
        uniqueDates.add(DateTime.parse(appt.date));
      }
    }

    setState(() {
      availableDates = uniqueDates.toList();
      if (availableDates.isNotEmpty) {
        selectedDateIndex = 0;
        loadAppointmentsForDate(availableDates[selectedDateIndex]);
      }
      loading = false;
    });
  }

  Future<void> loadAppointmentsForDate(DateTime date) async {
    setState(() {
      loading = true;
    });

    final allAppointments = await widget.appointmentRepository
        .getAppointmentsByCosmetologist(widget.cosmetologist.id);

    appointmentsForDate = allAppointments
        .where((a) => DateTime.parse(a.date).isSameDate(date))
        .toList();

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      height: 500,
      decoration: BoxDecoration(
        color: MyColors.card,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Даты:', style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: MyColors.textPrimary,
          ),),
          SizedBox(height: 10),
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: availableDates.length,
              itemBuilder: (context, i) {
                final d = availableDates[i];
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedDateIndex = i);
                    loadAppointmentsForDate(d);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: selectedDateIndex == i
                          ? MyColors.accent
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "${d.day}.${d.month}",
                      style: TextStyle(
                        color: selectedDateIndex == i
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Text('Косметолог:', style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: MyColors.textPrimary,
          )),
          SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.cosmetologist.avatar ?? ''),
                radius: 28,
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.cosmetologist.username,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: MyColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Text('Процедура:', style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: MyColors.textPrimary,
          )),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.access_alarm, size: 18, color: MyColors.textSecondary,),
              SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.procedure.name,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: MyColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Цена: ${widget.procedure.price} BYN',
                    style: TextStyle(fontSize: 14,    color: MyColors.textSecondary,),
                  ),
                  Text(
                    'Продолжительность: ${widget.procedure.duration}',
                    style: TextStyle(fontSize: 14,     color: MyColors.textSecondary,),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Text('Время:', style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: MyColors.textPrimary,
          )),
          SizedBox(height: 10),
          loading
              ? Center(child: CircularProgressIndicator())
              : Wrap(
            spacing: 10,
            children: appointmentsForDate.where((appt) => appt.status).map(
                  (appt) {
                    final isSelected = selectedAppointment?.id == appt.id;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAppointment = appt;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? MyColors.accent : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      appt.time.substring(0, 5),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
          SizedBox(height: 25),
          MyButton(onChange: () async {
            if (selectedAppointment == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Пожалуйста, выберите время')),
              );
              return;
            }
            setState(() => loading = true);
            try {
              final bookingRepository = BookingRepository();
              await bookingRepository.createBooking(selectedAppointment!.id, widget.procedure.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Бронирование успешно создано!')),
              );
              Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка при бронировании: $e')),
              );
            } finally {
              setState(() => loading = false);
              WarningMessage.show(context);
            }
          }, buttonName: "Подтвердить запись"),
        ],
      ),
    );
  }
}

extension DateTimeComparison on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }
}
