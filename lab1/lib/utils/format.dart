const _months = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String formatDateTime(DateTime dateTime) {
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '${dateTime.day} ${_months[dateTime.month - 1]}, '
      '${dateTime.hour}:$minute';
}
