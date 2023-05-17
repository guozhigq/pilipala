// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStatAdapter extends TypeAdapter<UserStat> {
  @override
  final int typeId = 1;

  @override
  UserStat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStat(
      following: fields[0] as int?,
      follower: fields[1] as int?,
      dynamicCount: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserStat obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.following)
      ..writeByte(1)
      ..write(obj.follower)
      ..writeByte(2)
      ..write(obj.dynamicCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
