// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_rec_video_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecVideoItemModelAdapter extends TypeAdapter<RecVideoItemModel> {
  @override
  final int typeId = 0;

  @override
  RecVideoItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecVideoItemModel(
      id: fields[0] as int?,
      bvid: fields[1] as String?,
      cid: fields[2] as int?,
      goto: fields[3] as String?,
      uri: fields[4] as String?,
      pic: fields[5] as String?,
      title: fields[6] as String?,
      duration: fields[7] as String?,
      pubdate: fields[8] as int?,
      owner: fields[9] as Owner?,
      stat: fields[10] as Stat?,
      isFollowed: fields[11] as int?,
      rcmdReason: fields[12] as RcmdReason?,
    );
  }

  @override
  void write(BinaryWriter writer, RecVideoItemModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bvid)
      ..writeByte(2)
      ..write(obj.cid)
      ..writeByte(3)
      ..write(obj.goto)
      ..writeByte(4)
      ..write(obj.uri)
      ..writeByte(5)
      ..write(obj.pic)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(7)
      ..write(obj.duration)
      ..writeByte(8)
      ..write(obj.pubdate)
      ..writeByte(9)
      ..write(obj.owner)
      ..writeByte(10)
      ..write(obj.stat)
      ..writeByte(11)
      ..write(obj.isFollowed)
      ..writeByte(12)
      ..write(obj.rcmdReason);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecVideoItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StatAdapter extends TypeAdapter<Stat> {
  @override
  final int typeId = 1;

  @override
  Stat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Stat(
      view: fields[0] as int?,
      like: fields[1] as int?,
      danmu: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Stat obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.view)
      ..writeByte(1)
      ..write(obj.like)
      ..writeByte(2)
      ..write(obj.danmu);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RcmdReasonAdapter extends TypeAdapter<RcmdReason> {
  @override
  final int typeId = 2;

  @override
  RcmdReason read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RcmdReason(
      reasonType: fields[0] as int?,
      content: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RcmdReason obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.reasonType)
      ..writeByte(1)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RcmdReasonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
