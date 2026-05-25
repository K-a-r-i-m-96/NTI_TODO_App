import 'package:untitled/core/cache/cache_helper.dart';

class TaskModel {
  int? id;
  String? title;
  String? description;
  String? imagePath;
  String? createdAt;
  String? group;
  String? date;
  String? isDone;

  TaskModel({
    this.id,
    this.title,
    this.description,
    this.imagePath,
    this.createdAt,
    this.group,
    this.date,
    this.isDone,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] is String) {
      id = int.tryParse(json['id']);
    } else {
      id = json['id'];
    }
    
    final rawTitle = json['title'] as String?;
    if (rawTitle != null && rawTitle.contains('|')) {
      final parts = rawTitle.split('|');
      title = parts[0];
      for (int i = 1; i < parts.length; i++) {
        final part = parts[i];
        if (part.startsWith('date:')) {
          date = part.substring(5);
        } else if (part.startsWith('group:')) {
          group = part.substring(6);
        } else if (part.startsWith('isDone:')) {
          isDone = part.substring(7);
        }
      }
    } else {
      title = rawTitle;
    }

    final rawDescription = json['description'] as String?;
    if (rawDescription != null && rawDescription.contains('|')) {
      final parts = rawDescription.split('|');
      description = parts[0];
      for (int i = 1; i < parts.length; i++) {
        final part = parts[i];
        if (part.startsWith('date:')) {
          date ??= part.substring(5);
        } else if (part.startsWith('group:')) {
          group ??= part.substring(6);
        } else if (part.startsWith('isDone:')) {
          isDone ??= part.substring(7);
        }
      }
    } else {
      description = rawDescription;
    }

    imagePath = json['image_path'];
    createdAt = json['created_at'];
    
    if (group == null || group!.isEmpty) {
      group = json['group'] ?? 'Home';
    }
    
    if (date == null || date!.isEmpty) {
      date = json['date'];
    }
    if (date == null || date!.isEmpty) {
      if (id != null) {
        date = CacheHelper.getValue('task_date_$id') as String?;
      }
      if (date == null || date!.isEmpty) {
        final cleanTitle = (title ?? '').trim().replaceAll(RegExp(r'\s+'), '_');
        final cleanDesc = (description ?? '').trim().replaceAll(RegExp(r'\s+'), '_');
        date = CacheHelper.getValue('task_date_${cleanTitle}_$cleanDesc') as String?;
        if (date != null && id != null) {
          CacheHelper.setValue(key: 'task_date_$id', value: date);
        }
      }
      if (date == null || date!.isEmpty) {
        date = getFormattedCreatedAt();
      }
    }

    if (date != null && date!.isNotEmpty) {
      date = _normalizeDateFormat(date!);
      final gmt = formatToGmt(date!);
      if (gmt != null) {
        createdAt = gmt;
      }
    }
    
