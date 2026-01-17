import 'package:flutter/cupertino.dart';

import '../../../../components/const/app_colors.dart';

class WarningMessage extends StatelessWidget {
  const WarningMessage({super.key});

  static void show(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text(
          'Политика отмены',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        content: const Text(
          'Запись можно отменить только за 12 часов до процедуры. После этого времени для отмены свяжитесь с косметологом.',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text(
              'OK',
              style: TextStyle(fontSize: 14, color: MyColors.textSecondary),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => show(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CupertinoColors.systemYellow.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CupertinoColors.systemYellow, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.info_circle_fill,
              color: CupertinoColors.systemYellow,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Отмена записи возможна за 12 часов. Подробнее →',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
