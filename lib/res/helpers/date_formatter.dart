import 'package:intl/intl.dart';

String formatDate(String dateString) {
  try {
    final dateTime = DateTime.parse(dateString);
    final formatter = DateFormat('MM/yyyy');
    return formatter.format(dateTime);
  } catch (e) {
    return 'Invalid date';
  }
}