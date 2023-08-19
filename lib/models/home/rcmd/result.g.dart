// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecVideoItemAppModelAdapter extends TypeAdapter<RecVideoItemAppModel> {
  @override
  final int typeId = 0;

  @override
  RecVideoItemAppModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecVideoItemAppModel(
      id: fields[0] as int?,
      aid: fields[1] as int?,
      bvid: fields[2] as String?,
      cid: fields[3] as int?,
      pic: fields[4] as String?,
      stat: fields[5] as RcmdStat?,
      duration: fields[6] as String?,
      title: fields[7] as String?,
      isFollowed: fields[8] as int?,
      owner: fields[9] as RcmdOwner?,
      rcmdReason: fields[10] as RcmdReason?,
      goto: fields[11] as String?,
      param: fields[12] as int?,
      uri: fields[13] as String?,
      talkBack: fields[14] as String?,
      bangumiView: fields[15] as String?,
      bangumiFollow: fields[16] as String?,
      bangumiBadge: fields[17] as String?,
      cardType: fields[18] as String?,
      adInfo: (fields[19] as Map?)?.cast<dynamic, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, RecVideoItemAppModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.aid)
      ..writeByte(2)
      ..write(obj.bvid)
      ..writeByte(3)
      ..write(obj.cid)
      ..writeByte(4)
      ..write(obj.pic)
      ..writeByte(5)
      ..write(obj.stat)
      ..writeByte(6)
      ..write(obj.duration)
      ..writeByte(7)
      ..write(obj.title)
      ..writeByte(8)
      ..write(obj.isFollowed)
      ..writeByte(9)
      ..write(obj.owner)
      ..writeByte(10)
      ..write(obj.rcmdReason)
      ..writeByte(11)
      ..write(obj.goto)
      ..writeByte(12)
      ..write(obj.param)
      ..writeByte(13)
      ..write(obj.uri)
      ..writeByte(14)
      ..write(obj.talkBack)
      ..writeByte(15)
      ..write(obj.bangumiView)
      ..writeByte(16)
      ..write(obj.bangumiFollow)
      ..writeByte(17)
      ..write(obj.bangumiBadge)
      ..writeByte(18)
      ..write(obj.cardType)
      ..writeByte(19)
      ..write(obj.adInfo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecVideoItemAppModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RcmdStatAdapter extends TypeAdapter<RcmdStat> {
  @override
  final int typeId = 1;

  @override
  RcmdStat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RcmdStat(
      view: fields[0] as String?,
      like: fields[1] as String?,
      danmu: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RcmdStat obj) {
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
      other is RcmdStatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RcmdOwnerAdapter extends TypeAdapter<RcmdOwner> {
  @override
  final int typeId = 2;

  @override
  RcmdOwner read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RcmdOwner(
      name: fields[0] as String?,
      mid: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, RcmdOwner obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.mid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RcmdOwnerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RcmdReasonAdapter extends TypeAdapter<RcmdReason> {
  @override
  final int typeId = 8;

  @override
  RcmdReason read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RcmdReason(
      content: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RcmdReason obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
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