    if (isDone == null || isDone!.isEmpty) {
      isDone = json['isDone']?.toString() ?? 'false';
    }
  }

  String _normalizeDateFormat(String dateStr) {
    try {
      if (dateStr.contains(',') && dateStr.contains(RegExp(r'\s{2,}'))) {
        return dateStr;
      }
      
      final parsedDate = DateTime.tryParse(dateStr);
      if (parsedDate != null) {
        final months = [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'
        ];
        final dayStr = parsedDate.day.toString();
        final monthStr = months[parsedDate.month - 1];
        final yearStr = parsedDate.year.toString();
        
        final hour24 = parsedDate.hour;
        final period = hour24 >= 12 ? 'PM' : 'AM';
        final h = hour24 > 12 ? hour24 - 12 : (hour24 == 0 ? 12 : hour24);
        final hStr = h.toString().padLeft(2, '0');
        final mm = parsedDate.minute.toString().padLeft(2, '0');
        
        return "$dayStr $monthStr, $yearStr    $hStr:$mm $period";
      }

      final parts = dateStr.trim().split(RegExp(r'\s+'));
      if (parts.length >= 3 && parts[0].contains('/')) {
        final dateParts = parts[0].split('/');
        final day = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final year = int.parse(dateParts[2]);

        final timeParts = parts[1].split(':');
        var hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);
        final period = parts[2].toUpperCase();

        if (period == 'PM' && hour < 12) hour += 12;
        if (period == 'AM' && hour == 12) hour = 0;

        final months = [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'
        ];
        
        final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        final hStr = h.toString().padLeft(2, '0');
        final mmStr = minute.toString().padLeft(2, '0');
        
        return "$day ${months[month - 1]}, $year    $hStr:$mmStr $period";
      }
    } catch (_) {}
    return dateStr;
  }

  String? getFormattedCreatedAt() {
    if (createdAt == null || createdAt!.isEmpty) return null;
    try {
      final parsedDate = DateTime.tryParse(createdAt!);
      if (parsedDate != null) {
        final localDate = parsedDate.isUtc ? parsedDate.toLocal() : parsedDate;
        return _formatToLocalString(localDate);
      }
    } catch (_) {}
    
    try {
      final parts = createdAt!.trim().split(RegExp(r'\s+'));
      if (parts.length >= 5) {
        final day = int.parse(parts[1]);
        final monthStr = parts[2];
        final year = int.parse(parts[3]);
        final timeStr = parts[4];
        
        final monthsMap = {
          'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
          'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
        };
        final month = monthsMap[monthStr] ?? 1;
        
        final timeParts = timeStr.split(':');
        if (timeParts.length >= 2) {
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          final second = timeParts.length > 2 ? int.parse(timeParts[2]) : 0;
          
          final utcDateTime = DateTime.utc(year, month, day, hour, minute, second);
          final localDateTime = utcDateTime.toLocal();
          
          return _formatToLocalString(localDateTime);
        }
      }
    } catch (_) {}
    return null;
  }

  String _formatToLocalString(DateTime dt) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final dayStr = dt.day.toString();
    final monthStr = months[dt.month - 1];
    final yearStr = dt.year.toString();
    
    final hour24 = dt.hour;
    final period = hour24 >= 12 ? 'PM' : 'AM';
    final h = hour24 > 12 ? hour24 - 12 : (hour24 == 0 ? 12 : hour24);
    final hStr = h.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    
    return "$dayStr $monthStr, $yearStr    $hStr:$mm $period";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['image_path'] = imagePath;
    data['created_at'] = createdAt;
    data['group'] = group;
    data['date'] = date;
    data['isDone'] = isDone;
    return data;
  }

  static DateTime? parseCustomDate(String dateStr) {
    try {
      final parts = dateStr.trim().split(RegExp(r'\s+'));
      if (parts.length >= 3) {
        if (parts[0].contains('/')) {
          final dateParts = parts[0].split('/');
          final day = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);
          final year = int.parse(dateParts[2]);

          final timeParts = parts[1].split(':');
          var hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          final period = parts[2].toUpperCase();

          if (period == 'PM' && hour < 12) hour += 12;
          if (period == 'AM' && hour == 12) hour = 0;

          return DateTime(year, month, day, hour, minute);
        } else {
          final day = int.parse(parts[0]);
          final monthStr = parts[1].replaceAll(',', '');
          final year = int.parse(parts[2]);

          final monthsList = [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December',
            'Jan', 'Feb', 'Mar', 'Apr', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
          ];
          
          int month = 1;
          for (int i = 0; i < monthsList.length; i++) {
            if (monthsList[i].toLowerCase() == monthStr.toLowerCase()) {
              month = (i % 12) + 1;
              break;
            }
          }

          final timeParts = parts[3].split(':');
          var hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          final period = parts[4].toUpperCase();

          if (period == 'PM' && hour < 12) hour += 12;
          if (period == 'AM' && hour == 12) hour = 0;

          return DateTime(year, month, day, hour, minute);
        }
      }
    } catch (_) {}
    return null;
  }

  static String? formatToGmt(String dateStr) {
    final dateTime = parseCustomDate(dateStr);
    if (dateTime == null) return null;
    final utcDateTime = dateTime.toUtc();
    
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    final weekday = weekdays[utcDateTime.weekday - 1];
    final day = utcDateTime.day.toString().padLeft(2, '0');
    final month = months[utcDateTime.month - 1];
    final year = utcDateTime.year;
    final hour = utcDateTime.hour.toString().padLeft(2, '0');
    final minute = utcDateTime.minute.toString().padLeft(2, '0');
    final second = utcDateTime.second.toString().padLeft(2, '0');
    
    return "$weekday, $day $month $year $hour:$minute:$second GMT";
  }
}
