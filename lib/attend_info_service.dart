import 'package:hive_flutter/hive_flutter.dart';
import 'package:collection/collection.dart';

import 'attend_info.dart';

class AttendInfoService {
  final _boxName = 'attend_infos';

  static const fixedId = 1;
  static final _singleton = AttendInfoService();
  static AttendInfoService get ins => _singleton;

  Future<AttendInfo?> getById(int id) async {
    final box = await _openBoxIfClosed();
    var attendInfo = box.get(id);
    attendInfo?.id = id;
    return attendInfo;
  }

  Future<List<AttendInfo>> getAll() async {
    final box = await _openBoxIfClosed();
    final all = box.values.toList();
    return all;
  }

  Future<AttendInfo?> getByStartAt(DateTime startAt) async {
    final box = await _openBoxIfClosed();
    var attendInfo =
        box.values.firstWhereOrNull((val) => val.startAt.day == startAt.day);
    return attendInfo;
  }

  Future<AttendInfo> add(AttendInfo value) async {
    final box = await _openBoxIfClosed();
    final id = await box.add(value);
    value.id = id;
    return value;
  }

  Future<AttendInfo> upsert(AttendInfo value) async {
    final box = await _openBoxIfClosed();
    await box.put(value.id, value);
    return value;
  }

  Future<AttendInfo> delete(AttendInfo value) async {
    final box = await _openBoxIfClosed();
    await box.delete(value.id);
    return value;
  }

  Future<Box<AttendInfo>> _openBoxIfClosed() async {
    final isOpen = Hive.isBoxOpen(_boxName);
    final box = isOpen
        ? Hive.box<AttendInfo>(_boxName)
        : await Hive.openBox<AttendInfo>(_boxName);
    return box;
  }
}
