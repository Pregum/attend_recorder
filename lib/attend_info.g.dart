// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attend_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendInfoAdapter extends TypeAdapter<AttendInfo> {
  @override
  final int typeId = 1;

  @override
  AttendInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendInfo(
      id: fields[0] as int?,
      createdAt: fields[1] as dynamic,
      startAt: fields[2] as dynamic,
      endAt: fields[3] as DateTime?,
      isPunchClock: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AttendInfo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.startAt)
      ..writeByte(3)
      ..write(obj.endAt)
      ..writeByte(4)
      ..write(obj.isPunchClock);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
