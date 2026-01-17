import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../components/const/app_colors.dart';
import '../../../models/booking.dart';
import '../../../services/booking/booking.dart';

class CosmetologistBookingsScreen extends StatefulWidget {
  const CosmetologistBookingsScreen({super.key});

  @override
  State<CosmetologistBookingsScreen> createState() => _CosmetologistBookingsScreenState();
}

class _CosmetologistBookingsScreenState extends State<CosmetologistBookingsScreen> {
  bool loading = true;
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    setState(() => loading = true);
    try {
      bookings = await BookingRepository().getCosmetologistBookings(); // метод для косметолога
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

  Future<void> _refresh() async => loadBookings();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: MyColors.background,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Текст в верхней части экрана
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Записи и брони',  // Ваш заголовок
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.label,
                  ),
                ),
              ),
            ),

            CupertinoSliverRefreshControl(onRefresh: _refresh),
            loading
                ? const SliverFillRemaining(child: Center(child: CupertinoActivityIndicator()))
                : bookings.isEmpty
                ? const SliverFillRemaining(
                child: Center(child: Text('Нет записей', style: TextStyle(color: CupertinoColors.systemGrey))))
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final b = bookings[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Процедура: ${b.procedure.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Косметолог: ${b.cosmetologist}'),
                        Text('Дата: ${b.date}'),
                        Text('Время: ${b.time}'),
                      ],
                    ),
                  );
                },
                childCount: bookings.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
