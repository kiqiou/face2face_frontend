import 'package:face2face/bloc/auth/authentication_bloc.dart';
import 'package:face2face/components/widgets/my_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/auth/authentication_state.dart';
import '../../../../components/const/app_colors.dart';
import '../../../../models/booking.dart';
import '../../../../services/booking/booking.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      bookings = await BookingRepository().getUserBookings();
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

  Future<void> _refresh() async {
    await loadBookings();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: MyColors.background,
      child: SafeArea(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
  builder: (context, state) {
    final username = context.read<AuthenticationBloc>().state.user?.username ?? 'Гость';
    return CustomScrollView(
          slivers: [
            // Pull-to-refresh
            CupertinoSliverRefreshControl(
              onRefresh: _refresh,
            ),

            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Личный кабинет',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: MyColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: MyColors.card,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: MyColors.textPrimary,
                          child: Icon(Icons.person, size: 60, color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: MyColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Мои записи',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: MyColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: MyColors.card.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: MyColors.textPrimary.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(
                            CupertinoIcons.info_circle_fill,
                            color: MyColors.textPrimary,
                            size: 22,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Отменить запись можно не позднее чем за 12 часов.\n'
                                  'Позже — необходимо связаться с косметологом по телефону или в чате.',
                              style: TextStyle(
                                fontSize: 14,
                                color: MyColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                ],
              ),
            ),

            // Список бронирований
            loading
                ? SliverFillRemaining(
                child: Center(child: CupertinoActivityIndicator()))
                : bookings.isEmpty
                ? SliverFillRemaining(
              child: Center(
                child: Text(
                  'Нет бронирований',
                  style: TextStyle(
                      fontSize: 16,
                    color: MyColors.textPrimary,
                  ),
                ),
              ),
            )
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final booking = bookings[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: MyColors.card,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Название процедуры + цена
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  booking.procedure.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.textPrimary,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: MyColors.textPrimary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${booking.procedure.price} BYN',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Косметолог
                          Text(
                            'Косметолог: ${booking.cosmetologist}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: MyColors.textSecondary,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Дата и время
                          Row(
                            children: [
                              const Icon(
                                CupertinoIcons.calendar,
                                size: 18,
                                color: MyColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                booking.date,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: MyColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                CupertinoIcons.clock,
                                size: 18,
                                color: MyColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                booking.time,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: MyColors.textSecondary,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),
                          Align(
                            alignment: Alignment.centerRight,
                            child: MyButton(onChange: () async {
                              final bookingRepository = BookingRepository();
                              try {
                                bookingRepository.cancelBooking(booking.id);
                                _refresh();
                              } catch (e) {
                                print(e);
                              }
                            }, buttonName: 'Отменить запись')
                          ),
                        ],
                      ),
                    ),
                  );
                    },
                childCount: bookings.length,
              ),
            ),
          ],
        );
  },
),
      ),
    );
  }
}
