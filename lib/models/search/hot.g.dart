// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hot.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HotSearchModelAdapter extends TypeAdapter<HotSearchModel> {
  @override
  final int typeId = 6;

  @override
  HotSearchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HotSearchModel(
      list: (fields[0] as List?)?.cast<HotSearchItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, HotSearchModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.list);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HotSearchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HotSearchItemAdapter extends TypeAdapter<HotSearchItem> {
  @override
  final int typeId = 7;

  @override
  HotSearchItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HotSearchItem(
      keyword: fields[0] as String?,
      showName: fields[1] as String?,
      wordType: fields[2] as int?,
      icon: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HotSearchItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.keyword)
      ..writeByte(1)
      ..write(obj.showName)
      ..writeByte(2)
      ..write(obj.wordType)
      ..writeByte(3)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HotSearchItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
