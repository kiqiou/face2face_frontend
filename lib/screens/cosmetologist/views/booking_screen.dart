import 'package:face2face/models/appointment.dart';
import 'package:face2face/services/appointment/appointment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../bloc/auth/authentication_bloc.dart';
import '../../../components/const/app_colors.dart';
import '../../../models/booking.dart';
import 'package:intl/intl.dart';
import '../../../services/booking/booking.dart';

class CosmetologistBookingsScreen extends StatefulWidget {
  const CosmetologistBookingsScreen({super.key});

  @override
  State<CosmetologistBookingsScreen> createState() =>
      _CosmetologistBookingsScreenState();
}

class _CosmetologistBookingsScreenState
    extends State<CosmetologistBookingsScreen> {
  DateTime _selectedMonth = DateTime.now();
  bool loading = true;
  List<Booking> bookings = [];
  List<Appointment> appointments = [];

  @override
  void initState() {
    super.initState();
    loadBookings();
    loadAppointments();
  }

  Future<void> loadBookings() async {
    setState(() => loading = true);
    try {
      bookings = await BookingRepository().getCosmetologistBookings();
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: const Text('Ошибка'),
            content: Text('Не удалось загрузить бронирования: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('Ок'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> loadAppointments() async {
    setState(() => loading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final cosmetologistId = prefs.getString('cosmetologist_id') ?? '';
      appointments = await AppointmentRepository()
          .getAppointmentsByCosmetologist(int.parse(cosmetologistId));
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: const Text('Ошибка'),
            content: Text('Не удалось загрузить аппоинтменты: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('Ок'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _refresh() async {
    await Future.wait([loadBookings(), loadAppointments()]);
  }

  String formatDate(String rawDate) {
    final date = DateTime.parse(rawDate);
    return DateFormat('dd.MM.yyyy').format(date);
  }

  void _pickMonth() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 260,
        color: CupertinoColors.systemBackground,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                child: const Text('Готово'),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.monthYear,
                initialDateTime: _selectedMonth,
                onDateTimeChanged: (date) {
                  setState(() => _selectedMonth = date);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double timeColumnWidth = 70;
    const double cellWidth = 40;
    const double cellHeight = 40;

    final hours = List.generate(
      16,
      (i) => '${(i + 8).toString().padLeft(2, '0')}:00',
    );

    final filteredAppointments = appointments.where((a) {
      final date = DateTime.parse(a.date);
      return date.year == _selectedMonth.year &&
          date.month == _selectedMonth.month;
    }).toList();

    final filteredBookings = bookings.where((b) {
      final date = DateTime.parse(b.date);
      return date.year == _selectedMonth.year &&
          date.month == _selectedMonth.month;
    }).toList();

    final daysInMonth = DateUtils.getDaysInMonth(
      _selectedMonth.year,
      _selectedMonth.month,
    );

    final dates = List.generate(daysInMonth, (i) {
      final date = DateTime(_selectedMonth.year, _selectedMonth.month, i + 1);
      return DateFormat('yyyy-MM-dd').format(date);
    });

    Booking? getBooking(String date, String time) {
      try {
        return filteredBookings.firstWhere(
          (b) => b.date == date && b.time == time,
        );
      } catch (_) {
        return null;
      }
    }

    return CupertinoPageScaffold(
      backgroundColor: MyColors.background,
      child: SafeArea(
        child: loading
            ? const Center(child: CupertinoActivityIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickMonth,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat(
                                'LLLL yyyy',
                                'ru',
                              ).format(_selectedMonth),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: MyColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              CupertinoIcons.chevron_down,
                              size: 18,
                              color: MyColors.textPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        _refresh();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  SizedBox(height: cellHeight),
                                  ...hours.map(
                                    (hour) => Container(
                                      width: timeColumnWidth,
                                      height: cellHeight,
                                      alignment: Alignment.topCenter,
                                      padding: const EdgeInsets.only(top: 10),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: MyColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        hour,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: MyColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ...dates.map(
                                (date) => Column(
                                  children: [
                                    Container(
                                      width: cellWidth,
                                      height: cellHeight,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: MyColors.textSecondary,
                                          ),
                                          right: BorderSide(
                                            color: MyColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        formatDate(date),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: MyColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    ...hours.map((time) {
                                      String normalizeTime(String time) {
                                        return time.substring(0, 5);
                                      }

                                      final booking = getBooking(date, time);

                                      final appointment = filteredAppointments
                                          .firstWhereOrNull((appt) {
                                            return appt.date == date &&
                                                normalizeTime(appt.time) ==
                                                    time;
                                          });

                                      return Container(
                                        width: cellWidth,
                                        height: cellHeight,
                                        decoration: const BoxDecoration(
                                          color: MyColors.card,
                                          border: Border(
                                            right: BorderSide(
                                              color: MyColors.textSecondary,
                                              width: 0.5,
                                            ),
                                            bottom: BorderSide(
                                              color: MyColors.textSecondary,
                                              width: 0.5,
                                            ),
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            if (appointment != null)
                                              Positioned.fill(
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      _showAppointmentDetails(
                                                        appointment,
                                                      ),
                                                  onLongPress: () => _showAppointmentActions(appointment),
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color: CupertinoColors
                                                          .systemBlue
                                                          .withOpacity(0.15),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      border: Border.all(
                                                        color: CupertinoColors
                                                            .systemBlue
                                                            .withOpacity(0.4),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: const Center(
                                                      child: Icon(
                                                        CupertinoIcons
                                                            .plus_circle_fill,
                                                        size: 16,
                                                        color: CupertinoColors
                                                            .systemBlue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            if (booking != null)
                                              Positioned.fill(
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      _showBookingDetails(
                                                        booking,
                                                      ),
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(6),
                                                    decoration:
                                                        booking.status == true
                                                        ? BoxDecoration(
                                                            color:
                                                                CupertinoColors
                                                                    .systemGreen
                                                                    .withOpacity(
                                                                      0.15,
                                                                    ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                            border: Border.all(
                                                              color: CupertinoColors
                                                                  .systemGreen
                                                                  .withOpacity(
                                                                    0.4,
                                                                  ),
                                                              width: 1,
                                                            ),
                                                          )
                                                        : BoxDecoration(
                                                            color:
                                                                CupertinoColors
                                                                    .systemRed
                                                                    .withOpacity(
                                                                      0.15,
                                                                    ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                            border: Border.all(
                                                              color: CupertinoColors
                                                                  .systemRed
                                                                  .withOpacity(
                                                                    0.4,
                                                                  ),
                                                              width: 1,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
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

  void _showAppointmentDetails(Appointment appointment) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text(
          'Детали записи',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        message: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow('Дата', formatDate(appointment.date)),
            _infoRow('Время', appointment.time),
          ],
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: const Text(
              'Закрыть',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MyColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAppointmentActions(Appointment appointment) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Действие'),
        message: Text(
          'Запись на ${appointment.date} в ${appointment.time}',
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              final appointmentRepository = AppointmentRepository();
              try{
                appointmentRepository.deleteAppointment(appointment.id);
                _refresh();
                Navigator.pop(context);
              } catch(e) {
                print(e);
              }
            },
            isDestructiveAction: true,
            child: const Text('Удалить окно', style: TextStyle(color: CupertinoColors.systemRed),),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child:const Text(
            'Закрыть',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }


  void _showBookingDetails(Booking booking) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text(
          'Детали записи',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        message: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow('Клиент', booking.user.username),
            _infoRow('Процедура', booking.procedure.name),
            _infoRow('Дата', formatDate(booking.date)),
            _infoRow('Время', booking.time),
            _infoRow('Косметолог', booking.cosmetologist),
          ],
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: const Text(
              'Закрыть',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MyColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          SizedBox(width: 20),
          Text(value, style: TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
