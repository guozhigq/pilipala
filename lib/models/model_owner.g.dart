// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_owner.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OwnerAdapter extends TypeAdapter<Owner> {
  @override
  final int typeId = 3;

  @override
  Owner read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Owner(
      mid: fields[0] as int?,
      name: fields[1] as String?,
      face: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Owner obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.mid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.face);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OwnerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
