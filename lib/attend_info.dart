import 'package:hive_flutter/hive_flutter.dart';

part 'attend_info.g.dart';

@HiveType(typeId: 1)
class AttendInfo {
  @HiveField(0)
  int? id;

  @HiveField(1)
  late final DateTime createdAt;
  @HiveField(2)
  late final DateTime startAt;
  @HiveField(3)
  late DateTime endAt;
  @HiveField(4)
  bool isPunchClock;

  AttendInfo({
    this.id,
    createdAt,
    startAt,
    endAt,
    this.isPunchClock = false,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
    this.startAt = startAt ?? DateTime.now();
    this.endAt = endAt ?? DateTime.now();
  }
}
