///
//  Generated code. Do not modify.
//  source: dm.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name, no_leading_underscores_for_local_identifiers, depend_on_referenced_packages

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'dm.pbenum.dart';

export 'dm.pbenum.dart';

class Avatar extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Avatar',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'url')
    ..e<AvatarType>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'avatarType',
        $pb.PbFieldType.OE,
        defaultOrMaker: AvatarType.AvatarTypeNone,
        valueOf: AvatarType.valueOf,
        enumValues: AvatarType.values)
    ..hasRequiredFields = false;

  Avatar._() : super();
  factory Avatar({
    $core.String? id,
    $core.String? url,
    AvatarType? avatarType,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (url != null) {
      _result.url = url;
    }
    if (avatarType != null) {
      _result.avatarType = avatarType;
    }
    return _result;
  }
  factory Avatar.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Avatar.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Avatar clone() => Avatar()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Avatar copyWith(void Function(Avatar) updates) =>
      super.copyWith((message) => updates(message as Avatar))
          as Avatar; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Avatar create() => Avatar._();
  Avatar createEmptyInstance() => create();
  static $pb.PbList<Avatar> createRepeated() => $pb.PbList<Avatar>();
  @$core.pragma('dart2js:noInline')
  static Avatar getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Avatar>(create);
  static Avatar? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => clearField(2);

  @$pb.TagNumber(3)
  AvatarType get avatarType => $_getN(2);
  @$pb.TagNumber(3)
  set avatarType(AvatarType v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasAvatarType() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvatarType() => clearField(3);
}

class Bubble extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Bubble',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'text')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'url')
    ..hasRequiredFields = false;

  Bubble._() : super();
  factory Bubble({
    $core.String? text,
    $core.String? url,
  }) {
    final _result = create();
    if (text != null) {
      _result.text = text;
    }
    if (url != null) {
      _result.url = url;
    }
    return _result;
  }
  factory Bubble.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Bubble.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Bubble clone() => Bubble()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Bubble copyWith(void Function(Bubble) updates) =>
      super.copyWith((message) => updates(message as Bubble))
          as Bubble; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Bubble create() => Bubble._();
  Bubble createEmptyInstance() => create();
  static $pb.PbList<Bubble> createRepeated() => $pb.PbList<Bubble>();
  @$core.pragma('dart2js:noInline')
  static Bubble getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Bubble>(create);
  static Bubble? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => clearField(2);
}

class BubbleV2 extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'BubbleV2',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'text')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'url')
    ..e<BubbleType>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bubbleType',
        $pb.PbFieldType.OE,
        defaultOrMaker: BubbleType.BubbleTypeNone,
        valueOf: BubbleType.valueOf,
        enumValues: BubbleType.values)
    ..aOB(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'exposureOnce')
    ..e<ExposureType>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'exposureType',
        $pb.PbFieldType.OE,
        defaultOrMaker: ExposureType.ExposureTypeNone,
        valueOf: ExposureType.valueOf,
        enumValues: ExposureType.values)
    ..hasRequiredFields = false;

  BubbleV2._() : super();
  factory BubbleV2({
    $core.String? text,
    $core.String? url,
    BubbleType? bubbleType,
    $core.bool? exposureOnce,
    ExposureType? exposureType,
  }) {
    final _result = create();
    if (text != null) {
      _result.text = text;
    }
    if (url != null) {
      _result.url = url;
    }
    if (bubbleType != null) {
      _result.bubbleType = bubbleType;
    }
    if (exposureOnce != null) {
      _result.exposureOnce = exposureOnce;
    }
    if (exposureType != null) {
      _result.exposureType = exposureType;
    }
    return _result;
  }
  factory BubbleV2.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BubbleV2.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BubbleV2 clone() => BubbleV2()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BubbleV2 copyWith(void Function(BubbleV2) updates) =>
      super.copyWith((message) => updates(message as BubbleV2))
          as BubbleV2; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BubbleV2 create() => BubbleV2._();
  BubbleV2 createEmptyInstance() => create();
  static $pb.PbList<BubbleV2> createRepeated() => $pb.PbList<BubbleV2>();
  @$core.pragma('dart2js:noInline')
  static BubbleV2 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BubbleV2>(create);
  static BubbleV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => clearField(2);

  @$pb.TagNumber(3)
  BubbleType get bubbleType => $_getN(2);
  @$pb.TagNumber(3)
  set bubbleType(BubbleType v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasBubbleType() => $_has(2);
  @$pb.TagNumber(3)
  void clearBubbleType() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get exposureOnce => $_getBF(3);
  @$pb.TagNumber(4)
  set exposureOnce($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasExposureOnce() => $_has(3);
  @$pb.TagNumber(4)
  void clearExposureOnce() => clearField(4);

  @$pb.TagNumber(5)
  ExposureType get exposureType => $_getN(4);
  @$pb.TagNumber(5)
  set exposureType(ExposureType v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasExposureType() => $_has(4);
  @$pb.TagNumber(5)
  void clearExposureType() => clearField(5);
}

class Button extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Button',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'text')
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'action',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  Button._() : super();
  factory Button({
    $core.String? text,
    $core.int? action,
  }) {
    final _result = create();
    if (text != null) {
      _result.text = text;
    }
    if (action != null) {
      _result.action = action;
    }
    return _result;
  }
  factory Button.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Button.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Button clone() => Button()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Button copyWith(void Function(Button) updates) =>
      super.copyWith((message) => updates(message as Button))
          as Button; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Button create() => Button._();
  Button createEmptyInstance() => create();
  static $pb.PbList<Button> createRepeated() => $pb.PbList<Button>();
  @$core.pragma('dart2js:noInline')
  static Button getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Button>(create);
  static Button? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get action => $_getIZ(1);
  @$pb.TagNumber(2)
  set action($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => clearField(2);
}

class BuzzwordConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'BuzzwordConfig',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pc<BuzzwordShowConfig>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'keywords',
        $pb.PbFieldType.PM,
        subBuilder: BuzzwordShowConfig.create)
    ..hasRequiredFields = false;

  BuzzwordConfig._() : super();
  factory BuzzwordConfig({
    $core.Iterable<BuzzwordShowConfig>? keywords,
  }) {
    final _result = create();
    if (keywords != null) {
      _result.keywords.addAll(keywords);
    }
    return _result;
  }
  factory BuzzwordConfig.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BuzzwordConfig.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BuzzwordConfig clone() => BuzzwordConfig()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BuzzwordConfig copyWith(void Function(BuzzwordConfig) updates) =>
      super.copyWith((message) => updates(message as BuzzwordConfig))
          as BuzzwordConfig; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BuzzwordConfig create() => BuzzwordConfig._();
  BuzzwordConfig createEmptyInstance() => create();
  static $pb.PbList<BuzzwordConfig> createRepeated() =>
      $pb.PbList<BuzzwordConfig>();
  @$core.pragma('dart2js:noInline')
  static BuzzwordConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BuzzwordConfig>(create);
  static BuzzwordConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<BuzzwordShowConfig> get keywords => $_getList(0);
}

class BuzzwordShowConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'BuzzwordShowConfig',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'name')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'schema')
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'source',
        $pb.PbFieldType.O3)
    ..aInt64(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id')
    ..aInt64(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'buzzwordId')
    ..a<$core.int>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'schemaType',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  BuzzwordShowConfig._() : super();
  factory BuzzwordShowConfig({
    $core.String? name,
    $core.String? schema,
    $core.int? source,
    $fixnum.Int64? id,
    $fixnum.Int64? buzzwordId,
    $core.int? schemaType,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (schema != null) {
      _result.schema = schema;
    }
    if (source != null) {
      _result.source = source;
    }
    if (id != null) {
      _result.id = id;
    }
    if (buzzwordId != null) {
      _result.buzzwordId = buzzwordId;
    }
    if (schemaType != null) {
      _result.schemaType = schemaType;
    }
    return _result;
  }
  factory BuzzwordShowConfig.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BuzzwordShowConfig.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BuzzwordShowConfig clone() => BuzzwordShowConfig()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BuzzwordShowConfig copyWith(void Function(BuzzwordShowConfig) updates) =>
      super.copyWith((message) => updates(message as BuzzwordShowConfig))
          as BuzzwordShowConfig; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BuzzwordShowConfig create() => BuzzwordShowConfig._();
  BuzzwordShowConfig createEmptyInstance() => create();
  static $pb.PbList<BuzzwordShowConfig> createRepeated() =>
      $pb.PbList<BuzzwordShowConfig>();
  @$core.pragma('dart2js:noInline')
  static BuzzwordShowConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BuzzwordShowConfig>(create);
  static BuzzwordShowConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get schema => $_getSZ(1);
  @$pb.TagNumber(2)
  set schema($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSchema() => $_has(1);
  @$pb.TagNumber(2)
  void clearSchema() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get source => $_getIZ(2);
  @$pb.TagNumber(3)
  set source($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get id => $_getI64(3);
  @$pb.TagNumber(4)
  set id($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasId() => $_has(3);
  @$pb.TagNumber(4)
  void clearId() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get buzzwordId => $_getI64(4);
  @$pb.TagNumber(5)
  set buzzwordId($fixnum.Int64 v) {
    $_setInt64(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasBuzzwordId() => $_has(4);
  @$pb.TagNumber(5)
  void clearBuzzwordId() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get schemaType => $_getIZ(5);
  @$pb.TagNumber(6)
  set schemaType($core.int v) {
    $_setSignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasSchemaType() => $_has(5);
  @$pb.TagNumber(6)
  void clearSchemaType() => clearField(6);
}

class CheckBox extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'CheckBox',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'text')
    ..e<CheckboxType>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'type',
        $pb.PbFieldType.OE,
        defaultOrMaker: CheckboxType.CheckboxTypeNone,
        valueOf: CheckboxType.valueOf,
        enumValues: CheckboxType.values)
    ..aOB(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'defaultValue')
    ..aOB(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'show')
    ..hasRequiredFields = false;

  CheckBox._() : super();
  factory CheckBox({
    $core.String? text,
    CheckboxType? type,
    $core.bool? defaultValue,
    $core.bool? show,
  }) {
    final _result = create();
    if (text != null) {
      _result.text = text;
    }
    if (type != null) {
      _result.type = type;
    }
    if (defaultValue != null) {
      _result.defaultValue = defaultValue;
    }
    if (show != null) {
      _result.show = show;
    }
    return _result;
  }
  factory CheckBox.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CheckBox.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  CheckBox clone() => CheckBox()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  CheckBox copyWith(void Function(CheckBox) updates) =>
      super.copyWith((message) => updates(message as CheckBox))
          as CheckBox; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CheckBox create() => CheckBox._();
  CheckBox createEmptyInstance() => create();
  static $pb.PbList<CheckBox> createRepeated() => $pb.PbList<CheckBox>();
  @$core.pragma('dart2js:noInline')
  static CheckBox getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CheckBox>(create);
  static CheckBox? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => clearField(1);

  @$pb.TagNumber(2)
  CheckboxType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(CheckboxType v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get defaultValue => $_getBF(2);
  @$pb.TagNumber(3)
  set defaultValue($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasDefaultValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearDefaultValue() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get show => $_getBF(3);
  @$pb.TagNumber(4)
  set show($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasShow() => $_has(3);
  @$pb.TagNumber(4)
  void clearShow() => clearField(4);
}

class CheckBoxV2 extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'CheckBoxV2',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'text')
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'type',
        $pb.PbFieldType.O3)
    ..aOB(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'defaultValue')
    ..hasRequiredFields = false;

  CheckBoxV2._() : super();
  factory CheckBoxV2({
    $core.String? text,
    $core.int? type,
    $core.bool? defaultValue,
  }) {
    final _result = create();
    if (text != null) {
      _result.text = text;
    }
    if (type != null) {
      _result.type = type;
    }
    if (defaultValue != null) {
      _result.defaultValue = defaultValue;
    }
    return _result;
  }
  factory CheckBoxV2.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CheckBoxV2.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  CheckBoxV2 clone() => CheckBoxV2()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  CheckBoxV2 copyWith(void Function(CheckBoxV2) updates) =>
      super.copyWith((message) => updates(message as CheckBoxV2))
          as CheckBoxV2; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CheckBoxV2 create() => CheckBoxV2._();
  CheckBoxV2 createEmptyInstance() => create();
  static $pb.PbList<CheckBoxV2> createRepeated() => $pb.PbList<CheckBoxV2>();
  @$core.pragma('dart2js:noInline')
  static CheckBoxV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckBoxV2>(create);
  static CheckBoxV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get type => $_getIZ(1);
  @$pb.TagNumber(2)
  set type($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get defaultValue => $_getBF(2);
  @$pb.TagNumber(3)
  set defaultValue($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasDefaultValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearDefaultValue() => clearField(3);
}

class ClickButton extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ClickButton',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pPS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'portraitText')
    ..pPS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'landscapeText')
    ..pPS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'portraitTextFocus')
    ..pPS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'landscapeTextFocus')
    ..e<RenderType>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'renderType',
        $pb.PbFieldType.OE,
        defaultOrMaker: RenderType.RenderTypeNone,
        valueOf: RenderType.valueOf,
        enumValues: RenderType.values)
    ..aOB(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'show')
    ..aOM<Bubble>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bubble',
        subBuilder: Bubble.create)
    ..hasRequiredFields = false;

  ClickButton._() : super();
  factory ClickButton({
    $core.Iterable<$core.String>? portraitText,
    $core.Iterable<$core.String>? landscapeText,
    $core.Iterable<$core.String>? portraitTextFocus,
    $core.Iterable<$core.String>? landscapeTextFocus,
    RenderType? renderType,
    $core.bool? show,
    Bubble? bubble,
  }) {
    final _result = create();
    if (portraitText != null) {
      _result.portraitText.addAll(portraitText);
    }
    if (landscapeText != null) {
      _result.landscapeText.addAll(landscapeText);
    }
    if (portraitTextFocus != null) {
      _result.portraitTextFocus.addAll(portraitTextFocus);
    }
    if (landscapeTextFocus != null) {
      _result.landscapeTextFocus.addAll(landscapeTextFocus);
    }
    if (renderType != null) {
      _result.renderType = renderType;
    }
    if (show != null) {
      _result.show = show;
    }
    if (bubble != null) {
      _result.bubble = bubble;
    }
    return _result;
  }
  factory ClickButton.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ClickButton.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ClickButton clone() => ClickButton()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ClickButton copyWith(void Function(ClickButton) updates) =>
      super.copyWith((message) => updates(message as ClickButton))
          as ClickButton; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ClickButton create() => ClickButton._();
  ClickButton createEmptyInstance() => create();
  static $pb.PbList<ClickButton> createRepeated() => $pb.PbList<ClickButton>();
  @$core.pragma('dart2js:noInline')
  static ClickButton getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClickButton>(create);
  static ClickButton? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get portraitText => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$core.String> get landscapeText => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$core.String> get portraitTextFocus => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$core.String> get landscapeTextFocus => $_getList(3);

  @$pb.TagNumber(5)
  RenderType get renderType => $_getN(4);
  @$pb.TagNumber(5)
  set renderType(RenderType v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasRenderType() => $_has(4);
  @$pb.TagNumber(5)
  void clearRenderType() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get show => $_getBF(5);
  @$pb.TagNumber(6)
  set show($core.bool v) {
    $_setBool(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasShow() => $_has(5);
  @$pb.TagNumber(6)
  void clearShow() => clearField(6);

  @$pb.TagNumber(7)
  Bubble get bubble => $_getN(6);
  @$pb.TagNumber(7)
  set bubble(Bubble v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasBubble() => $_has(6);
  @$pb.TagNumber(7)
  void clearBubble() => clearField(7);
  @$pb.TagNumber(7)
  Bubble ensureBubble() => $_ensure(6);
}

class ClickButtonV2 extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ClickButtonV2',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pPS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'portraitText')
    ..pPS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'landscapeText')
    ..pPS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'portraitTextFocus')
    ..pPS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'landscapeTextFocus')
    ..a<$core.int>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'renderType',
        $pb.PbFieldType.O3)
    ..aOB(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'textInputPost')
    ..aOB(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'exposureOnce')
    ..a<$core.int>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'exposureType',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  ClickButtonV2._() : super();
  factory ClickButtonV2({
    $core.Iterable<$core.String>? portraitText,
    $core.Iterable<$core.String>? landscapeText,
    $core.Iterable<$core.String>? portraitTextFocus,
    $core.Iterable<$core.String>? landscapeTextFocus,
    $core.int? renderType,
    $core.bool? textInputPost,
    $core.bool? exposureOnce,
    $core.int? exposureType,
  }) {
    final _result = create();
    if (portraitText != null) {
      _result.portraitText.addAll(portraitText);
    }
    if (landscapeText != null) {
      _result.landscapeText.addAll(landscapeText);
    }
    if (portraitTextFocus != null) {
      _result.portraitTextFocus.addAll(portraitTextFocus);
    }
    if (landscapeTextFocus != null) {
      _result.landscapeTextFocus.addAll(landscapeTextFocus);
    }
    if (renderType != null) {
      _result.renderType = renderType;
    }
    if (textInputPost != null) {
      _result.textInputPost = textInputPost;
    }
    if (exposureOnce != null) {
      _result.exposureOnce = exposureOnce;
    }
    if (exposureType != null) {
      _result.exposureType = exposureType;
    }
    return _result;
  }
  factory ClickButtonV2.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ClickButtonV2.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ClickButtonV2 clone() => ClickButtonV2()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ClickButtonV2 copyWith(void Function(ClickButtonV2) updates) =>
      super.copyWith((message) => updates(message as ClickButtonV2))
          as ClickButtonV2; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ClickButtonV2 create() => ClickButtonV2._();
  ClickButtonV2 createEmptyInstance() => create();
  static $pb.PbList<ClickButtonV2> createRepeated() =>
      $pb.PbList<ClickButtonV2>();
  @$core.pragma('dart2js:noInline')
  static ClickButtonV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClickButtonV2>(create);
  static ClickButtonV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get portraitText => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$core.String> get landscapeText => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$core.String> get portraitTextFocus => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$core.String> get landscapeTextFocus => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get renderType => $_getIZ(4);
  @$pb.TagNumber(5)
  set renderType($core.int v) {
    $_setSignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasRenderType() => $_has(4);
  @$pb.TagNumber(5)
  void clearRenderType() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get textInputPost => $_getBF(5);
  @$pb.TagNumber(6)
  set textInputPost($core.bool v) {
    $_setBool(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasTextInputPost() => $_has(5);
  @$pb.TagNumber(6)
  void clearTextInputPost() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get exposureOnce => $_getBF(6);
  @$pb.TagNumber(7)
  set exposureOnce($core.bool v) {
    $_setBool(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasExposureOnce() => $_has(6);
  @$pb.TagNumber(7)
  void clearExposureOnce() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get exposureType => $_getIZ(7);
  @$pb.TagNumber(8)
  set exposureType($core.int v) {
    $_setSignedInt32(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasExposureType() => $_has(7);
  @$pb.TagNumber(8)
  void clearExposureType() => clearField(8);
}

class CommandDm extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'CommandDm',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id')
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'oid')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'mid')
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'command')
    ..aOS(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'content')
    ..a<$core.int>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'progress',
        $pb.PbFieldType.O3)
    ..aOS(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'ctime')
    ..aOS(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'mtime')
    ..aOS(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'extra')
    ..aOS(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'idStr',
        protoName: 'idStr')
    ..hasRequiredFields = false;

  CommandDm._() : super();
  factory CommandDm({
    $fixnum.Int64? id,
    $fixnum.Int64? oid,
    $core.String? mid,
    $core.String? command,
    $core.String? content,
    $core.int? progress,
    $core.String? ctime,
    $core.String? mtime,
    $core.String? extra,
    $core.String? idStr,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (oid != null) {
      _result.oid = oid;
    }
    if (mid != null) {
      _result.mid = mid;
    }
    if (command != null) {
      _result.command = command;
    }
    if (content != null) {
      _result.content = content;
    }
    if (progress != null) {
      _result.progress = progress;
    }
    if (ctime != null) {
      _result.ctime = ctime;
    }
    if (mtime != null) {
      _result.mtime = mtime;
    }
    if (extra != null) {
      _result.extra = extra;
    }
    if (idStr != null) {
      _result.idStr = idStr;
    }
    return _result;
  }
  factory CommandDm.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CommandDm.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  CommandDm clone() => CommandDm()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  CommandDm copyWith(void Function(CommandDm) updates) =>
      super.copyWith((message) => updates(message as CommandDm))
          as CommandDm; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CommandDm create() => CommandDm._();
  CommandDm createEmptyInstance() => create();
  static $pb.PbList<CommandDm> createRepeated() => $pb.PbList<CommandDm>();
  @$core.pragma('dart2js:noInline')
  static CommandDm getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommandDm>(create);
  static CommandDm? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get oid => $_getI64(1);
  @$pb.TagNumber(2)
  set oid($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get mid => $_getSZ(2);
  @$pb.TagNumber(3)
  set mid($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasMid() => $_has(2);
  @$pb.TagNumber(3)
  void clearMid() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get command => $_getSZ(3);
  @$pb.TagNumber(4)
  set command($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasCommand() => $_has(3);
  @$pb.TagNumber(4)
  void clearCommand() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get content => $_getSZ(4);
  @$pb.TagNumber(5)
  set content($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasContent() => $_has(4);
  @$pb.TagNumber(5)
  void clearContent() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get progress => $_getIZ(5);
  @$pb.TagNumber(6)
  set progress($core.int v) {
    $_setSignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasProgress() => $_has(5);
  @$pb.TagNumber(6)
  void clearProgress() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get ctime => $_getSZ(6);
  @$pb.TagNumber(7)
  set ctime($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasCtime() => $_has(6);
  @$pb.TagNumber(7)
  void clearCtime() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get mtime => $_getSZ(7);
  @$pb.TagNumber(8)
  set mtime($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasMtime() => $_has(7);
  @$pb.TagNumber(8)
  void clearMtime() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get extra => $_getSZ(8);
  @$pb.TagNumber(9)
  set extra($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasExtra() => $_has(8);
  @$pb.TagNumber(9)
  void clearExtra() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get idStr => $_getSZ(9);
  @$pb.TagNumber(10)
  set idStr($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasIdStr() => $_has(9);
  @$pb.TagNumber(10)
  void clearIdStr() => clearField(10);
}

class DanmakuAIFlag extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DanmakuAIFlag',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pc<DanmakuFlag>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'dmFlags',
        $pb.PbFieldType.PM,
        subBuilder: DanmakuFlag.create)
    ..hasRequiredFields = false;

  DanmakuAIFlag._() : super();
  factory DanmakuAIFlag({
    $core.Iterable<DanmakuFlag>? dmFlags,
  }) {
    final _result = create();
    if (dmFlags != null) {
      _result.dmFlags.addAll(dmFlags);
    }
    return _result;
  }
  factory DanmakuAIFlag.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DanmakuAIFlag.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DanmakuAIFlag clone() => DanmakuAIFlag()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DanmakuAIFlag copyWith(void Function(DanmakuAIFlag) updates) =>
      super.copyWith((message) => updates(message as DanmakuAIFlag))
          as DanmakuAIFlag; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DanmakuAIFlag create() => DanmakuAIFlag._();
  DanmakuAIFlag createEmptyInstance() => create();
  static $pb.PbList<DanmakuAIFlag> createRepeated() =>
      $pb.PbList<DanmakuAIFlag>();
  @$core.pragma('dart2js:noInline')
  static DanmakuAIFlag getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmakuAIFlag>(create);
  static DanmakuAIFlag? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<DanmakuFlag> get dmFlags => $_getList(0);
}

class DanmakuElem extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DanmakuElem',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id')
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'progress',
        $pb.PbFieldType.O3)
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'mode',
        $pb.PbFieldType.O3)
    ..a<$core.int>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'fontsize',
        $pb.PbFieldType.O3)
    ..a<$core.int>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'color',
        $pb.PbFieldType.OU3)
    ..aOS(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'midHash',
        protoName: 'midHash')
    ..aOS(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'content')
    ..aInt64(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'ctime')
    ..a<$core.int>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'weight',
        $pb.PbFieldType.O3)
    ..aOS(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'action')
    ..a<$core.int>(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pool',
        $pb.PbFieldType.O3)
    ..aOS(
        12,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'idStr',
        protoName: 'idStr')
    ..a<$core.int>(
        13,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'attr',
        $pb.PbFieldType.O3)
    ..aOS(
        22,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'animation')
    ..hasRequiredFields = false;

  DanmakuElem._() : super();
  factory DanmakuElem({
    $fixnum.Int64? id,
    $core.int? progress,
    $core.int? mode,
    $core.int? fontsize,
    $core.int? color,
    $core.String? midHash,
    $core.String? content,
    $fixnum.Int64? ctime,
    $core.int? weight,
    $core.String? action,
    $core.int? pool,
    $core.String? idStr,
    $core.int? attr,
    $core.String? animation,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (progress != null) {
      _result.progress = progress;
    }
    if (mode != null) {
      _result.mode = mode;
    }
    if (fontsize != null) {
      _result.fontsize = fontsize;
    }
    if (color != null) {
      _result.color = color;
    }
    if (midHash != null) {
      _result.midHash = midHash;
    }
    if (content != null) {
      _result.content = content;
    }
    if (ctime != null) {
      _result.ctime = ctime;
    }
    if (weight != null) {
      _result.weight = weight;
    }
    if (action != null) {
      _result.action = action;
    }
    if (pool != null) {
      _result.pool = pool;
    }
    if (idStr != null) {
      _result.idStr = idStr;
    }
    if (attr != null) {
      _result.attr = attr;
    }
    if (animation != null) {
      _result.animation = animation;
    }
    return _result;
  }
  factory DanmakuElem.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DanmakuElem.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DanmakuElem clone() => DanmakuElem()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DanmakuElem copyWith(void Function(DanmakuElem) updates) =>
      super.copyWith((message) => updates(message as DanmakuElem))
          as DanmakuElem; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DanmakuElem create() => DanmakuElem._();
  DanmakuElem createEmptyInstance() => create();
  static $pb.PbList<DanmakuElem> createRepeated() => $pb.PbList<DanmakuElem>();
  @$core.pragma('dart2js:noInline')
  static DanmakuElem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmakuElem>(create);
  static DanmakuElem? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get progress => $_getIZ(1);
  @$pb.TagNumber(2)
  set progress($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasProgress() => $_has(1);
  @$pb.TagNumber(2)
  void clearProgress() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get mode => $_getIZ(2);
  @$pb.TagNumber(3)
  set mode($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearMode() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get fontsize => $_getIZ(3);
  @$pb.TagNumber(4)
  set fontsize($core.int v) {
    $_setSignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasFontsize() => $_has(3);
  @$pb.TagNumber(4)
  void clearFontsize() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get color => $_getIZ(4);
  @$pb.TagNumber(5)
  set color($core.int v) {
    $_setUnsignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasColor() => $_has(4);
  @$pb.TagNumber(5)
  void clearColor() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get midHash => $_getSZ(5);
  @$pb.TagNumber(6)
  set midHash($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasMidHash() => $_has(5);
  @$pb.TagNumber(6)
  void clearMidHash() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get content => $_getSZ(6);
  @$pb.TagNumber(7)
  set content($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasContent() => $_has(6);
  @$pb.TagNumber(7)
  void clearContent() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get ctime => $_getI64(7);
  @$pb.TagNumber(8)
  set ctime($fixnum.Int64 v) {
    $_setInt64(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasCtime() => $_has(7);
  @$pb.TagNumber(8)
  void clearCtime() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get weight => $_getIZ(8);
  @$pb.TagNumber(9)
  set weight($core.int v) {
    $_setSignedInt32(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasWeight() => $_has(8);
  @$pb.TagNumber(9)
  void clearWeight() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get action => $_getSZ(9);
  @$pb.TagNumber(10)
  set action($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasAction() => $_has(9);
  @$pb.TagNumber(10)
  void clearAction() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get pool => $_getIZ(10);
  @$pb.TagNumber(11)
  set pool($core.int v) {
    $_setSignedInt32(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasPool() => $_has(10);
  @$pb.TagNumber(11)
  void clearPool() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get idStr => $_getSZ(11);
  @$pb.TagNumber(12)
  set idStr($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasIdStr() => $_has(11);
  @$pb.TagNumber(12)
  void clearIdStr() => clearField(12);

  @$pb.TagNumber(13)
  $core.int get attr => $_getIZ(12);
  @$pb.TagNumber(13)
  set attr($core.int v) {
    $_setSignedInt32(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasAttr() => $_has(12);
  @$pb.TagNumber(13)
  void clearAttr() => clearField(13);

  @$pb.TagNumber(22)
  $core.String get animation => $_getSZ(13);
  @$pb.TagNumber(22)
  set animation($core.String v) {
    $_setString(13, v);
  }

  @$pb.TagNumber(22)
  $core.bool hasAnimation() => $_has(13);
  @$pb.TagNumber(22)
  void clearAnimation() => clearField(22);
}

class DanmakuFlag extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DanmakuFlag',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'dmid')
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'flag',
        $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  DanmakuFlag._() : super();
  factory DanmakuFlag({
    $fixnum.Int64? dmid,
    $core.int? flag,
  }) {
    final _result = create();
    if (dmid != null) {
      _result.dmid = dmid;
    }
    if (flag != null) {
      _result.flag = flag;
    }
    return _result;
  }
  factory DanmakuFlag.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DanmakuFlag.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DanmakuFlag clone() => DanmakuFlag()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DanmakuFlag copyWith(void Function(DanmakuFlag) updates) =>
      super.copyWith((message) => updates(message as DanmakuFlag))
          as DanmakuFlag; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DanmakuFlag create() => DanmakuFlag._();
  DanmakuFlag createEmptyInstance() => create();
  static $pb.PbList<DanmakuFlag> createRepeated() => $pb.PbList<DanmakuFlag>();
  @$core.pragma('dart2js:noInline')
  static DanmakuFlag getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmakuFlag>(create);
  static DanmakuFlag? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get dmid => $_getI64(0);
  @$pb.TagNumber(1)
  set dmid($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasDmid() => $_has(0);
  @$pb.TagNumber(1)
  void clearDmid() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get flag => $_getIZ(1);
  @$pb.TagNumber(2)
  set flag($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasFlag() => $_has(1);
  @$pb.TagNumber(2)
  void clearFlag() => clearField(2);
}

class DanmakuFlagConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DanmakuFlagConfig',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'recFlag',
        $pb.PbFieldType.O3)
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'recText')
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'recSwitch',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  DanmakuFlagConfig._() : super();
  factory DanmakuFlagConfig({
    $core.int? recFlag,
    $core.String? recText,
    $core.int? recSwitch,
  }) {
    final _result = create();
    if (recFlag != null) {
      _result.recFlag = recFlag;
    }
    if (recText != null) {
      _result.recText = recText;
    }
    if (recSwitch != null) {
      _result.recSwitch = recSwitch;
    }
    return _result;
  }
  factory DanmakuFlagConfig.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DanmakuFlagConfig.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DanmakuFlagConfig clone() => DanmakuFlagConfig()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DanmakuFlagConfig copyWith(void Function(DanmakuFlagConfig) updates) =>
      super.copyWith((message) => updates(message as DanmakuFlagConfig))
          as DanmakuFlagConfig; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DanmakuFlagConfig create() => DanmakuFlagConfig._();
  DanmakuFlagConfig createEmptyInstance() => create();
  static $pb.PbList<DanmakuFlagConfig> createRepeated() =>
      $pb.PbList<DanmakuFlagConfig>();
  @$core.pragma('dart2js:noInline')
  static DanmakuFlagConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmakuFlagConfig>(create);
  static DanmakuFlagConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get recFlag => $_getIZ(0);
  @$pb.TagNumber(1)
  set recFlag($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasRecFlag() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecFlag() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get recText => $_getSZ(1);
  @$pb.TagNumber(2)
  set recText($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasRecText() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecText() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get recSwitch => $_getIZ(2);
  @$pb.TagNumber(3)
  set recSwitch($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRecSwitch() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecSwitch() => clearField(3);
}

class DanmuDefaultPlayerConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DanmuDefaultPlayerConfig',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuUseDefaultConfig')
    ..aOB(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuAiRecommendedSwitch')
    ..a<$core.int>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuAiRecommendedLevel',
        $pb.PbFieldType.O3)
    ..aOB(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuBlocktop')
    ..aOB(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuBlockscroll')
    ..aOB(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuBlockbottom')
    ..aOB(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuBlockcolorful')
    ..aOB(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuBlockrepeat')
    ..aOB(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuBlockspecial')
    ..a<$core.double>(
        12,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuOpacity',
        $pb.PbFieldType.OF)
    ..a<$core.double>(
        13,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuScalingfactor',
        $pb.PbFieldType.OF)
    ..a<$core.double>(
        14,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuDomain',
        $pb.PbFieldType.OF)
    ..a<$core.int>(
        15,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuSpeed',
        $pb.PbFieldType.O3)
    ..aOB(
        16,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'inlinePlayerDanmakuSwitch')
    ..a<$core.int>(
        17,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuSeniorModeSwitch',
        $pb.PbFieldType.O3)
    ..a<$core.int>(
        18,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuAiRecommendedLevelV2',
        $pb.PbFieldType.O3)
    ..m<$core.int, $core.int>(
        19,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuAiRecommendedLevelV2Map',
        entryClassName:
            'DanmuDefaultPlayerConfig.PlayerDanmakuAiRecommendedLevelV2MapEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('bilibili.community.service.dm.v1'))
    ..hasRequiredFields = false;

  DanmuDefaultPlayerConfig._() : super();
  factory DanmuDefaultPlayerConfig({
    $core.bool? playerDanmakuUseDefaultConfig,
    $core.bool? playerDanmakuAiRecommendedSwitch,
    $core.int? playerDanmakuAiRecommendedLevel,
    $core.bool? playerDanmakuBlocktop,
    $core.bool? playerDanmakuBlockscroll,
    $core.bool? playerDanmakuBlockbottom,
    $core.bool? playerDanmakuBlockcolorful,
    $core.bool? playerDanmakuBlockrepeat,
    $core.bool? playerDanmakuBlockspecial,
    $core.double? playerDanmakuOpacity,
    $core.double? playerDanmakuScalingfactor,
    $core.double? playerDanmakuDomain,
    $core.int? playerDanmakuSpeed,
    $core.bool? inlinePlayerDanmakuSwitch,
    $core.int? playerDanmakuSeniorModeSwitch,
    $core.int? playerDanmakuAiRecommendedLevelV2,
    $core.Map<$core.int, $core.int>? playerDanmakuAiRecommendedLevelV2Map,
  }) {
    final _result = create();
    if (playerDanmakuUseDefaultConfig != null) {
      _result.playerDanmakuUseDefaultConfig = playerDanmakuUseDefaultConfig;
    }
    if (playerDanmakuAiRecommendedSwitch != null) {
      _result.playerDanmakuAiRecommendedSwitch =
          playerDanmakuAiRecommendedSwitch;
    }
    if (playerDanmakuAiRecommendedLevel != null) {
      _result.playerDanmakuAiRecommendedLevel = playerDanmakuAiRecommendedLevel;
    }
    if (playerDanmakuBlocktop != null) {
      _result.playerDanmakuBlocktop = playerDanmakuBlocktop;
    }
    if (playerDanmakuBlockscroll != null) {
      _result.playerDanmakuBlockscroll = playerDanmakuBlockscroll;
    }
    if (playerDanmakuBlockbottom != null) {
      _result.playerDanmakuBlockbottom = playerDanmakuBlockbottom;
    }
    if (playerDanmakuBlockcolorful != null) {
      _result.playerDanmakuBlockcolorful = playerDanmakuBlockcolorful;
    }
    if (playerDanmakuBlockrepeat != null) {
      _result.playerDanmakuBlockrepeat = playerDanmakuBlockrepeat;
    }
    if (playerDanmakuBlockspecial != null) {
      _result.playerDanmakuBlockspecial = playerDanmakuBlockspecial;
    }
    if (playerDanmakuOpacity != null) {
      _result.playerDanmakuOpacity = playerDanmakuOpacity;
    }
    if (playerDanmakuScalingfactor != null) {
      _result.playerDanmakuScalingfactor = playerDanmakuScalingfactor;
    }
    if (playerDanmakuDomain != null) {
      _result.playerDanmakuDomain = playerDanmakuDomain;
    }
    if (playerDanmakuSpeed != null) {
      _result.playerDanmakuSpeed = playerDanmakuSpeed;
    }
    if (inlinePlayerDanmakuSwitch != null) {
      _result.inlinePlayerDanmakuSwitch = inlinePlayerDanmakuSwitch;
    }
    if (playerDanmakuSeniorModeSwitch != null) {
      _result.playerDanmakuSeniorModeSwitch = playerDanmakuSeniorModeSwitch;
    }
    if (playerDanmakuAiRecommendedLevelV2 != null) {
      _result.playerDanmakuAiRecommendedLevelV2 =
          playerDanmakuAiRecommendedLevelV2;
    }
    if (playerDanmakuAiRecommendedLevelV2Map != null) {
      _result.playerDanmakuAiRecommendedLevelV2Map
          .addAll(playerDanmakuAiRecommendedLevelV2Map);
    }
    return _result;
  }
  factory DanmuDefaultPlayerConfig.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DanmuDefaultPlayerConfig.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DanmuDefaultPlayerConfig clone() =>
      DanmuDefaultPlayerConfig()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DanmuDefaultPlayerConfig copyWith(
          void Function(DanmuDefaultPlayerConfig) updates) =>
      super.copyWith((message) => updates(message as DanmuDefaultPlayerConfig))
          as DanmuDefaultPlayerConfig; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DanmuDefaultPlayerConfig create() => DanmuDefaultPlayerConfig._();
  DanmuDefaultPlayerConfig createEmptyInstance() => create();
  static $pb.PbList<DanmuDefaultPlayerConfig> createRepeated() =>
      $pb.PbList<DanmuDefaultPlayerConfig>();
  @$core.pragma('dart2js:noInline')
  static DanmuDefaultPlayerConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmuDefaultPlayerConfig>(create);
  static DanmuDefaultPlayerConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get playerDanmakuUseDefaultConfig => $_getBF(0);
  @$pb.TagNumber(1)
  set playerDanmakuUseDefaultConfig($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPlayerDanmakuUseDefaultConfig() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayerDanmakuUseDefaultConfig() => clearField(1);

  @$pb.TagNumber(4)
  $core.bool get playerDanmakuAiRecommendedSwitch => $_getBF(1);
  @$pb.TagNumber(4)
  set playerDanmakuAiRecommendedSwitch($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasPlayerDanmakuAiRecommendedSwitch() => $_has(1);
  @$pb.TagNumber(4)
  void clearPlayerDanmakuAiRecommendedSwitch() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get playerDanmakuAiRecommendedLevel => $_getIZ(2);
  @$pb.TagNumber(5)
  set playerDanmakuAiRecommendedLevel($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasPlayerDanmakuAiRecommendedLevel() => $_has(2);
  @$pb.TagNumber(5)
  void clearPlayerDanmakuAiRecommendedLevel() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get playerDanmakuBlocktop => $_getBF(3);
  @$pb.TagNumber(6)
  set playerDanmakuBlocktop($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasPlayerDanmakuBlocktop() => $_has(3);
  @$pb.TagNumber(6)
  void clearPlayerDanmakuBlocktop() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get playerDanmakuBlockscroll => $_getBF(4);
  @$pb.TagNumber(7)
  set playerDanmakuBlockscroll($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasPlayerDanmakuBlockscroll() => $_has(4);
  @$pb.TagNumber(7)
  void clearPlayerDanmakuBlockscroll() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get playerDanmakuBlockbottom => $_getBF(5);
  @$pb.TagNumber(8)
  set playerDanmakuBlockbottom($core.bool v) {
    $_setBool(5, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasPlayerDanmakuBlockbottom() => $_has(5);
  @$pb.TagNumber(8)
  void clearPlayerDanmakuBlockbottom() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get playerDanmakuBlockcolorful => $_getBF(6);
  @$pb.TagNumber(9)
  set playerDanmakuBlockcolorful($core.bool v) {
    $_setBool(6, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasPlayerDanmakuBlockcolorful() => $_has(6);
  @$pb.TagNumber(9)
  void clearPlayerDanmakuBlockcolorful() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get playerDanmakuBlockrepeat => $_getBF(7);
  @$pb.TagNumber(10)
  set playerDanmakuBlockrepeat($core.bool v) {
    $_setBool(7, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasPlayerDanmakuBlockrepeat() => $_has(7);
  @$pb.TagNumber(10)
  void clearPlayerDanmakuBlockrepeat() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get playerDanmakuBlockspecial => $_getBF(8);
  @$pb.TagNumber(11)
  set playerDanmakuBlockspecial($core.bool v) {
    $_setBool(8, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasPlayerDanmakuBlockspecial() => $_has(8);
  @$pb.TagNumber(11)
  void clearPlayerDanmakuBlockspecial() => clearField(11);

  @$pb.TagNumber(12)
  $core.double get playerDanmakuOpacity => $_getN(9);
  @$pb.TagNumber(12)
  set playerDanmakuOpacity($core.double v) {
    $_setFloat(9, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasPlayerDanmakuOpacity() => $_has(9);
  @$pb.TagNumber(12)
  void clearPlayerDanmakuOpacity() => clearField(12);

  @$pb.TagNumber(13)
  $core.double get playerDanmakuScalingfactor => $_getN(10);
  @$pb.TagNumber(13)
  set playerDanmakuScalingfactor($core.double v) {
    $_setFloat(10, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasPlayerDanmakuScalingfactor() => $_has(10);
  @$pb.TagNumber(13)
  void clearPlayerDanmakuScalingfactor() => clearField(13);

  @$pb.TagNumber(14)
  $core.double get playerDanmakuDomain => $_getN(11);
  @$pb.TagNumber(14)
  set playerDanmakuDomain($core.double v) {
    $_setFloat(11, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasPlayerDanmakuDomain() => $_has(11);
  @$pb.TagNumber(14)
  void clearPlayerDanmakuDomain() => clearField(14);

  @$pb.TagNumber(15)
  $core.int get playerDanmakuSpeed => $_getIZ(12);
  @$pb.TagNumber(15)
  set playerDanmakuSpeed($core.int v) {
    $_setSignedInt32(12, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasPlayerDanmakuSpeed() => $_has(12);
  @$pb.TagNumber(15)
  void clearPlayerDanmakuSpeed() => clearField(15);

  @$pb.TagNumber(16)
  $core.bool get inlinePlayerDanmakuSwitch => $_getBF(13);
  @$pb.TagNumber(16)
  set inlinePlayerDanmakuSwitch($core.bool v) {
    $_setBool(13, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasInlinePlayerDanmakuSwitch() => $_has(13);
  @$pb.TagNumber(16)
  void clearInlinePlayerDanmakuSwitch() => clearField(16);

  @$pb.TagNumber(17)
  $core.int get playerDanmakuSeniorModeSwitch => $_getIZ(14);
  @$pb.TagNumber(17)
  set playerDanmakuSeniorModeSwitch($core.int v) {
    $_setSignedInt32(14, v);
  }

  @$pb.TagNumber(17)
  $core.bool hasPlayerDanmakuSeniorModeSwitch() => $_has(14);
  @$pb.TagNumber(17)
  void clearPlayerDanmakuSeniorModeSwitch() => clearField(17);

  @$pb.TagNumber(18)
  $core.int get playerDanmakuAiRecommendedLevelV2 => $_getIZ(15);
  @$pb.TagNumber(18)
  set playerDanmakuAiRecommendedLevelV2($core.int v) {
    $_setSignedInt32(15, v);
  }

  @$pb.TagNumber(18)
  $core.bool hasPlayerDanmakuAiRecommendedLevelV2() => $_has(15);
  @$pb.TagNumber(18)
  void clearPlayerDanmakuAiRecommendedLevelV2() => clearField(18);

  @$pb.TagNumber(19)
  $core.Map<$core.int, $core.int> get playerDanmakuAiRecommendedLevelV2Map =>
      $_getMap(16);
}

class DanmuPlayerConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DanmuPlayerConfig',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuSwitch')
    ..aOB(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuSwitchSave')
    ..aOB(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuUseDefaultConfig')
    ..aOB(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuAiRecommendedSwitch')
    ..a<$core.int>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuAiRecommendedLevel',
        $pb.PbFieldType.O3)
    ..aOB(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuBlocktop')
    ..aOB(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuBlockscroll')
    ..aOB(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuBlockbottom')
    ..aOB(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuBlockcolorful')
    ..aOB(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuBlockrepeat')
    ..aOB(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuBlockspecial')
    ..a<$core.double>(
        12,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuOpacity',
        $pb.PbFieldType.OF)
    ..a<$core.double>(
        13,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuScalingfactor',
        $pb.PbFieldType.OF)
    ..a<$core.double>(
        14,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuDomain',
        $pb.PbFieldType.OF)
    ..a<$core.int>(
        15,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuSpeed',
        $pb.PbFieldType.O3)
    ..aOB(
        16,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuEnableblocklist')
    ..aOB(
        17,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'inlinePlayerDanmakuSwitch')
    ..a<$core.int>(
        18,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'inlinePlayerDanmakuConfig',
        $pb.PbFieldType.O3)
    ..a<$core.int>(
        19,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuIosSwitchSave',
        $pb.PbFieldType.O3)
    ..a<$core.int>(
        20,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuSeniorModeSwitch',
        $pb.PbFieldType.O3)
    ..a<$core.int>(
        21,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuAiRecommendedLevelV2',
        $pb.PbFieldType.O3)
    ..m<$core.int, $core.int>(
        22,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuAiRecommendedLevelV2Map',
        entryClassName:
            'DanmuPlayerConfig.PlayerDanmakuAiRecommendedLevelV2MapEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('bilibili.community.service.dm.v1'))
    ..hasRequiredFields = false;

  DanmuPlayerConfig._() : super();
  factory DanmuPlayerConfig({
    $core.bool? playerDanmakuSwitch,
    $core.bool? playerDanmakuSwitchSave,
    $core.bool? playerDanmakuUseDefaultConfig,
    $core.bool? playerDanmakuAiRecommendedSwitch,
    $core.int? playerDanmakuAiRecommendedLevel,
    $core.bool? playerDanmakuBlocktop,
    $core.bool? playerDanmakuBlockscroll,
    $core.bool? playerDanmakuBlockbottom,
    $core.bool? playerDanmakuBlockcolorful,
    $core.bool? playerDanmakuBlockrepeat,
    $core.bool? playerDanmakuBlockspecial,
    $core.double? playerDanmakuOpacity,
    $core.double? playerDanmakuScalingfactor,
    $core.double? playerDanmakuDomain,
    $core.int? playerDanmakuSpeed,
    $core.bool? playerDanmakuEnableblocklist,
    $core.bool? inlinePlayerDanmakuSwitch,
    $core.int? inlinePlayerDanmakuConfig,
    $core.int? playerDanmakuIosSwitchSave,
    $core.int? playerDanmakuSeniorModeSwitch,
    $core.int? playerDanmakuAiRecommendedLevelV2,
    $core.Map<$core.int, $core.int>? playerDanmakuAiRecommendedLevelV2Map,
  }) {
    final _result = create();
    if (playerDanmakuSwitch != null) {
      _result.playerDanmakuSwitch = playerDanmakuSwitch;
    }
    if (playerDanmakuSwitchSave != null) {
      _result.playerDanmakuSwitchSave = playerDanmakuSwitchSave;
    }
    if (playerDanmakuUseDefaultConfig != null) {
      _result.playerDanmakuUseDefaultConfig = playerDanmakuUseDefaultConfig;
    }
    if (playerDanmakuAiRecommendedSwitch != null) {
      _result.playerDanmakuAiRecommendedSwitch =
          playerDanmakuAiRecommendedSwitch;
    }
    if (playerDanmakuAiRecommendedLevel != null) {
      _result.playerDanmakuAiRecommendedLevel = playerDanmakuAiRecommendedLevel;
    }
    if (playerDanmakuBlocktop != null) {
      _result.playerDanmakuBlocktop = playerDanmakuBlocktop;
    }
    if (playerDanmakuBlockscroll != null) {
      _result.playerDanmakuBlockscroll = playerDanmakuBlockscroll;
    }
    if (playerDanmakuBlockbottom != null) {
      _result.playerDanmakuBlockbottom = playerDanmakuBlockbottom;
    }
    if (playerDanmakuBlockcolorful != null) {
      _result.playerDanmakuBlockcolorful = playerDanmakuBlockcolorful;
    }
    if (playerDanmakuBlockrepeat != null) {
      _result.playerDanmakuBlockrepeat = playerDanmakuBlockrepeat;
    }
    if (playerDanmakuBlockspecial != null) {
      _result.playerDanmakuBlockspecial = playerDanmakuBlockspecial;
    }
    if (playerDanmakuOpacity != null) {
      _result.playerDanmakuOpacity = playerDanmakuOpacity;
    }
    if (playerDanmakuScalingfactor != null) {
      _result.playerDanmakuScalingfactor = playerDanmakuScalingfactor;
    }
    if (playerDanmakuDomain != null) {
      _result.playerDanmakuDomain = playerDanmakuDomain;
    }
    if (playerDanmakuSpeed != null) {
      _result.playerDanmakuSpeed = playerDanmakuSpeed;
    }
    if (playerDanmakuEnableblocklist != null) {
      _result.playerDanmakuEnableblocklist = playerDanmakuEnableblocklist;
    }
    if (inlinePlayerDanmakuSwitch != null) {
      _result.inlinePlayerDanmakuSwitch = inlinePlayerDanmakuSwitch;
    }
    if (inlinePlayerDanmakuConfig != null) {
      _result.inlinePlayerDanmakuConfig = inlinePlayerDanmakuConfig;
    }
    if (playerDanmakuIosSwitchSave != null) {
      _result.playerDanmakuIosSwitchSave = playerDanmakuIosSwitchSave;
    }
    if (playerDanmakuSeniorModeSwitch != null) {
      _result.playerDanmakuSeniorModeSwitch = playerDanmakuSeniorModeSwitch;
    }
    if (playerDanmakuAiRecommendedLevelV2 != null) {
      _result.playerDanmakuAiRecommendedLevelV2 =
          playerDanmakuAiRecommendedLevelV2;
    }
    if (playerDanmakuAiRecommendedLevelV2Map != null) {
      _result.playerDanmakuAiRecommendedLevelV2Map
          .addAll(playerDanmakuAiRecommendedLevelV2Map);
    }
    return _result;
  }
  factory DanmuPlayerConfig.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DanmuPlayerConfig.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DanmuPlayerConfig clone() => DanmuPlayerConfig()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DanmuPlayerConfig copyWith(void Function(DanmuPlayerConfig) updates) =>
      super.copyWith((message) => updates(message as DanmuPlayerConfig))
          as DanmuPlayerConfig; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DanmuPlayerConfig create() => DanmuPlayerConfig._();
  DanmuPlayerConfig createEmptyInstance() => create();
  static $pb.PbList<DanmuPlayerConfig> createRepeated() =>
      $pb.PbList<DanmuPlayerConfig>();
  @$core.pragma('dart2js:noInline')
  static DanmuPlayerConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmuPlayerConfig>(create);
  static DanmuPlayerConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get playerDanmakuSwitch => $_getBF(0);
  @$pb.TagNumber(1)
  set playerDanmakuSwitch($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPlayerDanmakuSwitch() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayerDanmakuSwitch() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get playerDanmakuSwitchSave => $_getBF(1);
  @$pb.TagNumber(2)
  set playerDanmakuSwitchSave($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPlayerDanmakuSwitchSave() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayerDanmakuSwitchSave() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get playerDanmakuUseDefaultConfig => $_getBF(2);
  @$pb.TagNumber(3)
  set playerDanmakuUseDefaultConfig($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPlayerDanmakuUseDefaultConfig() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlayerDanmakuUseDefaultConfig() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get playerDanmakuAiRecommendedSwitch => $_getBF(3);
  @$pb.TagNumber(4)
  set playerDanmakuAiRecommendedSwitch($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasPlayerDanmakuAiRecommendedSwitch() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlayerDanmakuAiRecommendedSwitch() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get playerDanmakuAiRecommendedLevel => $_getIZ(4);
  @$pb.TagNumber(5)
  set playerDanmakuAiRecommendedLevel($core.int v) {
    $_setSignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasPlayerDanmakuAiRecommendedLevel() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlayerDanmakuAiRecommendedLevel() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get playerDanmakuBlocktop => $_getBF(5);
  @$pb.TagNumber(6)
  set playerDanmakuBlocktop($core.bool v) {
    $_setBool(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasPlayerDanmakuBlocktop() => $_has(5);
  @$pb.TagNumber(6)
  void clearPlayerDanmakuBlocktop() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get playerDanmakuBlockscroll => $_getBF(6);
  @$pb.TagNumber(7)
  set playerDanmakuBlockscroll($core.bool v) {
    $_setBool(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasPlayerDanmakuBlockscroll() => $_has(6);
  @$pb.TagNumber(7)
  void clearPlayerDanmakuBlockscroll() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get playerDanmakuBlockbottom => $_getBF(7);
  @$pb.TagNumber(8)
  set playerDanmakuBlockbottom($core.bool v) {
    $_setBool(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasPlayerDanmakuBlockbottom() => $_has(7);
  @$pb.TagNumber(8)
  void clearPlayerDanmakuBlockbottom() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get playerDanmakuBlockcolorful => $_getBF(8);
  @$pb.TagNumber(9)
  set playerDanmakuBlockcolorful($core.bool v) {
    $_setBool(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasPlayerDanmakuBlockcolorful() => $_has(8);
  @$pb.TagNumber(9)
  void clearPlayerDanmakuBlockcolorful() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get playerDanmakuBlockrepeat => $_getBF(9);
  @$pb.TagNumber(10)
  set playerDanmakuBlockrepeat($core.bool v) {
    $_setBool(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasPlayerDanmakuBlockrepeat() => $_has(9);
  @$pb.TagNumber(10)
  void clearPlayerDanmakuBlockrepeat() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get playerDanmakuBlockspecial => $_getBF(10);
  @$pb.TagNumber(11)
  set playerDanmakuBlockspecial($core.bool v) {
    $_setBool(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasPlayerDanmakuBlockspecial() => $_has(10);
  @$pb.TagNumber(11)
  void clearPlayerDanmakuBlockspecial() => clearField(11);

  @$pb.TagNumber(12)
  $core.double get playerDanmakuOpacity => $_getN(11);
  @$pb.TagNumber(12)
  set playerDanmakuOpacity($core.double v) {
    $_setFloat(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasPlayerDanmakuOpacity() => $_has(11);
  @$pb.TagNumber(12)
  void clearPlayerDanmakuOpacity() => clearField(12);

  @$pb.TagNumber(13)
  $core.double get playerDanmakuScalingfactor => $_getN(12);
  @$pb.TagNumber(13)
  set playerDanmakuScalingfactor($core.double v) {
    $_setFloat(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasPlayerDanmakuScalingfactor() => $_has(12);
  @$pb.TagNumber(13)
  void clearPlayerDanmakuScalingfactor() => clearField(13);

  @$pb.TagNumber(14)
  $core.double get playerDanmakuDomain => $_getN(13);
  @$pb.TagNumber(14)
  set playerDanmakuDomain($core.double v) {
    $_setFloat(13, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasPlayerDanmakuDomain() => $_has(13);
  @$pb.TagNumber(14)
  void clearPlayerDanmakuDomain() => clearField(14);

  @$pb.TagNumber(15)
  $core.int get playerDanmakuSpeed => $_getIZ(14);
  @$pb.TagNumber(15)
  set playerDanmakuSpeed($core.int v) {
    $_setSignedInt32(14, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasPlayerDanmakuSpeed() => $_has(14);
  @$pb.TagNumber(15)
  void clearPlayerDanmakuSpeed() => clearField(15);

  @$pb.TagNumber(16)
  $core.bool get playerDanmakuEnableblocklist => $_getBF(15);
  @$pb.TagNumber(16)
  set playerDanmakuEnableblocklist($core.bool v) {
    $_setBool(15, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasPlayerDanmakuEnableblocklist() => $_has(15);
  @$pb.TagNumber(16)
  void clearPlayerDanmakuEnableblocklist() => clearField(16);

  @$pb.TagNumber(17)
  $core.bool get inlinePlayerDanmakuSwitch => $_getBF(16);
  @$pb.TagNumber(17)
  set inlinePlayerDanmakuSwitch($core.bool v) {
    $_setBool(16, v);
  }

  @$pb.TagNumber(17)
  $core.bool hasInlinePlayerDanmakuSwitch() => $_has(16);
  @$pb.TagNumber(17)
  void clearInlinePlayerDanmakuSwitch() => clearField(17);

  @$pb.TagNumber(18)
  $core.int get inlinePlayerDanmakuConfig => $_getIZ(17);
  @$pb.TagNumber(18)
  set inlinePlayerDanmakuConfig($core.int v) {
    $_setSignedInt32(17, v);
  }

  @$pb.TagNumber(18)
  $core.bool hasInlinePlayerDanmakuConfig() => $_has(17);
  @$pb.TagNumber(18)
  void clearInlinePlayerDanmakuConfig() => clearField(18);

  @$pb.TagNumber(19)
  $core.int get playerDanmakuIosSwitchSave => $_getIZ(18);
  @$pb.TagNumber(19)
  set playerDanmakuIosSwitchSave($core.int v) {
    $_setSignedInt32(18, v);
  }

  @$pb.TagNumber(19)
  $core.bool hasPlayerDanmakuIosSwitchSave() => $_has(18);
  @$pb.TagNumber(19)
  void clearPlayerDanmakuIosSwitchSave() => clearField(19);

  @$pb.TagNumber(20)
  $core.int get playerDanmakuSeniorModeSwitch => $_getIZ(19);
  @$pb.TagNumber(20)
  set playerDanmakuSeniorModeSwitch($core.int v) {
    $_setSignedInt32(19, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasPlayerDanmakuSeniorModeSwitch() => $_has(19);
  @$pb.TagNumber(20)
  void clearPlayerDanmakuSeniorModeSwitch() => clearField(20);

  @$pb.TagNumber(21)
  $core.int get playerDanmakuAiRecommendedLevelV2 => $_getIZ(20);
  @$pb.TagNumber(21)
  set playerDanmakuAiRecommendedLevelV2($core.int v) {
    $_setSignedInt32(20, v);
  }

  @$pb.TagNumber(21)
  $core.bool hasPlayerDanmakuAiRecommendedLevelV2() => $_has(20);
  @$pb.TagNumber(21)
  void clearPlayerDanmakuAiRecommendedLevelV2() => clearField(21);

  @$pb.TagNumber(22)
  $core.Map<$core.int, $core.int> get playerDanmakuAiRecommendedLevelV2Map =>
      $_getMap(21);
}

class DanmuPlayerConfigPanel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DanmuPlayerConfigPanel',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'selectionText')
    ..hasRequiredFields = false;

  DanmuPlayerConfigPanel._() : super();
  factory DanmuPlayerConfigPanel({
    $core.String? selectionText,
  }) {
    final _result = create();
    if (selectionText != null) {
      _result.selectionText = selectionText;
    }
    return _result;
  }
  factory DanmuPlayerConfigPanel.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DanmuPlayerConfigPanel.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DanmuPlayerConfigPanel clone() =>
      DanmuPlayerConfigPanel()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DanmuPlayerConfigPanel copyWith(
          void Function(DanmuPlayerConfigPanel) updates) =>
      super.copyWith((message) => updates(message as DanmuPlayerConfigPanel))
          as DanmuPlayerConfigPanel; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DanmuPlayerConfigPanel create() => DanmuPlayerConfigPanel._();
  DanmuPlayerConfigPanel createEmptyInstance() => create();
  static $pb.PbList<DanmuPlayerConfigPanel> createRepeated() =>
      $pb.PbList<DanmuPlayerConfigPanel>();
  @$core.pragma('dart2js:noInline')
  static DanmuPlayerConfigPanel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmuPlayerConfigPanel>(create);
  static DanmuPlayerConfigPanel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get selectionText => $_getSZ(0);
  @$pb.TagNumber(1)
  set selectionText($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSelectionText() => $_has(0);
  @$pb.TagNumber(1)
  void clearSelectionText() => clearField(1);
}

class DanmuPlayerDynamicConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DanmuPlayerDynamicConfig',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'progress',
        $pb.PbFieldType.O3)
    ..a<$core.double>(
        14,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerDanmakuDomain',
        $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  DanmuPlayerDynamicConfig._() : super();
  factory DanmuPlayerDynamicConfig({
    $core.int? progress,
    $core.double? playerDanmakuDomain,
  }) {
    final _result = create();
    if (progress != null) {
      _result.progress = progress;
    }
    if (playerDanmakuDomain != null) {
      _result.playerDanmakuDomain = playerDanmakuDomain;
    }
    return _result;
  }
  factory DanmuPlayerDynamicConfig.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DanmuPlayerDynamicConfig.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DanmuPlayerDynamicConfig clone() =>
      DanmuPlayerDynamicConfig()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DanmuPlayerDynamicConfig copyWith(
          void Function(DanmuPlayerDynamicConfig) updates) =>
      super.copyWith((message) => updates(message as DanmuPlayerDynamicConfig))
          as DanmuPlayerDynamicConfig; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DanmuPlayerDynamicConfig create() => DanmuPlayerDynamicConfig._();
  DanmuPlayerDynamicConfig createEmptyInstance() => create();
  static $pb.PbList<DanmuPlayerDynamicConfig> createRepeated() =>
      $pb.PbList<DanmuPlayerDynamicConfig>();
  @$core.pragma('dart2js:noInline')
  static DanmuPlayerDynamicConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmuPlayerDynamicConfig>(create);
  static DanmuPlayerDynamicConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get progress => $_getIZ(0);
  @$pb.TagNumber(1)
  set progress($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProgress() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgress() => clearField(1);

  @$pb.TagNumber(14)
  $core.double get playerDanmakuDomain => $_getN(1);
  @$pb.TagNumber(14)
  set playerDanmakuDomain($core.double v) {
    $_setFloat(1, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasPlayerDanmakuDomain() => $_has(1);
  @$pb.TagNumber(14)
  void clearPlayerDanmakuDomain() => clearField(14);
}

class DanmuPlayerViewConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DanmuPlayerViewConfig',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOM<DanmuDefaultPlayerConfig>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'danmukuDefaultPlayerConfig',
        subBuilder: DanmuDefaultPlayerConfig.create)
    ..aOM<DanmuPlayerConfig>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'danmukuPlayerConfig',
        subBuilder: DanmuPlayerConfig.create)
    ..pc<DanmuPlayerDynamicConfig>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'danmukuPlayerDynamicConfig',
        $pb.PbFieldType.PM,
        subBuilder: DanmuPlayerDynamicConfig.create)
    ..aOM<DanmuPlayerConfigPanel>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'danmukuPlayerConfigPanel',
        subBuilder: DanmuPlayerConfigPanel.create)
    ..hasRequiredFields = false;

  DanmuPlayerViewConfig._() : super();
  factory DanmuPlayerViewConfig({
    DanmuDefaultPlayerConfig? danmukuDefaultPlayerConfig,
    DanmuPlayerConfig? danmukuPlayerConfig,
    $core.Iterable<DanmuPlayerDynamicConfig>? danmukuPlayerDynamicConfig,
    DanmuPlayerConfigPanel? danmukuPlayerConfigPanel,
  }) {
    final _result = create();
    if (danmukuDefaultPlayerConfig != null) {
      _result.danmukuDefaultPlayerConfig = danmukuDefaultPlayerConfig;
    }
    if (danmukuPlayerConfig != null) {
      _result.danmukuPlayerConfig = danmukuPlayerConfig;
    }
    if (danmukuPlayerDynamicConfig != null) {
      _result.danmukuPlayerDynamicConfig.addAll(danmukuPlayerDynamicConfig);
    }
    if (danmukuPlayerConfigPanel != null) {
      _result.danmukuPlayerConfigPanel = danmukuPlayerConfigPanel;
    }
    return _result;
  }
  factory DanmuPlayerViewConfig.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DanmuPlayerViewConfig.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DanmuPlayerViewConfig clone() =>
      DanmuPlayerViewConfig()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DanmuPlayerViewConfig copyWith(
          void Function(DanmuPlayerViewConfig) updates) =>
      super.copyWith((message) => updates(message as DanmuPlayerViewConfig))
          as DanmuPlayerViewConfig; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DanmuPlayerViewConfig create() => DanmuPlayerViewConfig._();
  DanmuPlayerViewConfig createEmptyInstance() => create();
  static $pb.PbList<DanmuPlayerViewConfig> createRepeated() =>
      $pb.PbList<DanmuPlayerViewConfig>();
  @$core.pragma('dart2js:noInline')
  static DanmuPlayerViewConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmuPlayerViewConfig>(create);
  static DanmuPlayerViewConfig? _defaultInstance;

  @$pb.TagNumber(1)
  DanmuDefaultPlayerConfig get danmukuDefaultPlayerConfig => $_getN(0);
  @$pb.TagNumber(1)
  set danmukuDefaultPlayerConfig(DanmuDefaultPlayerConfig v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasDanmukuDefaultPlayerConfig() => $_has(0);
  @$pb.TagNumber(1)
  void clearDanmukuDefaultPlayerConfig() => clearField(1);
  @$pb.TagNumber(1)
  DanmuDefaultPlayerConfig ensureDanmukuDefaultPlayerConfig() => $_ensure(0);

  @$pb.TagNumber(2)
  DanmuPlayerConfig get danmukuPlayerConfig => $_getN(1);
  @$pb.TagNumber(2)
  set danmukuPlayerConfig(DanmuPlayerConfig v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasDanmukuPlayerConfig() => $_has(1);
  @$pb.TagNumber(2)
  void clearDanmukuPlayerConfig() => clearField(2);
  @$pb.TagNumber(2)
  DanmuPlayerConfig ensureDanmukuPlayerConfig() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.List<DanmuPlayerDynamicConfig> get danmukuPlayerDynamicConfig =>
      $_getList(2);

  @$pb.TagNumber(4)
  DanmuPlayerConfigPanel get danmukuPlayerConfigPanel => $_getN(3);
  @$pb.TagNumber(4)
  set danmukuPlayerConfigPanel(DanmuPlayerConfigPanel v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasDanmukuPlayerConfigPanel() => $_has(3);
  @$pb.TagNumber(4)
  void clearDanmukuPlayerConfigPanel() => clearField(4);
  @$pb.TagNumber(4)
  DanmuPlayerConfigPanel ensureDanmukuPlayerConfigPanel() => $_ensure(3);
}

class DanmuWebPlayerConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DanmuWebPlayerConfig',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'dmSwitch')
    ..aOB(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'aiSwitch')
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'aiLevel',
        $pb.PbFieldType.O3)
    ..aOB(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'blocktop')
    ..aOB(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'blockscroll')
    ..aOB(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'blockbottom')
    ..aOB(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'blockcolor')
    ..aOB(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'blockspecial')
    ..aOB(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'preventshade')
    ..aOB(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'dmask')
    ..a<$core.double>(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'opacity',
        $pb.PbFieldType.OF)
    ..a<$core.int>(
        12,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'dmarea',
        $pb.PbFieldType.O3)
    ..a<$core.double>(
        13,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'speedplus',
        $pb.PbFieldType.OF)
    ..a<$core.double>(
        14,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'fontsize',
        $pb.PbFieldType.OF)
    ..aOB(
        15,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'screensync')
    ..aOB(
        16,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'speedsync')
    ..aOS(
        17,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'fontfamily')
    ..aOB(
        18,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bold')
    ..a<$core.int>(
        19,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'fontborder',
        $pb.PbFieldType.O3)
    ..aOS(
        20,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'drawType')
    ..a<$core.int>(
        21,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'seniorModeSwitch',
        $pb.PbFieldType.O3)
    ..a<$core.int>(
        22,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'aiLevelV2',
        $pb.PbFieldType.O3)
    ..m<$core.int, $core.int>(
        23,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'aiLevelV2Map',
        entryClassName: 'DanmuWebPlayerConfig.AiLevelV2MapEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('bilibili.community.service.dm.v1'))
    ..hasRequiredFields = false;

  DanmuWebPlayerConfig._() : super();
  factory DanmuWebPlayerConfig({
    $core.bool? dmSwitch,
    $core.bool? aiSwitch,
    $core.int? aiLevel,
    $core.bool? blocktop,
    $core.bool? blockscroll,
    $core.bool? blockbottom,
    $core.bool? blockcolor,
    $core.bool? blockspecial,
    $core.bool? preventshade,
    $core.bool? dmask,
    $core.double? opacity,
    $core.int? dmarea,
    $core.double? speedplus,
    $core.double? fontsize,
    $core.bool? screensync,
    $core.bool? speedsync,
    $core.String? fontfamily,
    $core.bool? bold,
    $core.int? fontborder,
    $core.String? drawType,
    $core.int? seniorModeSwitch,
    $core.int? aiLevelV2,
    $core.Map<$core.int, $core.int>? aiLevelV2Map,
  }) {
    final _result = create();
    if (dmSwitch != null) {
      _result.dmSwitch = dmSwitch;
    }
    if (aiSwitch != null) {
      _result.aiSwitch = aiSwitch;
    }
    if (aiLevel != null) {
      _result.aiLevel = aiLevel;
    }
    if (blocktop != null) {
      _result.blocktop = blocktop;
    }
    if (blockscroll != null) {
      _result.blockscroll = blockscroll;
    }
    if (blockbottom != null) {
      _result.blockbottom = blockbottom;
    }
    if (blockcolor != null) {
      _result.blockcolor = blockcolor;
    }
    if (blockspecial != null) {
      _result.blockspecial = blockspecial;
    }
    if (preventshade != null) {
      _result.preventshade = preventshade;
    }
    if (dmask != null) {
      _result.dmask = dmask;
    }
    if (opacity != null) {
      _result.opacity = opacity;
    }
    if (dmarea != null) {
      _result.dmarea = dmarea;
    }
    if (speedplus != null) {
      _result.speedplus = speedplus;
    }
    if (fontsize != null) {
      _result.fontsize = fontsize;
    }
    if (screensync != null) {
      _result.screensync = screensync;
    }
    if (speedsync != null) {
      _result.speedsync = speedsync;
    }
    if (fontfamily != null) {
      _result.fontfamily = fontfamily;
    }
    if (bold != null) {
      _result.bold = bold;
    }
    if (fontborder != null) {
      _result.fontborder = fontborder;
    }
    if (drawType != null) {
      _result.drawType = drawType;
    }
    if (seniorModeSwitch != null) {
      _result.seniorModeSwitch = seniorModeSwitch;
    }
    if (aiLevelV2 != null) {
      _result.aiLevelV2 = aiLevelV2;
    }
    if (aiLevelV2Map != null) {
      _result.aiLevelV2Map.addAll(aiLevelV2Map);
    }
    return _result;
  }
  factory DanmuWebPlayerConfig.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DanmuWebPlayerConfig.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DanmuWebPlayerConfig clone() =>
      DanmuWebPlayerConfig()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DanmuWebPlayerConfig copyWith(void Function(DanmuWebPlayerConfig) updates) =>
      super.copyWith((message) => updates(message as DanmuWebPlayerConfig))
          as DanmuWebPlayerConfig; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DanmuWebPlayerConfig create() => DanmuWebPlayerConfig._();
  DanmuWebPlayerConfig createEmptyInstance() => create();
  static $pb.PbList<DanmuWebPlayerConfig> createRepeated() =>
      $pb.PbList<DanmuWebPlayerConfig>();
  @$core.pragma('dart2js:noInline')
  static DanmuWebPlayerConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmuWebPlayerConfig>(create);
  static DanmuWebPlayerConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get dmSwitch => $_getBF(0);
  @$pb.TagNumber(1)
  set dmSwitch($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasDmSwitch() => $_has(0);
  @$pb.TagNumber(1)
  void clearDmSwitch() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get aiSwitch => $_getBF(1);
  @$pb.TagNumber(2)
  set aiSwitch($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasAiSwitch() => $_has(1);
  @$pb.TagNumber(2)
  void clearAiSwitch() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get aiLevel => $_getIZ(2);
  @$pb.TagNumber(3)
  set aiLevel($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasAiLevel() => $_has(2);
  @$pb.TagNumber(3)
  void clearAiLevel() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get blocktop => $_getBF(3);
  @$pb.TagNumber(4)
  set blocktop($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasBlocktop() => $_has(3);
  @$pb.TagNumber(4)
  void clearBlocktop() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get blockscroll => $_getBF(4);
  @$pb.TagNumber(5)
  set blockscroll($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasBlockscroll() => $_has(4);
  @$pb.TagNumber(5)
  void clearBlockscroll() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get blockbottom => $_getBF(5);
  @$pb.TagNumber(6)
  set blockbottom($core.bool v) {
    $_setBool(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasBlockbottom() => $_has(5);
  @$pb.TagNumber(6)
  void clearBlockbottom() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get blockcolor => $_getBF(6);
  @$pb.TagNumber(7)
  set blockcolor($core.bool v) {
    $_setBool(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasBlockcolor() => $_has(6);
  @$pb.TagNumber(7)
  void clearBlockcolor() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get blockspecial => $_getBF(7);
  @$pb.TagNumber(8)
  set blockspecial($core.bool v) {
    $_setBool(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasBlockspecial() => $_has(7);
  @$pb.TagNumber(8)
  void clearBlockspecial() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get preventshade => $_getBF(8);
  @$pb.TagNumber(9)
  set preventshade($core.bool v) {
    $_setBool(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasPreventshade() => $_has(8);
  @$pb.TagNumber(9)
  void clearPreventshade() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get dmask => $_getBF(9);
  @$pb.TagNumber(10)
  set dmask($core.bool v) {
    $_setBool(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasDmask() => $_has(9);
  @$pb.TagNumber(10)
  void clearDmask() => clearField(10);

  @$pb.TagNumber(11)
  $core.double get opacity => $_getN(10);
  @$pb.TagNumber(11)
  set opacity($core.double v) {
    $_setFloat(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasOpacity() => $_has(10);
  @$pb.TagNumber(11)
  void clearOpacity() => clearField(11);

  @$pb.TagNumber(12)
  $core.int get dmarea => $_getIZ(11);
  @$pb.TagNumber(12)
  set dmarea($core.int v) {
    $_setSignedInt32(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasDmarea() => $_has(11);
  @$pb.TagNumber(12)
  void clearDmarea() => clearField(12);

  @$pb.TagNumber(13)
  $core.double get speedplus => $_getN(12);
  @$pb.TagNumber(13)
  set speedplus($core.double v) {
    $_setFloat(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasSpeedplus() => $_has(12);
  @$pb.TagNumber(13)
  void clearSpeedplus() => clearField(13);

  @$pb.TagNumber(14)
  $core.double get fontsize => $_getN(13);
  @$pb.TagNumber(14)
  set fontsize($core.double v) {
    $_setFloat(13, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasFontsize() => $_has(13);
  @$pb.TagNumber(14)
  void clearFontsize() => clearField(14);

  @$pb.TagNumber(15)
  $core.bool get screensync => $_getBF(14);
  @$pb.TagNumber(15)
  set screensync($core.bool v) {
    $_setBool(14, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasScreensync() => $_has(14);
  @$pb.TagNumber(15)
  void clearScreensync() => clearField(15);

  @$pb.TagNumber(16)
  $core.bool get speedsync => $_getBF(15);
  @$pb.TagNumber(16)
  set speedsync($core.bool v) {
    $_setBool(15, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasSpeedsync() => $_has(15);
  @$pb.TagNumber(16)
  void clearSpeedsync() => clearField(16);

  @$pb.TagNumber(17)
  $core.String get fontfamily => $_getSZ(16);
  @$pb.TagNumber(17)
  set fontfamily($core.String v) {
    $_setString(16, v);
  }

  @$pb.TagNumber(17)
  $core.bool hasFontfamily() => $_has(16);
  @$pb.TagNumber(17)
  void clearFontfamily() => clearField(17);

  @$pb.TagNumber(18)
  $core.bool get bold => $_getBF(17);
  @$pb.TagNumber(18)
  set bold($core.bool v) {
    $_setBool(17, v);
  }

  @$pb.TagNumber(18)
  $core.bool hasBold() => $_has(17);
  @$pb.TagNumber(18)
  void clearBold() => clearField(18);

  @$pb.TagNumber(19)
  $core.int get fontborder => $_getIZ(18);
  @$pb.TagNumber(19)
  set fontborder($core.int v) {
    $_setSignedInt32(18, v);
  }

  @$pb.TagNumber(19)
  $core.bool hasFontborder() => $_has(18);
  @$pb.TagNumber(19)
  void clearFontborder() => clearField(19);

  @$pb.TagNumber(20)
  $core.String get drawType => $_getSZ(19);
  @$pb.TagNumber(20)
  set drawType($core.String v) {
    $_setString(19, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasDrawType() => $_has(19);
  @$pb.TagNumber(20)
  void clearDrawType() => clearField(20);

  @$pb.TagNumber(21)
  $core.int get seniorModeSwitch => $_getIZ(20);
  @$pb.TagNumber(21)
  set seniorModeSwitch($core.int v) {
    $_setSignedInt32(20, v);
  }

  @$pb.TagNumber(21)
  $core.bool hasSeniorModeSwitch() => $_has(20);
  @$pb.TagNumber(21)
  void clearSeniorModeSwitch() => clearField(21);

  @$pb.TagNumber(22)
  $core.int get aiLevelV2 => $_getIZ(21);
  @$pb.TagNumber(22)
  set aiLevelV2($core.int v) {
    $_setSignedInt32(21, v);
  }

  @$pb.TagNumber(22)
  $core.bool hasAiLevelV2() => $_has(21);
  @$pb.TagNumber(22)
  void clearAiLevelV2() => clearField(22);

  @$pb.TagNumber(23)
  $core.Map<$core.int, $core.int> get aiLevelV2Map => $_getMap(22);
}

class DmExpoReportReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DmExpoReportReq',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'sessionId')
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'oid')
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'spmid')
    ..hasRequiredFields = false;

  DmExpoReportReq._() : super();
  factory DmExpoReportReq({
    $core.String? sessionId,
    $fixnum.Int64? oid,
    $core.String? spmid,
  }) {
    final _result = create();
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (oid != null) {
      _result.oid = oid;
    }
    if (spmid != null) {
      _result.spmid = spmid;
    }
    return _result;
  }
  factory DmExpoReportReq.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DmExpoReportReq.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DmExpoReportReq clone() => DmExpoReportReq()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DmExpoReportReq copyWith(void Function(DmExpoReportReq) updates) =>
      super.copyWith((message) => updates(message as DmExpoReportReq))
          as DmExpoReportReq; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DmExpoReportReq create() => DmExpoReportReq._();
  DmExpoReportReq createEmptyInstance() => create();
  static $pb.PbList<DmExpoReportReq> createRepeated() =>
      $pb.PbList<DmExpoReportReq>();
  @$core.pragma('dart2js:noInline')
  static DmExpoReportReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmExpoReportReq>(create);
  static DmExpoReportReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get oid => $_getI64(1);
  @$pb.TagNumber(2)
  set oid($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => clearField(2);

  @$pb.TagNumber(4)
  $core.String get spmid => $_getSZ(2);
  @$pb.TagNumber(4)
  set spmid($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSpmid() => $_has(2);
  @$pb.TagNumber(4)
  void clearSpmid() => clearField(4);
}

class DmExpoReportRes extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DmExpoReportRes',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  DmExpoReportRes._() : super();
  factory DmExpoReportRes() => create();
  factory DmExpoReportRes.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DmExpoReportRes.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DmExpoReportRes clone() => DmExpoReportRes()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DmExpoReportRes copyWith(void Function(DmExpoReportRes) updates) =>
      super.copyWith((message) => updates(message as DmExpoReportRes))
          as DmExpoReportRes; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DmExpoReportRes create() => DmExpoReportRes._();
  DmExpoReportRes createEmptyInstance() => create();
  static $pb.PbList<DmExpoReportRes> createRepeated() =>
      $pb.PbList<DmExpoReportRes>();
  @$core.pragma('dart2js:noInline')
  static DmExpoReportRes getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmExpoReportRes>(create);
  static DmExpoReportRes? _defaultInstance;
}

class DmPlayerConfigReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DmPlayerConfigReq',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'ts')
    ..aOM<PlayerDanmakuSwitch>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'switch',
        subBuilder: PlayerDanmakuSwitch.create)
    ..aOM<PlayerDanmakuSwitchSave>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'switchSave',
        subBuilder: PlayerDanmakuSwitchSave.create)
    ..aOM<PlayerDanmakuUseDefaultConfig>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'useDefaultConfig',
        subBuilder: PlayerDanmakuUseDefaultConfig.create)
    ..aOM<PlayerDanmakuAiRecommendedSwitch>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'aiRecommendedSwitch',
        subBuilder: PlayerDanmakuAiRecommendedSwitch.create)
    ..aOM<PlayerDanmakuAiRecommendedLevel>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'aiRecommendedLevel',
        subBuilder: PlayerDanmakuAiRecommendedLevel.create)
    ..aOM<PlayerDanmakuBlocktop>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'blocktop',
        subBuilder: PlayerDanmakuBlocktop.create)
    ..aOM<PlayerDanmakuBlockscroll>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'blockscroll',
        subBuilder: PlayerDanmakuBlockscroll.create)
    ..aOM<PlayerDanmakuBlockbottom>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'blockbottom',
        subBuilder: PlayerDanmakuBlockbottom.create)
    ..aOM<PlayerDanmakuBlockcolorful>(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'blockcolorful',
        subBuilder: PlayerDanmakuBlockcolorful.create)
    ..aOM<PlayerDanmakuBlockrepeat>(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'blockrepeat',
        subBuilder: PlayerDanmakuBlockrepeat.create)
    ..aOM<PlayerDanmakuBlockspecial>(
        12,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'blockspecial',
        subBuilder: PlayerDanmakuBlockspecial.create)
    ..aOM<PlayerDanmakuOpacity>(
        13,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'opacity',
        subBuilder: PlayerDanmakuOpacity.create)
    ..aOM<PlayerDanmakuScalingfactor>(
        14,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'scalingfactor',
        subBuilder: PlayerDanmakuScalingfactor.create)
    ..aOM<PlayerDanmakuDomain>(
        15,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'domain',
        subBuilder: PlayerDanmakuDomain.create)
    ..aOM<PlayerDanmakuSpeed>(
        16,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'speed',
        subBuilder: PlayerDanmakuSpeed.create)
    ..aOM<PlayerDanmakuEnableblocklist>(
        17,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'enableblocklist',
        subBuilder: PlayerDanmakuEnableblocklist.create)
    ..aOM<InlinePlayerDanmakuSwitch>(
        18,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'inlinePlayerDanmakuSwitch',
        protoName: 'inlinePlayerDanmakuSwitch',
        subBuilder: InlinePlayerDanmakuSwitch.create)
    ..aOM<PlayerDanmakuSeniorModeSwitch>(
        19,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'seniorModeSwitch',
        subBuilder: PlayerDanmakuSeniorModeSwitch.create)
    ..aOM<PlayerDanmakuAiRecommendedLevelV2>(
        20,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'aiRecommendedLevelV2',
        subBuilder: PlayerDanmakuAiRecommendedLevelV2.create)
    ..hasRequiredFields = false;

  DmPlayerConfigReq._() : super();
  factory DmPlayerConfigReq({
    $fixnum.Int64? ts,
    PlayerDanmakuSwitch? switch_2,
    PlayerDanmakuSwitchSave? switchSave,
    PlayerDanmakuUseDefaultConfig? useDefaultConfig,
    PlayerDanmakuAiRecommendedSwitch? aiRecommendedSwitch,
    PlayerDanmakuAiRecommendedLevel? aiRecommendedLevel,
    PlayerDanmakuBlocktop? blocktop,
    PlayerDanmakuBlockscroll? blockscroll,
    PlayerDanmakuBlockbottom? blockbottom,
    PlayerDanmakuBlockcolorful? blockcolorful,
    PlayerDanmakuBlockrepeat? blockrepeat,
    PlayerDanmakuBlockspecial? blockspecial,
    PlayerDanmakuOpacity? opacity,
    PlayerDanmakuScalingfactor? scalingfactor,
    PlayerDanmakuDomain? domain,
    PlayerDanmakuSpeed? speed,
    PlayerDanmakuEnableblocklist? enableblocklist,
    InlinePlayerDanmakuSwitch? inlinePlayerDanmakuSwitch,
    PlayerDanmakuSeniorModeSwitch? seniorModeSwitch,
    PlayerDanmakuAiRecommendedLevelV2? aiRecommendedLevelV2,
  }) {
    final _result = create();
    if (ts != null) {
      _result.ts = ts;
    }
    if (switch_2 != null) {
      _result.switch_2 = switch_2;
    }
    if (switchSave != null) {
      _result.switchSave = switchSave;
    }
    if (useDefaultConfig != null) {
      _result.useDefaultConfig = useDefaultConfig;
    }
    if (aiRecommendedSwitch != null) {
      _result.aiRecommendedSwitch = aiRecommendedSwitch;
    }
    if (aiRecommendedLevel != null) {
      _result.aiRecommendedLevel = aiRecommendedLevel;
    }
    if (blocktop != null) {
      _result.blocktop = blocktop;
    }
    if (blockscroll != null) {
      _result.blockscroll = blockscroll;
    }
    if (blockbottom != null) {
      _result.blockbottom = blockbottom;
    }
    if (blockcolorful != null) {
      _result.blockcolorful = blockcolorful;
    }
    if (blockrepeat != null) {
      _result.blockrepeat = blockrepeat;
    }
    if (blockspecial != null) {
      _result.blockspecial = blockspecial;
    }
    if (opacity != null) {
      _result.opacity = opacity;
    }
    if (scalingfactor != null) {
      _result.scalingfactor = scalingfactor;
    }
    if (domain != null) {
      _result.domain = domain;
    }
    if (speed != null) {
      _result.speed = speed;
    }
    if (enableblocklist != null) {
      _result.enableblocklist = enableblocklist;
    }
    if (inlinePlayerDanmakuSwitch != null) {
      _result.inlinePlayerDanmakuSwitch = inlinePlayerDanmakuSwitch;
    }
    if (seniorModeSwitch != null) {
      _result.seniorModeSwitch = seniorModeSwitch;
    }
    if (aiRecommendedLevelV2 != null) {
      _result.aiRecommendedLevelV2 = aiRecommendedLevelV2;
    }
    return _result;
  }
  factory DmPlayerConfigReq.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DmPlayerConfigReq.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DmPlayerConfigReq clone() => DmPlayerConfigReq()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DmPlayerConfigReq copyWith(void Function(DmPlayerConfigReq) updates) =>
      super.copyWith((message) => updates(message as DmPlayerConfigReq))
          as DmPlayerConfigReq; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DmPlayerConfigReq create() => DmPlayerConfigReq._();
  DmPlayerConfigReq createEmptyInstance() => create();
  static $pb.PbList<DmPlayerConfigReq> createRepeated() =>
      $pb.PbList<DmPlayerConfigReq>();
  @$core.pragma('dart2js:noInline')
  static DmPlayerConfigReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmPlayerConfigReq>(create);
  static DmPlayerConfigReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ts => $_getI64(0);
  @$pb.TagNumber(1)
  set ts($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTs() => $_has(0);
  @$pb.TagNumber(1)
  void clearTs() => clearField(1);

  @$pb.TagNumber(2)
  PlayerDanmakuSwitch get switch_2 => $_getN(1);
  @$pb.TagNumber(2)
  set switch_2(PlayerDanmakuSwitch v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSwitch_2() => $_has(1);
  @$pb.TagNumber(2)
  void clearSwitch_2() => clearField(2);
  @$pb.TagNumber(2)
  PlayerDanmakuSwitch ensureSwitch_2() => $_ensure(1);

  @$pb.TagNumber(3)
  PlayerDanmakuSwitchSave get switchSave => $_getN(2);
  @$pb.TagNumber(3)
  set switchSave(PlayerDanmakuSwitchSave v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSwitchSave() => $_has(2);
  @$pb.TagNumber(3)
  void clearSwitchSave() => clearField(3);
  @$pb.TagNumber(3)
  PlayerDanmakuSwitchSave ensureSwitchSave() => $_ensure(2);

  @$pb.TagNumber(4)
  PlayerDanmakuUseDefaultConfig get useDefaultConfig => $_getN(3);
  @$pb.TagNumber(4)
  set useDefaultConfig(PlayerDanmakuUseDefaultConfig v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasUseDefaultConfig() => $_has(3);
  @$pb.TagNumber(4)
  void clearUseDefaultConfig() => clearField(4);
  @$pb.TagNumber(4)
  PlayerDanmakuUseDefaultConfig ensureUseDefaultConfig() => $_ensure(3);

  @$pb.TagNumber(5)
  PlayerDanmakuAiRecommendedSwitch get aiRecommendedSwitch => $_getN(4);
  @$pb.TagNumber(5)
  set aiRecommendedSwitch(PlayerDanmakuAiRecommendedSwitch v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasAiRecommendedSwitch() => $_has(4);
  @$pb.TagNumber(5)
  void clearAiRecommendedSwitch() => clearField(5);
  @$pb.TagNumber(5)
  PlayerDanmakuAiRecommendedSwitch ensureAiRecommendedSwitch() => $_ensure(4);

  @$pb.TagNumber(6)
  PlayerDanmakuAiRecommendedLevel get aiRecommendedLevel => $_getN(5);
  @$pb.TagNumber(6)
  set aiRecommendedLevel(PlayerDanmakuAiRecommendedLevel v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasAiRecommendedLevel() => $_has(5);
  @$pb.TagNumber(6)
  void clearAiRecommendedLevel() => clearField(6);
  @$pb.TagNumber(6)
  PlayerDanmakuAiRecommendedLevel ensureAiRecommendedLevel() => $_ensure(5);

  @$pb.TagNumber(7)
  PlayerDanmakuBlocktop get blocktop => $_getN(6);
  @$pb.TagNumber(7)
  set blocktop(PlayerDanmakuBlocktop v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasBlocktop() => $_has(6);
  @$pb.TagNumber(7)
  void clearBlocktop() => clearField(7);
  @$pb.TagNumber(7)
  PlayerDanmakuBlocktop ensureBlocktop() => $_ensure(6);

  @$pb.TagNumber(8)
  PlayerDanmakuBlockscroll get blockscroll => $_getN(7);
  @$pb.TagNumber(8)
  set blockscroll(PlayerDanmakuBlockscroll v) {
    setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasBlockscroll() => $_has(7);
  @$pb.TagNumber(8)
  void clearBlockscroll() => clearField(8);
  @$pb.TagNumber(8)
  PlayerDanmakuBlockscroll ensureBlockscroll() => $_ensure(7);

  @$pb.TagNumber(9)
  PlayerDanmakuBlockbottom get blockbottom => $_getN(8);
  @$pb.TagNumber(9)
  set blockbottom(PlayerDanmakuBlockbottom v) {
    setField(9, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasBlockbottom() => $_has(8);
  @$pb.TagNumber(9)
  void clearBlockbottom() => clearField(9);
  @$pb.TagNumber(9)
  PlayerDanmakuBlockbottom ensureBlockbottom() => $_ensure(8);

  @$pb.TagNumber(10)
  PlayerDanmakuBlockcolorful get blockcolorful => $_getN(9);
  @$pb.TagNumber(10)
  set blockcolorful(PlayerDanmakuBlockcolorful v) {
    setField(10, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasBlockcolorful() => $_has(9);
  @$pb.TagNumber(10)
  void clearBlockcolorful() => clearField(10);
  @$pb.TagNumber(10)
  PlayerDanmakuBlockcolorful ensureBlockcolorful() => $_ensure(9);

  @$pb.TagNumber(11)
  PlayerDanmakuBlockrepeat get blockrepeat => $_getN(10);
  @$pb.TagNumber(11)
  set blockrepeat(PlayerDanmakuBlockrepeat v) {
    setField(11, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasBlockrepeat() => $_has(10);
  @$pb.TagNumber(11)
  void clearBlockrepeat() => clearField(11);
  @$pb.TagNumber(11)
  PlayerDanmakuBlockrepeat ensureBlockrepeat() => $_ensure(10);

  @$pb.TagNumber(12)
  PlayerDanmakuBlockspecial get blockspecial => $_getN(11);
  @$pb.TagNumber(12)
  set blockspecial(PlayerDanmakuBlockspecial v) {
    setField(12, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasBlockspecial() => $_has(11);
  @$pb.TagNumber(12)
  void clearBlockspecial() => clearField(12);
  @$pb.TagNumber(12)
  PlayerDanmakuBlockspecial ensureBlockspecial() => $_ensure(11);

  @$pb.TagNumber(13)
  PlayerDanmakuOpacity get opacity => $_getN(12);
  @$pb.TagNumber(13)
  set opacity(PlayerDanmakuOpacity v) {
    setField(13, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasOpacity() => $_has(12);
  @$pb.TagNumber(13)
  void clearOpacity() => clearField(13);
  @$pb.TagNumber(13)
  PlayerDanmakuOpacity ensureOpacity() => $_ensure(12);

  @$pb.TagNumber(14)
  PlayerDanmakuScalingfactor get scalingfactor => $_getN(13);
  @$pb.TagNumber(14)
  set scalingfactor(PlayerDanmakuScalingfactor v) {
    setField(14, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasScalingfactor() => $_has(13);
  @$pb.TagNumber(14)
  void clearScalingfactor() => clearField(14);
  @$pb.TagNumber(14)
  PlayerDanmakuScalingfactor ensureScalingfactor() => $_ensure(13);

  @$pb.TagNumber(15)
  PlayerDanmakuDomain get domain => $_getN(14);
  @$pb.TagNumber(15)
  set domain(PlayerDanmakuDomain v) {
    setField(15, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasDomain() => $_has(14);
  @$pb.TagNumber(15)
  void clearDomain() => clearField(15);
  @$pb.TagNumber(15)
  PlayerDanmakuDomain ensureDomain() => $_ensure(14);

  @$pb.TagNumber(16)
  PlayerDanmakuSpeed get speed => $_getN(15);
  @$pb.TagNumber(16)
  set speed(PlayerDanmakuSpeed v) {
    setField(16, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasSpeed() => $_has(15);
  @$pb.TagNumber(16)
  void clearSpeed() => clearField(16);
  @$pb.TagNumber(16)
  PlayerDanmakuSpeed ensureSpeed() => $_ensure(15);

  @$pb.TagNumber(17)
  PlayerDanmakuEnableblocklist get enableblocklist => $_getN(16);
  @$pb.TagNumber(17)
  set enableblocklist(PlayerDanmakuEnableblocklist v) {
    setField(17, v);
  }

  @$pb.TagNumber(17)
  $core.bool hasEnableblocklist() => $_has(16);
  @$pb.TagNumber(17)
  void clearEnableblocklist() => clearField(17);
  @$pb.TagNumber(17)
  PlayerDanmakuEnableblocklist ensureEnableblocklist() => $_ensure(16);

  @$pb.TagNumber(18)
  InlinePlayerDanmakuSwitch get inlinePlayerDanmakuSwitch => $_getN(17);
  @$pb.TagNumber(18)
  set inlinePlayerDanmakuSwitch(InlinePlayerDanmakuSwitch v) {
    setField(18, v);
  }

  @$pb.TagNumber(18)
  $core.bool hasInlinePlayerDanmakuSwitch() => $_has(17);
  @$pb.TagNumber(18)
  void clearInlinePlayerDanmakuSwitch() => clearField(18);
  @$pb.TagNumber(18)
  InlinePlayerDanmakuSwitch ensureInlinePlayerDanmakuSwitch() => $_ensure(17);

  @$pb.TagNumber(19)
  PlayerDanmakuSeniorModeSwitch get seniorModeSwitch => $_getN(18);
  @$pb.TagNumber(19)
  set seniorModeSwitch(PlayerDanmakuSeniorModeSwitch v) {
    setField(19, v);
  }

  @$pb.TagNumber(19)
  $core.bool hasSeniorModeSwitch() => $_has(18);
  @$pb.TagNumber(19)
  void clearSeniorModeSwitch() => clearField(19);
  @$pb.TagNumber(19)
  PlayerDanmakuSeniorModeSwitch ensureSeniorModeSwitch() => $_ensure(18);

  @$pb.TagNumber(20)
  PlayerDanmakuAiRecommendedLevelV2 get aiRecommendedLevelV2 => $_getN(19);
  @$pb.TagNumber(20)
  set aiRecommendedLevelV2(PlayerDanmakuAiRecommendedLevelV2 v) {
    setField(20, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasAiRecommendedLevelV2() => $_has(19);
  @$pb.TagNumber(20)
  void clearAiRecommendedLevelV2() => clearField(20);
  @$pb.TagNumber(20)
  PlayerDanmakuAiRecommendedLevelV2 ensureAiRecommendedLevelV2() =>
      $_ensure(19);
}

class DmSegConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DmSegConfig',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pageSize')
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'total')
    ..hasRequiredFields = false;

  DmSegConfig._() : super();
  factory DmSegConfig({
    $fixnum.Int64? pageSize,
    $fixnum.Int64? total,
  }) {
    final _result = create();
    if (pageSize != null) {
      _result.pageSize = pageSize;
    }
    if (total != null) {
      _result.total = total;
    }
    return _result;
  }
  factory DmSegConfig.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DmSegConfig.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DmSegConfig clone() => DmSegConfig()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DmSegConfig copyWith(void Function(DmSegConfig) updates) =>
      super.copyWith((message) => updates(message as DmSegConfig))
          as DmSegConfig; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DmSegConfig create() => DmSegConfig._();
  DmSegConfig createEmptyInstance() => create();
  static $pb.PbList<DmSegConfig> createRepeated() => $pb.PbList<DmSegConfig>();
  @$core.pragma('dart2js:noInline')
  static DmSegConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmSegConfig>(create);
  static DmSegConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get pageSize => $_getI64(0);
  @$pb.TagNumber(1)
  set pageSize($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => clearField(2);
}

class DmSegMobileReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DmSegMobileReply',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pc<DanmakuElem>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'elems',
        $pb.PbFieldType.PM,
        subBuilder: DanmakuElem.create)
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'state',
        $pb.PbFieldType.O3)
    ..aOM<DanmakuAIFlag>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'aiFlag',
        subBuilder: DanmakuAIFlag.create)
    ..hasRequiredFields = false;

  DmSegMobileReply._() : super();
  factory DmSegMobileReply({
    $core.Iterable<DanmakuElem>? elems,
    $core.int? state,
    DanmakuAIFlag? aiFlag,
  }) {
    final _result = create();
    if (elems != null) {
      _result.elems.addAll(elems);
    }
    if (state != null) {
      _result.state = state;
    }
    if (aiFlag != null) {
      _result.aiFlag = aiFlag;
    }
    return _result;
  }
  factory DmSegMobileReply.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DmSegMobileReply.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DmSegMobileReply clone() => DmSegMobileReply()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DmSegMobileReply copyWith(void Function(DmSegMobileReply) updates) =>
      super.copyWith((message) => updates(message as DmSegMobileReply))
          as DmSegMobileReply; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DmSegMobileReply create() => DmSegMobileReply._();
  DmSegMobileReply createEmptyInstance() => create();
  static $pb.PbList<DmSegMobileReply> createRepeated() =>
      $pb.PbList<DmSegMobileReply>();
  @$core.pragma('dart2js:noInline')
  static DmSegMobileReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmSegMobileReply>(create);
  static DmSegMobileReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<DanmakuElem> get elems => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get state => $_getIZ(1);
  @$pb.TagNumber(2)
  set state($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => clearField(2);

  @$pb.TagNumber(3)
  DanmakuAIFlag get aiFlag => $_getN(2);
  @$pb.TagNumber(3)
  set aiFlag(DanmakuAIFlag v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasAiFlag() => $_has(2);
  @$pb.TagNumber(3)
  void clearAiFlag() => clearField(3);
  @$pb.TagNumber(3)
  DanmakuAIFlag ensureAiFlag() => $_ensure(2);
}

class DmSegMobileReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DmSegMobileReq',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pid')
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'oid')
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'type',
        $pb.PbFieldType.O3)
    ..aInt64(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'segmentIndex')
    ..a<$core.int>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'teenagersMode',
        $pb.PbFieldType.O3)
    ..aInt64(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'ps')
    ..aInt64(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pe')
    ..a<$core.int>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pullMode',
        $pb.PbFieldType.O3)
    ..a<$core.int>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'fromScene',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  DmSegMobileReq._() : super();
  factory DmSegMobileReq({
    $fixnum.Int64? pid,
    $fixnum.Int64? oid,
    $core.int? type,
    $fixnum.Int64? segmentIndex,
    $core.int? teenagersMode,
    $fixnum.Int64? ps,
    $fixnum.Int64? pe,
    $core.int? pullMode,
    $core.int? fromScene,
  }) {
    final _result = create();
    if (pid != null) {
      _result.pid = pid;
    }
    if (oid != null) {
      _result.oid = oid;
    }
    if (type != null) {
      _result.type = type;
    }
    if (segmentIndex != null) {
      _result.segmentIndex = segmentIndex;
    }
    if (teenagersMode != null) {
      _result.teenagersMode = teenagersMode;
    }
    if (ps != null) {
      _result.ps = ps;
    }
    if (pe != null) {
      _result.pe = pe;
    }
    if (pullMode != null) {
      _result.pullMode = pullMode;
    }
    if (fromScene != null) {
      _result.fromScene = fromScene;
    }
    return _result;
  }
  factory DmSegMobileReq.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DmSegMobileReq.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DmSegMobileReq clone() => DmSegMobileReq()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DmSegMobileReq copyWith(void Function(DmSegMobileReq) updates) =>
      super.copyWith((message) => updates(message as DmSegMobileReq))
          as DmSegMobileReq; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DmSegMobileReq create() => DmSegMobileReq._();
  DmSegMobileReq createEmptyInstance() => create();
  static $pb.PbList<DmSegMobileReq> createRepeated() =>
      $pb.PbList<DmSegMobileReq>();
  @$core.pragma('dart2js:noInline')
  static DmSegMobileReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmSegMobileReq>(create);
  static DmSegMobileReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get pid => $_getI64(0);
  @$pb.TagNumber(1)
  set pid($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPid() => $_has(0);
  @$pb.TagNumber(1)
  void clearPid() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get oid => $_getI64(1);
  @$pb.TagNumber(2)
  set oid($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get type => $_getIZ(2);
  @$pb.TagNumber(3)
  set type($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get segmentIndex => $_getI64(3);
  @$pb.TagNumber(4)
  set segmentIndex($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSegmentIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearSegmentIndex() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get teenagersMode => $_getIZ(4);
  @$pb.TagNumber(5)
  set teenagersMode($core.int v) {
    $_setSignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasTeenagersMode() => $_has(4);
  @$pb.TagNumber(5)
  void clearTeenagersMode() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get ps => $_getI64(5);
  @$pb.TagNumber(6)
  set ps($fixnum.Int64 v) {
    $_setInt64(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasPs() => $_has(5);
  @$pb.TagNumber(6)
  void clearPs() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get pe => $_getI64(6);
  @$pb.TagNumber(7)
  set pe($fixnum.Int64 v) {
    $_setInt64(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasPe() => $_has(6);
  @$pb.TagNumber(7)
  void clearPe() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get pullMode => $_getIZ(7);
  @$pb.TagNumber(8)
  set pullMode($core.int v) {
    $_setSignedInt32(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasPullMode() => $_has(7);
  @$pb.TagNumber(8)
  void clearPullMode() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get fromScene => $_getIZ(8);
  @$pb.TagNumber(9)
  set fromScene($core.int v) {
    $_setSignedInt32(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasFromScene() => $_has(8);
  @$pb.TagNumber(9)
  void clearFromScene() => clearField(9);
}

class DmSegOttReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DmSegOttReply',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'closed')
    ..pc<DanmakuElem>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'elems',
        $pb.PbFieldType.PM,
        subBuilder: DanmakuElem.create)
    ..hasRequiredFields = false;

  DmSegOttReply._() : super();
  factory DmSegOttReply({
    $core.bool? closed,
    $core.Iterable<DanmakuElem>? elems,
  }) {
    final _result = create();
    if (closed != null) {
      _result.closed = closed;
    }
    if (elems != null) {
      _result.elems.addAll(elems);
    }
    return _result;
  }
  factory DmSegOttReply.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DmSegOttReply.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DmSegOttReply clone() => DmSegOttReply()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DmSegOttReply copyWith(void Function(DmSegOttReply) updates) =>
      super.copyWith((message) => updates(message as DmSegOttReply))
          as DmSegOttReply; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DmSegOttReply create() => DmSegOttReply._();
  DmSegOttReply createEmptyInstance() => create();
  static $pb.PbList<DmSegOttReply> createRepeated() =>
      $pb.PbList<DmSegOttReply>();
  @$core.pragma('dart2js:noInline')
  static DmSegOttReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmSegOttReply>(create);
  static DmSegOttReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get closed => $_getBF(0);
  @$pb.TagNumber(1)
  set closed($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasClosed() => $_has(0);
  @$pb.TagNumber(1)
  void clearClosed() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<DanmakuElem> get elems => $_getList(1);
}

class DmSegOttReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DmSegOttReq',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pid')
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'oid')
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'type',
        $pb.PbFieldType.O3)
    ..aInt64(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'segmentIndex')
    ..hasRequiredFields = false;

  DmSegOttReq._() : super();
  factory DmSegOttReq({
    $fixnum.Int64? pid,
    $fixnum.Int64? oid,
    $core.int? type,
    $fixnum.Int64? segmentIndex,
  }) {
    final _result = create();
    if (pid != null) {
      _result.pid = pid;
    }
    if (oid != null) {
      _result.oid = oid;
    }
    if (type != null) {
      _result.type = type;
    }
    if (segmentIndex != null) {
      _result.segmentIndex = segmentIndex;
    }
    return _result;
  }
  factory DmSegOttReq.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DmSegOttReq.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DmSegOttReq clone() => DmSegOttReq()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DmSegOttReq copyWith(void Function(DmSegOttReq) updates) =>
      super.copyWith((message) => updates(message as DmSegOttReq))
          as DmSegOttReq; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DmSegOttReq create() => DmSegOttReq._();
  DmSegOttReq createEmptyInstance() => create();
  static $pb.PbList<DmSegOttReq> createRepeated() => $pb.PbList<DmSegOttReq>();
  @$core.pragma('dart2js:noInline')
  static DmSegOttReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmSegOttReq>(create);
  static DmSegOttReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get pid => $_getI64(0);
  @$pb.TagNumber(1)
  set pid($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPid() => $_has(0);
  @$pb.TagNumber(1)
  void clearPid() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get oid => $_getI64(1);
  @$pb.TagNumber(2)
  set oid($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get type => $_getIZ(2);
  @$pb.TagNumber(3)
  set type($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get segmentIndex => $_getI64(3);
  @$pb.TagNumber(4)
  set segmentIndex($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSegmentIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearSegmentIndex() => clearField(4);
}

class DmSegSDKReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DmSegSDKReply',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'closed')
    ..pc<DanmakuElem>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'elems',
        $pb.PbFieldType.PM,
        subBuilder: DanmakuElem.create)
    ..hasRequiredFields = false;

  DmSegSDKReply._() : super();
  factory DmSegSDKReply({
    $core.bool? closed,
    $core.Iterable<DanmakuElem>? elems,
  }) {
    final _result = create();
    if (closed != null) {
      _result.closed = closed;
    }
    if (elems != null) {
      _result.elems.addAll(elems);
    }
    return _result;
  }
  factory DmSegSDKReply.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DmSegSDKReply.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DmSegSDKReply clone() => DmSegSDKReply()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DmSegSDKReply copyWith(void Function(DmSegSDKReply) updates) =>
      super.copyWith((message) => updates(message as DmSegSDKReply))
          as DmSegSDKReply; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DmSegSDKReply create() => DmSegSDKReply._();
  DmSegSDKReply createEmptyInstance() => create();
  static $pb.PbList<DmSegSDKReply> createRepeated() =>
      $pb.PbList<DmSegSDKReply>();
  @$core.pragma('dart2js:noInline')
  static DmSegSDKReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmSegSDKReply>(create);
  static DmSegSDKReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get closed => $_getBF(0);
  @$pb.TagNumber(1)
  set closed($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasClosed() => $_has(0);
  @$pb.TagNumber(1)
  void clearClosed() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<DanmakuElem> get elems => $_getList(1);
}

class DmSegSDKReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DmSegSDKReq',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pid')
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'oid')
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'type',
        $pb.PbFieldType.O3)
    ..aInt64(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'segmentIndex')
    ..hasRequiredFields = false;

  DmSegSDKReq._() : super();
  factory DmSegSDKReq({
    $fixnum.Int64? pid,
    $fixnum.Int64? oid,
    $core.int? type,
    $fixnum.Int64? segmentIndex,
  }) {
    final _result = create();
    if (pid != null) {
      _result.pid = pid;
    }
    if (oid != null) {
      _result.oid = oid;
    }
    if (type != null) {
      _result.type = type;
    }
    if (segmentIndex != null) {
      _result.segmentIndex = segmentIndex;
    }
    return _result;
  }
  factory DmSegSDKReq.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DmSegSDKReq.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DmSegSDKReq clone() => DmSegSDKReq()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DmSegSDKReq copyWith(void Function(DmSegSDKReq) updates) =>
      super.copyWith((message) => updates(message as DmSegSDKReq))
          as DmSegSDKReq; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DmSegSDKReq create() => DmSegSDKReq._();
  DmSegSDKReq createEmptyInstance() => create();
  static $pb.PbList<DmSegSDKReq> createRepeated() => $pb.PbList<DmSegSDKReq>();
  @$core.pragma('dart2js:noInline')
  static DmSegSDKReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmSegSDKReq>(create);
  static DmSegSDKReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get pid => $_getI64(0);
  @$pb.TagNumber(1)
  set pid($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPid() => $_has(0);
  @$pb.TagNumber(1)
  void clearPid() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get oid => $_getI64(1);
  @$pb.TagNumber(2)
  set oid($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get type => $_getIZ(2);
  @$pb.TagNumber(3)
  set type($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get segmentIndex => $_getI64(3);
  @$pb.TagNumber(4)
  set segmentIndex($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSegmentIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearSegmentIndex() => clearField(4);
}

class DmViewReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DmViewReply',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'closed')
    ..aOM<VideoMask>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'mask',
        subBuilder: VideoMask.create)
    ..aOM<VideoSubtitle>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'subtitle',
        subBuilder: VideoSubtitle.create)
    ..pPS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'specialDms')
    ..aOM<DanmakuFlagConfig>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'aiFlag',
        subBuilder: DanmakuFlagConfig.create)
    ..aOM<DanmuPlayerViewConfig>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerConfig',
        subBuilder: DanmuPlayerViewConfig.create)
    ..a<$core.int>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'sendBoxStyle',
        $pb.PbFieldType.O3)
    ..aOB(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'allow')
    ..aOS(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'checkBox')
    ..aOS(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'checkBoxShowMsg')
    ..aOS(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'textPlaceholder')
    ..aOS(
        12,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'inputPlaceholder')
    ..pPS(
        13,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'reportFilterContent')
    ..aOM<ExpoReport>(
        14,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'expoReport',
        subBuilder: ExpoReport.create)
    ..aOM<BuzzwordConfig>(
        15,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'buzzwordConfig',
        subBuilder: BuzzwordConfig.create)
    ..pc<Expressions>(
        16,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'expressions',
        $pb.PbFieldType.PM,
        subBuilder: Expressions.create)
    ..pc<PostPanel>(
        17,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'postPanel',
        $pb.PbFieldType.PM,
        subBuilder: PostPanel.create)
    ..pPS(
        18,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'activityMeta')
    ..pc<PostPanelV2>(
        19,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'postPanel2',
        $pb.PbFieldType.PM,
        subBuilder: PostPanelV2.create)
    ..hasRequiredFields = false;

  DmViewReply._() : super();
  factory DmViewReply({
    $core.bool? closed,
    VideoMask? mask,
    VideoSubtitle? subtitle,
    $core.Iterable<$core.String>? specialDms,
    DanmakuFlagConfig? aiFlag,
    DanmuPlayerViewConfig? playerConfig,
    $core.int? sendBoxStyle,
    $core.bool? allow,
    $core.String? checkBox,
    $core.String? checkBoxShowMsg,
    $core.String? textPlaceholder,
    $core.String? inputPlaceholder,
    $core.Iterable<$core.String>? reportFilterContent,
    ExpoReport? expoReport,
    BuzzwordConfig? buzzwordConfig,
    $core.Iterable<Expressions>? expressions,
    $core.Iterable<PostPanel>? postPanel,
    $core.Iterable<$core.String>? activityMeta,
    $core.Iterable<PostPanelV2>? postPanel2,
  }) {
    final _result = create();
    if (closed != null) {
      _result.closed = closed;
    }
    if (mask != null) {
      _result.mask = mask;
    }
    if (subtitle != null) {
      _result.subtitle = subtitle;
    }
    if (specialDms != null) {
      _result.specialDms.addAll(specialDms);
    }
    if (aiFlag != null) {
      _result.aiFlag = aiFlag;
    }
    if (playerConfig != null) {
      _result.playerConfig = playerConfig;
    }
    if (sendBoxStyle != null) {
      _result.sendBoxStyle = sendBoxStyle;
    }
    if (allow != null) {
      _result.allow = allow;
    }
    if (checkBox != null) {
      _result.checkBox = checkBox;
    }
    if (checkBoxShowMsg != null) {
      _result.checkBoxShowMsg = checkBoxShowMsg;
    }
    if (textPlaceholder != null) {
      _result.textPlaceholder = textPlaceholder;
    }
    if (inputPlaceholder != null) {
      _result.inputPlaceholder = inputPlaceholder;
    }
    if (reportFilterContent != null) {
      _result.reportFilterContent.addAll(reportFilterContent);
    }
    if (expoReport != null) {
      _result.expoReport = expoReport;
    }
    if (buzzwordConfig != null) {
      _result.buzzwordConfig = buzzwordConfig;
    }
    if (expressions != null) {
      _result.expressions.addAll(expressions);
    }
    if (postPanel != null) {
      _result.postPanel.addAll(postPanel);
    }
    if (activityMeta != null) {
      _result.activityMeta.addAll(activityMeta);
    }
    if (postPanel2 != null) {
      _result.postPanel2.addAll(postPanel2);
    }
    return _result;
  }
  factory DmViewReply.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DmViewReply.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DmViewReply clone() => DmViewReply()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DmViewReply copyWith(void Function(DmViewReply) updates) =>
      super.copyWith((message) => updates(message as DmViewReply))
          as DmViewReply; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DmViewReply create() => DmViewReply._();
  DmViewReply createEmptyInstance() => create();
  static $pb.PbList<DmViewReply> createRepeated() => $pb.PbList<DmViewReply>();
  @$core.pragma('dart2js:noInline')
  static DmViewReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmViewReply>(create);
  static DmViewReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get closed => $_getBF(0);
  @$pb.TagNumber(1)
  set closed($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasClosed() => $_has(0);
  @$pb.TagNumber(1)
  void clearClosed() => clearField(1);

  @$pb.TagNumber(2)
  VideoMask get mask => $_getN(1);
  @$pb.TagNumber(2)
  set mask(VideoMask v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMask() => $_has(1);
  @$pb.TagNumber(2)
  void clearMask() => clearField(2);
  @$pb.TagNumber(2)
  VideoMask ensureMask() => $_ensure(1);

  @$pb.TagNumber(3)
  VideoSubtitle get subtitle => $_getN(2);
  @$pb.TagNumber(3)
  set subtitle(VideoSubtitle v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSubtitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubtitle() => clearField(3);
  @$pb.TagNumber(3)
  VideoSubtitle ensureSubtitle() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.List<$core.String> get specialDms => $_getList(3);

  @$pb.TagNumber(5)
  DanmakuFlagConfig get aiFlag => $_getN(4);
  @$pb.TagNumber(5)
  set aiFlag(DanmakuFlagConfig v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasAiFlag() => $_has(4);
  @$pb.TagNumber(5)
  void clearAiFlag() => clearField(5);
  @$pb.TagNumber(5)
  DanmakuFlagConfig ensureAiFlag() => $_ensure(4);

  @$pb.TagNumber(6)
  DanmuPlayerViewConfig get playerConfig => $_getN(5);
  @$pb.TagNumber(6)
  set playerConfig(DanmuPlayerViewConfig v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasPlayerConfig() => $_has(5);
  @$pb.TagNumber(6)
  void clearPlayerConfig() => clearField(6);
  @$pb.TagNumber(6)
  DanmuPlayerViewConfig ensurePlayerConfig() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.int get sendBoxStyle => $_getIZ(6);
  @$pb.TagNumber(7)
  set sendBoxStyle($core.int v) {
    $_setSignedInt32(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasSendBoxStyle() => $_has(6);
  @$pb.TagNumber(7)
  void clearSendBoxStyle() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get allow => $_getBF(7);
  @$pb.TagNumber(8)
  set allow($core.bool v) {
    $_setBool(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasAllow() => $_has(7);
  @$pb.TagNumber(8)
  void clearAllow() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get checkBox => $_getSZ(8);
  @$pb.TagNumber(9)
  set checkBox($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasCheckBox() => $_has(8);
  @$pb.TagNumber(9)
  void clearCheckBox() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get checkBoxShowMsg => $_getSZ(9);
  @$pb.TagNumber(10)
  set checkBoxShowMsg($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasCheckBoxShowMsg() => $_has(9);
  @$pb.TagNumber(10)
  void clearCheckBoxShowMsg() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get textPlaceholder => $_getSZ(10);
  @$pb.TagNumber(11)
  set textPlaceholder($core.String v) {
    $_setString(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasTextPlaceholder() => $_has(10);
  @$pb.TagNumber(11)
  void clearTextPlaceholder() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get inputPlaceholder => $_getSZ(11);
  @$pb.TagNumber(12)
  set inputPlaceholder($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasInputPlaceholder() => $_has(11);
  @$pb.TagNumber(12)
  void clearInputPlaceholder() => clearField(12);

  @$pb.TagNumber(13)
  $core.List<$core.String> get reportFilterContent => $_getList(12);

  @$pb.TagNumber(14)
  ExpoReport get expoReport => $_getN(13);
  @$pb.TagNumber(14)
  set expoReport(ExpoReport v) {
    setField(14, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasExpoReport() => $_has(13);
  @$pb.TagNumber(14)
  void clearExpoReport() => clearField(14);
  @$pb.TagNumber(14)
  ExpoReport ensureExpoReport() => $_ensure(13);

  @$pb.TagNumber(15)
  BuzzwordConfig get buzzwordConfig => $_getN(14);
  @$pb.TagNumber(15)
  set buzzwordConfig(BuzzwordConfig v) {
    setField(15, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasBuzzwordConfig() => $_has(14);
  @$pb.TagNumber(15)
  void clearBuzzwordConfig() => clearField(15);
  @$pb.TagNumber(15)
  BuzzwordConfig ensureBuzzwordConfig() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.List<Expressions> get expressions => $_getList(15);

  @$pb.TagNumber(17)
  $core.List<PostPanel> get postPanel => $_getList(16);

  @$pb.TagNumber(18)
  $core.List<$core.String> get activityMeta => $_getList(17);

  @$pb.TagNumber(19)
  $core.List<PostPanelV2> get postPanel2 => $_getList(18);
}

class DmViewReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DmViewReq',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pid')
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'oid')
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'type',
        $pb.PbFieldType.O3)
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'spmid')
    ..a<$core.int>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'isHardBoot',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  DmViewReq._() : super();
  factory DmViewReq({
    $fixnum.Int64? pid,
    $fixnum.Int64? oid,
    $core.int? type,
    $core.String? spmid,
    $core.int? isHardBoot,
  }) {
    final _result = create();
    if (pid != null) {
      _result.pid = pid;
    }
    if (oid != null) {
      _result.oid = oid;
    }
    if (type != null) {
      _result.type = type;
    }
    if (spmid != null) {
      _result.spmid = spmid;
    }
    if (isHardBoot != null) {
      _result.isHardBoot = isHardBoot;
    }
    return _result;
  }
  factory DmViewReq.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DmViewReq.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DmViewReq clone() => DmViewReq()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DmViewReq copyWith(void Function(DmViewReq) updates) =>
      super.copyWith((message) => updates(message as DmViewReq))
          as DmViewReq; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DmViewReq create() => DmViewReq._();
  DmViewReq createEmptyInstance() => create();
  static $pb.PbList<DmViewReq> createRepeated() => $pb.PbList<DmViewReq>();
  @$core.pragma('dart2js:noInline')
  static DmViewReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DmViewReq>(create);
  static DmViewReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get pid => $_getI64(0);
  @$pb.TagNumber(1)
  set pid($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPid() => $_has(0);
  @$pb.TagNumber(1)
  void clearPid() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get oid => $_getI64(1);
  @$pb.TagNumber(2)
  set oid($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get type => $_getIZ(2);
  @$pb.TagNumber(3)
  set type($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get spmid => $_getSZ(3);
  @$pb.TagNumber(4)
  set spmid($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSpmid() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpmid() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get isHardBoot => $_getIZ(4);
  @$pb.TagNumber(5)
  set isHardBoot($core.int v) {
    $_setSignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasIsHardBoot() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsHardBoot() => clearField(5);
}

class DmWebViewReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DmWebViewReply',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'state',
        $pb.PbFieldType.O3)
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'text')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'textSide')
    ..aOM<DmSegConfig>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'dmSge',
        subBuilder: DmSegConfig.create)
    ..aOM<DanmakuFlagConfig>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'flag',
        subBuilder: DanmakuFlagConfig.create)
    ..pPS(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'specialDms')
    ..aOB(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'checkBox')
    ..aInt64(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'count')
    ..pc<CommandDm>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'commandDms',
        $pb.PbFieldType.PM,
        protoName: 'commandDms',
        subBuilder: CommandDm.create)
    ..aOM<DanmuWebPlayerConfig>(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerConfig',
        subBuilder: DanmuWebPlayerConfig.create)
    ..pPS(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'reportFilterContent')
    ..pc<Expressions>(
        12,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'expressions',
        $pb.PbFieldType.PM,
        subBuilder: Expressions.create)
    ..pc<PostPanel>(
        13,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'postPanel',
        $pb.PbFieldType.PM,
        subBuilder: PostPanel.create)
    ..pPS(
        14,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'activityMeta')
    ..hasRequiredFields = false;

  DmWebViewReply._() : super();
  factory DmWebViewReply({
    $core.int? state,
    $core.String? text,
    $core.String? textSide,
    DmSegConfig? dmSge,
    DanmakuFlagConfig? flag,
    $core.Iterable<$core.String>? specialDms,
    $core.bool? checkBox,
    $fixnum.Int64? count,
    $core.Iterable<CommandDm>? commandDms,
    DanmuWebPlayerConfig? playerConfig,
    $core.Iterable<$core.String>? reportFilterContent,
    $core.Iterable<Expressions>? expressions,
    $core.Iterable<PostPanel>? postPanel,
    $core.Iterable<$core.String>? activityMeta,
  }) {
    final _result = create();
    if (state != null) {
      _result.state = state;
    }
    if (text != null) {
      _result.text = text;
    }
    if (textSide != null) {
      _result.textSide = textSide;
    }
    if (dmSge != null) {
      _result.dmSge = dmSge;
    }
    if (flag != null) {
      _result.flag = flag;
    }
    if (specialDms != null) {
      _result.specialDms.addAll(specialDms);
    }
    if (checkBox != null) {
      _result.checkBox = checkBox;
    }
    if (count != null) {
      _result.count = count;
    }
    if (commandDms != null) {
      _result.commandDms.addAll(commandDms);
    }
    if (playerConfig != null) {
      _result.playerConfig = playerConfig;
    }
    if (reportFilterContent != null) {
      _result.reportFilterContent.addAll(reportFilterContent);
    }
    if (expressions != null) {
      _result.expressions.addAll(expressions);
    }
    if (postPanel != null) {
      _result.postPanel.addAll(postPanel);
    }
    if (activityMeta != null) {
      _result.activityMeta.addAll(activityMeta);
    }
    return _result;
  }
  factory DmWebViewReply.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DmWebViewReply.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DmWebViewReply clone() => DmWebViewReply()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DmWebViewReply copyWith(void Function(DmWebViewReply) updates) =>
      super.copyWith((message) => updates(message as DmWebViewReply))
          as DmWebViewReply; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DmWebViewReply create() => DmWebViewReply._();
  DmWebViewReply createEmptyInstance() => create();
  static $pb.PbList<DmWebViewReply> createRepeated() =>
      $pb.PbList<DmWebViewReply>();
  @$core.pragma('dart2js:noInline')
  static DmWebViewReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmWebViewReply>(create);
  static DmWebViewReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get state => $_getIZ(0);
  @$pb.TagNumber(1)
  set state($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get textSide => $_getSZ(2);
  @$pb.TagNumber(3)
  set textSide($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTextSide() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextSide() => clearField(3);

  @$pb.TagNumber(4)
  DmSegConfig get dmSge => $_getN(3);
  @$pb.TagNumber(4)
  set dmSge(DmSegConfig v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasDmSge() => $_has(3);
  @$pb.TagNumber(4)
  void clearDmSge() => clearField(4);
  @$pb.TagNumber(4)
  DmSegConfig ensureDmSge() => $_ensure(3);

  @$pb.TagNumber(5)
  DanmakuFlagConfig get flag => $_getN(4);
  @$pb.TagNumber(5)
  set flag(DanmakuFlagConfig v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasFlag() => $_has(4);
  @$pb.TagNumber(5)
  void clearFlag() => clearField(5);
  @$pb.TagNumber(5)
  DanmakuFlagConfig ensureFlag() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.List<$core.String> get specialDms => $_getList(5);

  @$pb.TagNumber(7)
  $core.bool get checkBox => $_getBF(6);
  @$pb.TagNumber(7)
  set checkBox($core.bool v) {
    $_setBool(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasCheckBox() => $_has(6);
  @$pb.TagNumber(7)
  void clearCheckBox() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get count => $_getI64(7);
  @$pb.TagNumber(8)
  set count($fixnum.Int64 v) {
    $_setInt64(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearCount() => clearField(8);

  @$pb.TagNumber(9)
  $core.List<CommandDm> get commandDms => $_getList(8);

  @$pb.TagNumber(10)
  DanmuWebPlayerConfig get playerConfig => $_getN(9);
  @$pb.TagNumber(10)
  set playerConfig(DanmuWebPlayerConfig v) {
    setField(10, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasPlayerConfig() => $_has(9);
  @$pb.TagNumber(10)
  void clearPlayerConfig() => clearField(10);
  @$pb.TagNumber(10)
  DanmuWebPlayerConfig ensurePlayerConfig() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.List<$core.String> get reportFilterContent => $_getList(10);

  @$pb.TagNumber(12)
  $core.List<Expressions> get expressions => $_getList(11);

  @$pb.TagNumber(13)
  $core.List<PostPanel> get postPanel => $_getList(12);

  @$pb.TagNumber(14)
  $core.List<$core.String> get activityMeta => $_getList(13);
}

class ExpoReport extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ExpoReport',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'shouldReportAtEnd')
    ..hasRequiredFields = false;

  ExpoReport._() : super();
  factory ExpoReport({
    $core.bool? shouldReportAtEnd,
  }) {
    final _result = create();
    if (shouldReportAtEnd != null) {
      _result.shouldReportAtEnd = shouldReportAtEnd;
    }
    return _result;
  }
  factory ExpoReport.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ExpoReport.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ExpoReport clone() => ExpoReport()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ExpoReport copyWith(void Function(ExpoReport) updates) =>
      super.copyWith((message) => updates(message as ExpoReport))
          as ExpoReport; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ExpoReport create() => ExpoReport._();
  ExpoReport createEmptyInstance() => create();
  static $pb.PbList<ExpoReport> createRepeated() => $pb.PbList<ExpoReport>();
  @$core.pragma('dart2js:noInline')
  static ExpoReport getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExpoReport>(create);
  static ExpoReport? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get shouldReportAtEnd => $_getBF(0);
  @$pb.TagNumber(1)
  set shouldReportAtEnd($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasShouldReportAtEnd() => $_has(0);
  @$pb.TagNumber(1)
  void clearShouldReportAtEnd() => clearField(1);
}

class Expression extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Expression',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pPS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'keyword')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'url')
    ..pc<Period>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'period',
        $pb.PbFieldType.PM,
        subBuilder: Period.create)
    ..hasRequiredFields = false;

  Expression._() : super();
  factory Expression({
    $core.Iterable<$core.String>? keyword,
    $core.String? url,
    $core.Iterable<Period>? period,
  }) {
    final _result = create();
    if (keyword != null) {
      _result.keyword.addAll(keyword);
    }
    if (url != null) {
      _result.url = url;
    }
    if (period != null) {
      _result.period.addAll(period);
    }
    return _result;
  }
  factory Expression.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Expression.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Expression clone() => Expression()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Expression copyWith(void Function(Expression) updates) =>
      super.copyWith((message) => updates(message as Expression))
          as Expression; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Expression create() => Expression._();
  Expression createEmptyInstance() => create();
  static $pb.PbList<Expression> createRepeated() => $pb.PbList<Expression>();
  @$core.pragma('dart2js:noInline')
  static Expression getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Expression>(create);
  static Expression? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get keyword => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<Period> get period => $_getList(2);
}

class Expressions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Expressions',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pc<Expression>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'data',
        $pb.PbFieldType.PM,
        subBuilder: Expression.create)
    ..hasRequiredFields = false;

  Expressions._() : super();
  factory Expressions({
    $core.Iterable<Expression>? data,
  }) {
    final _result = create();
    if (data != null) {
      _result.data.addAll(data);
    }
    return _result;
  }
  factory Expressions.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Expressions.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Expressions clone() => Expressions()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Expressions copyWith(void Function(Expressions) updates) =>
      super.copyWith((message) => updates(message as Expressions))
          as Expressions; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Expressions create() => Expressions._();
  Expressions createEmptyInstance() => create();
  static $pb.PbList<Expressions> createRepeated() => $pb.PbList<Expressions>();
  @$core.pragma('dart2js:noInline')
  static Expressions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Expressions>(create);
  static Expressions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Expression> get data => $_getList(0);
}

class InlinePlayerDanmakuSwitch extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'InlinePlayerDanmakuSwitch',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value')
    ..hasRequiredFields = false;

  InlinePlayerDanmakuSwitch._() : super();
  factory InlinePlayerDanmakuSwitch({
    $core.bool? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory InlinePlayerDanmakuSwitch.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory InlinePlayerDanmakuSwitch.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  InlinePlayerDanmakuSwitch clone() =>
      InlinePlayerDanmakuSwitch()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  InlinePlayerDanmakuSwitch copyWith(
          void Function(InlinePlayerDanmakuSwitch) updates) =>
      super.copyWith((message) => updates(message as InlinePlayerDanmakuSwitch))
          as InlinePlayerDanmakuSwitch; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static InlinePlayerDanmakuSwitch create() => InlinePlayerDanmakuSwitch._();
  InlinePlayerDanmakuSwitch createEmptyInstance() => create();
  static $pb.PbList<InlinePlayerDanmakuSwitch> createRepeated() =>
      $pb.PbList<InlinePlayerDanmakuSwitch>();
  @$core.pragma('dart2js:noInline')
  static InlinePlayerDanmakuSwitch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InlinePlayerDanmakuSwitch>(create);
  static InlinePlayerDanmakuSwitch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class Label extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Label',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'title')
    ..pPS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'content')
    ..hasRequiredFields = false;

  Label._() : super();
  factory Label({
    $core.String? title,
    $core.Iterable<$core.String>? content,
  }) {
    final _result = create();
    if (title != null) {
      _result.title = title;
    }
    if (content != null) {
      _result.content.addAll(content);
    }
    return _result;
  }
  factory Label.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Label.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Label clone() => Label()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Label copyWith(void Function(Label) updates) =>
      super.copyWith((message) => updates(message as Label))
          as Label; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Label create() => Label._();
  Label createEmptyInstance() => create();
  static $pb.PbList<Label> createRepeated() => $pb.PbList<Label>();
  @$core.pragma('dart2js:noInline')
  static Label getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Label>(create);
  static Label? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get content => $_getList(1);
}

class LabelV2 extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'LabelV2',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'title')
    ..pPS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'content')
    ..aOB(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'exposureOnce')
    ..a<$core.int>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'exposureType',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  LabelV2._() : super();
  factory LabelV2({
    $core.String? title,
    $core.Iterable<$core.String>? content,
    $core.bool? exposureOnce,
    $core.int? exposureType,
  }) {
    final _result = create();
    if (title != null) {
      _result.title = title;
    }
    if (content != null) {
      _result.content.addAll(content);
    }
    if (exposureOnce != null) {
      _result.exposureOnce = exposureOnce;
    }
    if (exposureType != null) {
      _result.exposureType = exposureType;
    }
    return _result;
  }
  factory LabelV2.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory LabelV2.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  LabelV2 clone() => LabelV2()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  LabelV2 copyWith(void Function(LabelV2) updates) =>
      super.copyWith((message) => updates(message as LabelV2))
          as LabelV2; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LabelV2 create() => LabelV2._();
  LabelV2 createEmptyInstance() => create();
  static $pb.PbList<LabelV2> createRepeated() => $pb.PbList<LabelV2>();
  @$core.pragma('dart2js:noInline')
  static LabelV2 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LabelV2>(create);
  static LabelV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get content => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get exposureOnce => $_getBF(2);
  @$pb.TagNumber(3)
  set exposureOnce($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasExposureOnce() => $_has(2);
  @$pb.TagNumber(3)
  void clearExposureOnce() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get exposureType => $_getIZ(3);
  @$pb.TagNumber(4)
  set exposureType($core.int v) {
    $_setSignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasExposureType() => $_has(3);
  @$pb.TagNumber(4)
  void clearExposureType() => clearField(4);
}

class Period extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Period',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'start')
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'end')
    ..hasRequiredFields = false;

  Period._() : super();
  factory Period({
    $fixnum.Int64? start,
    $fixnum.Int64? end,
  }) {
    final _result = create();
    if (start != null) {
      _result.start = start;
    }
    if (end != null) {
      _result.end = end;
    }
    return _result;
  }
  factory Period.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Period.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Period clone() => Period()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Period copyWith(void Function(Period) updates) =>
      super.copyWith((message) => updates(message as Period))
          as Period; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Period create() => Period._();
  Period createEmptyInstance() => create();
  static $pb.PbList<Period> createRepeated() => $pb.PbList<Period>();
  @$core.pragma('dart2js:noInline')
  static Period getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Period>(create);
  static Period? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get start => $_getI64(0);
  @$pb.TagNumber(1)
  set start($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get end => $_getI64(1);
  @$pb.TagNumber(2)
  set end($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnd() => clearField(2);
}

class PlayerDanmakuAiRecommendedLevel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerDanmakuAiRecommendedLevel',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value')
    ..hasRequiredFields = false;

  PlayerDanmakuAiRecommendedLevel._() : super();
  factory PlayerDanmakuAiRecommendedLevel({
    $core.bool? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory PlayerDanmakuAiRecommendedLevel.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerDanmakuAiRecommendedLevel.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerDanmakuAiRecommendedLevel clone() =>
      PlayerDanmakuAiRecommendedLevel()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerDanmakuAiRecommendedLevel copyWith(
          void Function(PlayerDanmakuAiRecommendedLevel) updates) =>
      super.copyWith(
              (message) => updates(message as PlayerDanmakuAiRecommendedLevel))
          as PlayerDanmakuAiRecommendedLevel; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuAiRecommendedLevel create() =>
      PlayerDanmakuAiRecommendedLevel._();
  PlayerDanmakuAiRecommendedLevel createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuAiRecommendedLevel> createRepeated() =>
      $pb.PbList<PlayerDanmakuAiRecommendedLevel>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuAiRecommendedLevel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuAiRecommendedLevel>(
          create);
  static PlayerDanmakuAiRecommendedLevel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class PlayerDanmakuAiRecommendedLevelV2 extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerDanmakuAiRecommendedLevelV2',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  PlayerDanmakuAiRecommendedLevelV2._() : super();
  factory PlayerDanmakuAiRecommendedLevelV2({
    $core.int? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory PlayerDanmakuAiRecommendedLevelV2.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerDanmakuAiRecommendedLevelV2.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerDanmakuAiRecommendedLevelV2 clone() =>
      PlayerDanmakuAiRecommendedLevelV2()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerDanmakuAiRecommendedLevelV2 copyWith(
          void Function(PlayerDanmakuAiRecommendedLevelV2) updates) =>
      super.copyWith((message) =>
              updates(message as PlayerDanmakuAiRecommendedLevelV2))
          as PlayerDanmakuAiRecommendedLevelV2; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuAiRecommendedLevelV2 create() =>
      PlayerDanmakuAiRecommendedLevelV2._();
  PlayerDanmakuAiRecommendedLevelV2 createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuAiRecommendedLevelV2> createRepeated() =>
      $pb.PbList<PlayerDanmakuAiRecommendedLevelV2>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuAiRecommendedLevelV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuAiRecommendedLevelV2>(
          create);
  static PlayerDanmakuAiRecommendedLevelV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get value => $_getIZ(0);
  @$pb.TagNumber(1)
  set value($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class PlayerDanmakuAiRecommendedSwitch extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerDanmakuAiRecommendedSwitch',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value')
    ..hasRequiredFields = false;

  PlayerDanmakuAiRecommendedSwitch._() : super();
  factory PlayerDanmakuAiRecommendedSwitch({
    $core.bool? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory PlayerDanmakuAiRecommendedSwitch.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerDanmakuAiRecommendedSwitch.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerDanmakuAiRecommendedSwitch clone() =>
      PlayerDanmakuAiRecommendedSwitch()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerDanmakuAiRecommendedSwitch copyWith(
          void Function(PlayerDanmakuAiRecommendedSwitch) updates) =>
      super.copyWith(
              (message) => updates(message as PlayerDanmakuAiRecommendedSwitch))
          as PlayerDanmakuAiRecommendedSwitch; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuAiRecommendedSwitch create() =>
      PlayerDanmakuAiRecommendedSwitch._();
  PlayerDanmakuAiRecommendedSwitch createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuAiRecommendedSwitch> createRepeated() =>
      $pb.PbList<PlayerDanmakuAiRecommendedSwitch>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuAiRecommendedSwitch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuAiRecommendedSwitch>(
          create);
  static PlayerDanmakuAiRecommendedSwitch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class PlayerDanmakuBlockbottom extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerDanmakuBlockbottom',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value')
    ..hasRequiredFields = false;

  PlayerDanmakuBlockbottom._() : super();
  factory PlayerDanmakuBlockbottom({
    $core.bool? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory PlayerDanmakuBlockbottom.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerDanmakuBlockbottom.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerDanmakuBlockbottom clone() =>
      PlayerDanmakuBlockbottom()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerDanmakuBlockbottom copyWith(
          void Function(PlayerDanmakuBlockbottom) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuBlockbottom))
          as PlayerDanmakuBlockbottom; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockbottom create() => PlayerDanmakuBlockbottom._();
  PlayerDanmakuBlockbottom createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuBlockbottom> createRepeated() =>
      $pb.PbList<PlayerDanmakuBlockbottom>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockbottom getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuBlockbottom>(create);
  static PlayerDanmakuBlockbottom? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class PlayerDanmakuBlockcolorful extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerDanmakuBlockcolorful',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value')
    ..hasRequiredFields = false;

  PlayerDanmakuBlockcolorful._() : super();
  factory PlayerDanmakuBlockcolorful({
    $core.bool? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory PlayerDanmakuBlockcolorful.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerDanmakuBlockcolorful.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerDanmakuBlockcolorful clone() =>
      PlayerDanmakuBlockcolorful()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerDanmakuBlockcolorful copyWith(
          void Function(PlayerDanmakuBlockcolorful) updates) =>
      super.copyWith(
              (message) => updates(message as PlayerDanmakuBlockcolorful))
          as PlayerDanmakuBlockcolorful; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockcolorful create() => PlayerDanmakuBlockcolorful._();
  PlayerDanmakuBlockcolorful createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuBlockcolorful> createRepeated() =>
      $pb.PbList<PlayerDanmakuBlockcolorful>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockcolorful getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuBlockcolorful>(create);
  static PlayerDanmakuBlockcolorful? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class PlayerDanmakuBlockrepeat extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerDanmakuBlockrepeat',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value')
    ..hasRequiredFields = false;

  PlayerDanmakuBlockrepeat._() : super();
  factory PlayerDanmakuBlockrepeat({
    $core.bool? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory PlayerDanmakuBlockrepeat.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerDanmakuBlockrepeat.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerDanmakuBlockrepeat clone() =>
      PlayerDanmakuBlockrepeat()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerDanmakuBlockrepeat copyWith(
          void Function(PlayerDanmakuBlockrepeat) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuBlockrepeat))
          as PlayerDanmakuBlockrepeat; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockrepeat create() => PlayerDanmakuBlockrepeat._();
  PlayerDanmakuBlockrepeat createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuBlockrepeat> createRepeated() =>
      $pb.PbList<PlayerDanmakuBlockrepeat>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockrepeat getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuBlockrepeat>(create);
  static PlayerDanmakuBlockrepeat? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class PlayerDanmakuBlockscroll extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerDanmakuBlockscroll',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value')
    ..hasRequiredFields = false;

  PlayerDanmakuBlockscroll._() : super();
  factory PlayerDanmakuBlockscroll({
    $core.bool? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory PlayerDanmakuBlockscroll.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerDanmakuBlockscroll.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerDanmakuBlockscroll clone() =>
      PlayerDanmakuBlockscroll()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerDanmakuBlockscroll copyWith(
          void Function(PlayerDanmakuBlockscroll) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuBlockscroll))
          as PlayerDanmakuBlockscroll; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockscroll create() => PlayerDanmakuBlockscroll._();
  PlayerDanmakuBlockscroll createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuBlockscroll> createRepeated() =>
      $pb.PbList<PlayerDanmakuBlockscroll>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockscroll getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuBlockscroll>(create);
  static PlayerDanmakuBlockscroll? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class PlayerDanmakuBlockspecial extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerDanmakuBlockspecial',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value')
    ..hasRequiredFields = false;

  PlayerDanmakuBlockspecial._() : super();
  factory PlayerDanmakuBlockspecial({
    $core.bool? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory PlayerDanmakuBlockspecial.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerDanmakuBlockspecial.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerDanmakuBlockspecial clone() =>
      PlayerDanmakuBlockspecial()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerDanmakuBlockspecial copyWith(
          void Function(PlayerDanmakuBlockspecial) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuBlockspecial))
          as PlayerDanmakuBlockspecial; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockspecial create() => PlayerDanmakuBlockspecial._();
  PlayerDanmakuBlockspecial createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuBlockspecial> createRepeated() =>
      $pb.PbList<PlayerDanmakuBlockspecial>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockspecial getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuBlockspecial>(create);
  static PlayerDanmakuBlockspecial? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class PlayerDanmakuBlocktop extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerDanmakuBlocktop',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value')
    ..hasRequiredFields = false;

  PlayerDanmakuBlocktop._() : super();
  factory PlayerDanmakuBlocktop({
    $core.bool? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory PlayerDanmakuBlocktop.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerDanmakuBlocktop.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerDanmakuBlocktop clone() =>
      PlayerDanmakuBlocktop()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerDanmakuBlocktop copyWith(
          void Function(PlayerDanmakuBlocktop) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuBlocktop))
          as PlayerDanmakuBlocktop; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlocktop create() => PlayerDanmakuBlocktop._();
  PlayerDanmakuBlocktop createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuBlocktop> createRepeated() =>
      $pb.PbList<PlayerDanmakuBlocktop>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlocktop getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuBlocktop>(create);
  static PlayerDanmakuBlocktop? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class PlayerDanmakuDomain extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerDanmakuDomain',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..a<$core.double>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value',
        $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  PlayerDanmakuDomain._() : super();
  factory PlayerDanmakuDomain({
    $core.double? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory PlayerDanmakuDomain.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerDanmakuDomain.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerDanmakuDomain clone() => PlayerDanmakuDomain()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerDanmakuDomain copyWith(void Function(PlayerDanmakuDomain) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuDomain))
          as PlayerDanmakuDomain; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuDomain create() => PlayerDanmakuDomain._();
  PlayerDanmakuDomain createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuDomain> createRepeated() =>
      $pb.PbList<PlayerDanmakuDomain>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuDomain getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuDomain>(create);
  static PlayerDanmakuDomain? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get value => $_getN(0);
  @$pb.TagNumber(1)
  set value($core.double v) {
    $_setFloat(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class PlayerDanmakuEnableblocklist extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerDanmakuEnableblocklist',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value')
    ..hasRequiredFields = false;

  PlayerDanmakuEnableblocklist._() : super();
  factory PlayerDanmakuEnableblocklist({
    $core.bool? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory PlayerDanmakuEnableblocklist.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerDanmakuEnableblocklist.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerDanmakuEnableblocklist clone() =>
      PlayerDanmakuEnableblocklist()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerDanmakuEnableblocklist copyWith(
          void Function(PlayerDanmakuEnableblocklist) updates) =>
      super.copyWith(
              (message) => updates(message as PlayerDanmakuEnableblocklist))
          as PlayerDanmakuEnableblocklist; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuEnableblocklist create() =>
      PlayerDanmakuEnableblocklist._();
  PlayerDanmakuEnableblocklist createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuEnableblocklist> createRepeated() =>
      $pb.PbList<PlayerDanmakuEnableblocklist>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuEnableblocklist getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuEnableblocklist>(create);
  static PlayerDanmakuEnableblocklist? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class PlayerDanmakuOpacity extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerDanmakuOpacity',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..a<$core.double>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value',
        $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  PlayerDanmakuOpacity._() : super();
  factory PlayerDanmakuOpacity({
    $core.double? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory PlayerDanmakuOpacity.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerDanmakuOpacity.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerDanmakuOpacity clone() =>
      PlayerDanmakuOpacity()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerDanmakuOpacity copyWith(void Function(PlayerDanmakuOpacity) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuOpacity))
          as PlayerDanmakuOpacity; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuOpacity create() => PlayerDanmakuOpacity._();
  PlayerDanmakuOpacity createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuOpacity> createRepeated() =>
      $pb.PbList<PlayerDanmakuOpacity>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuOpacity getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuOpacity>(create);
  static PlayerDanmakuOpacity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get value => $_getN(0);
  @$pb.TagNumber(1)
  set value($core.double v) {
    $_setFloat(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class PlayerDanmakuScalingfactor extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerDanmakuScalingfactor',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..a<$core.double>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value',
        $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  PlayerDanmakuScalingfactor._() : super();
  factory PlayerDanmakuScalingfactor({
    $core.double? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory PlayerDanmakuScalingfactor.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerDanmakuScalingfactor.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerDanmakuScalingfactor clone() =>
      PlayerDanmakuScalingfactor()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerDanmakuScalingfactor copyWith(
          void Function(PlayerDanmakuScalingfactor) updates) =>
      super.copyWith(
              (message) => updates(message as PlayerDanmakuScalingfactor))
          as PlayerDanmakuScalingfactor; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuScalingfactor create() => PlayerDanmakuScalingfactor._();
  PlayerDanmakuScalingfactor createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuScalingfactor> createRepeated() =>
      $pb.PbList<PlayerDanmakuScalingfactor>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuScalingfactor getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuScalingfactor>(create);
  static PlayerDanmakuScalingfactor? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get value => $_getN(0);
  @$pb.TagNumber(1)
  set value($core.double v) {
    $_setFloat(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class PlayerDanmakuSeniorModeSwitch extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerDanmakuSeniorModeSwitch',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  PlayerDanmakuSeniorModeSwitch._() : super();
  factory PlayerDanmakuSeniorModeSwitch({
    $core.int? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory PlayerDanmakuSeniorModeSwitch.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerDanmakuSeniorModeSwitch.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerDanmakuSeniorModeSwitch clone() =>
      PlayerDanmakuSeniorModeSwitch()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerDanmakuSeniorModeSwitch copyWith(
          void Function(PlayerDanmakuSeniorModeSwitch) updates) =>
      super.copyWith(
              (message) => updates(message as PlayerDanmakuSeniorModeSwitch))
          as PlayerDanmakuSeniorModeSwitch; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuSeniorModeSwitch create() =>
      PlayerDanmakuSeniorModeSwitch._();
  PlayerDanmakuSeniorModeSwitch createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuSeniorModeSwitch> createRepeated() =>
      $pb.PbList<PlayerDanmakuSeniorModeSwitch>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuSeniorModeSwitch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuSeniorModeSwitch>(create);
  static PlayerDanmakuSeniorModeSwitch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get value => $_getIZ(0);
  @$pb.TagNumber(1)
  set value($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class PlayerDanmakuSpeed extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerDanmakuSpeed',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  PlayerDanmakuSpeed._() : super();
  factory PlayerDanmakuSpeed({
    $core.int? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory PlayerDanmakuSpeed.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerDanmakuSpeed.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerDanmakuSpeed clone() => PlayerDanmakuSpeed()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerDanmakuSpeed copyWith(void Function(PlayerDanmakuSpeed) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuSpeed))
          as PlayerDanmakuSpeed; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuSpeed create() => PlayerDanmakuSpeed._();
  PlayerDanmakuSpeed createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuSpeed> createRepeated() =>
      $pb.PbList<PlayerDanmakuSpeed>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuSpeed getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuSpeed>(create);
  static PlayerDanmakuSpeed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get value => $_getIZ(0);
  @$pb.TagNumber(1)
  set value($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class PlayerDanmakuSwitch extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerDanmakuSwitch',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value')
    ..aOB(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'canIgnore')
    ..hasRequiredFields = false;

  PlayerDanmakuSwitch._() : super();
  factory PlayerDanmakuSwitch({
    $core.bool? value,
    $core.bool? canIgnore,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    if (canIgnore != null) {
      _result.canIgnore = canIgnore;
    }
    return _result;
  }
  factory PlayerDanmakuSwitch.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerDanmakuSwitch.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerDanmakuSwitch clone() => PlayerDanmakuSwitch()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerDanmakuSwitch copyWith(void Function(PlayerDanmakuSwitch) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuSwitch))
          as PlayerDanmakuSwitch; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuSwitch create() => PlayerDanmakuSwitch._();
  PlayerDanmakuSwitch createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuSwitch> createRepeated() =>
      $pb.PbList<PlayerDanmakuSwitch>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuSwitch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuSwitch>(create);
  static PlayerDanmakuSwitch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get canIgnore => $_getBF(1);
  @$pb.TagNumber(2)
  set canIgnore($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCanIgnore() => $_has(1);
  @$pb.TagNumber(2)
  void clearCanIgnore() => clearField(2);
}

class PlayerDanmakuSwitchSave extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerDanmakuSwitchSave',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value')
    ..hasRequiredFields = false;

  PlayerDanmakuSwitchSave._() : super();
  factory PlayerDanmakuSwitchSave({
    $core.bool? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory PlayerDanmakuSwitchSave.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerDanmakuSwitchSave.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerDanmakuSwitchSave clone() =>
      PlayerDanmakuSwitchSave()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerDanmakuSwitchSave copyWith(
          void Function(PlayerDanmakuSwitchSave) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuSwitchSave))
          as PlayerDanmakuSwitchSave; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuSwitchSave create() => PlayerDanmakuSwitchSave._();
  PlayerDanmakuSwitchSave createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuSwitchSave> createRepeated() =>
      $pb.PbList<PlayerDanmakuSwitchSave>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuSwitchSave getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuSwitchSave>(create);
  static PlayerDanmakuSwitchSave? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class PlayerDanmakuUseDefaultConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerDanmakuUseDefaultConfig',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value')
    ..hasRequiredFields = false;

  PlayerDanmakuUseDefaultConfig._() : super();
  factory PlayerDanmakuUseDefaultConfig({
    $core.bool? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory PlayerDanmakuUseDefaultConfig.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerDanmakuUseDefaultConfig.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerDanmakuUseDefaultConfig clone() =>
      PlayerDanmakuUseDefaultConfig()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerDanmakuUseDefaultConfig copyWith(
          void Function(PlayerDanmakuUseDefaultConfig) updates) =>
      super.copyWith(
              (message) => updates(message as PlayerDanmakuUseDefaultConfig))
          as PlayerDanmakuUseDefaultConfig; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuUseDefaultConfig create() =>
      PlayerDanmakuUseDefaultConfig._();
  PlayerDanmakuUseDefaultConfig createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuUseDefaultConfig> createRepeated() =>
      $pb.PbList<PlayerDanmakuUseDefaultConfig>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuUseDefaultConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuUseDefaultConfig>(create);
  static PlayerDanmakuUseDefaultConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class PostPanel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PostPanel',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'start')
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'end')
    ..aInt64(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'priority')
    ..aInt64(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bizId')
    ..e<PostPanelBizType>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bizType',
        $pb.PbFieldType.OE,
        defaultOrMaker: PostPanelBizType.PostPanelBizTypeNone,
        valueOf: PostPanelBizType.valueOf,
        enumValues: PostPanelBizType.values)
    ..aOM<ClickButton>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'clickButton',
        subBuilder: ClickButton.create)
    ..aOM<TextInput>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'textInput',
        subBuilder: TextInput.create)
    ..aOM<CheckBox>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'checkBox',
        subBuilder: CheckBox.create)
    ..aOM<Toast>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'toast',
        subBuilder: Toast.create)
    ..hasRequiredFields = false;

  PostPanel._() : super();
  factory PostPanel({
    $fixnum.Int64? start,
    $fixnum.Int64? end,
    $fixnum.Int64? priority,
    $fixnum.Int64? bizId,
    PostPanelBizType? bizType,
    ClickButton? clickButton,
    TextInput? textInput,
    CheckBox? checkBox,
    Toast? toast,
  }) {
    final _result = create();
    if (start != null) {
      _result.start = start;
    }
    if (end != null) {
      _result.end = end;
    }
    if (priority != null) {
      _result.priority = priority;
    }
    if (bizId != null) {
      _result.bizId = bizId;
    }
    if (bizType != null) {
      _result.bizType = bizType;
    }
    if (clickButton != null) {
      _result.clickButton = clickButton;
    }
    if (textInput != null) {
      _result.textInput = textInput;
    }
    if (checkBox != null) {
      _result.checkBox = checkBox;
    }
    if (toast != null) {
      _result.toast = toast;
    }
    return _result;
  }
  factory PostPanel.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PostPanel.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PostPanel clone() => PostPanel()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PostPanel copyWith(void Function(PostPanel) updates) =>
      super.copyWith((message) => updates(message as PostPanel))
          as PostPanel; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PostPanel create() => PostPanel._();
  PostPanel createEmptyInstance() => create();
  static $pb.PbList<PostPanel> createRepeated() => $pb.PbList<PostPanel>();
  @$core.pragma('dart2js:noInline')
  static PostPanel getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PostPanel>(create);
  static PostPanel? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get start => $_getI64(0);
  @$pb.TagNumber(1)
  set start($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get end => $_getI64(1);
  @$pb.TagNumber(2)
  set end($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnd() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get priority => $_getI64(2);
  @$pb.TagNumber(3)
  set priority($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPriority() => $_has(2);
  @$pb.TagNumber(3)
  void clearPriority() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get bizId => $_getI64(3);
  @$pb.TagNumber(4)
  set bizId($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasBizId() => $_has(3);
  @$pb.TagNumber(4)
  void clearBizId() => clearField(4);

  @$pb.TagNumber(5)
  PostPanelBizType get bizType => $_getN(4);
  @$pb.TagNumber(5)
  set bizType(PostPanelBizType v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasBizType() => $_has(4);
  @$pb.TagNumber(5)
  void clearBizType() => clearField(5);

  @$pb.TagNumber(6)
  ClickButton get clickButton => $_getN(5);
  @$pb.TagNumber(6)
  set clickButton(ClickButton v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasClickButton() => $_has(5);
  @$pb.TagNumber(6)
  void clearClickButton() => clearField(6);
  @$pb.TagNumber(6)
  ClickButton ensureClickButton() => $_ensure(5);

  @$pb.TagNumber(7)
  TextInput get textInput => $_getN(6);
  @$pb.TagNumber(7)
  set textInput(TextInput v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasTextInput() => $_has(6);
  @$pb.TagNumber(7)
  void clearTextInput() => clearField(7);
  @$pb.TagNumber(7)
  TextInput ensureTextInput() => $_ensure(6);

  @$pb.TagNumber(8)
  CheckBox get checkBox => $_getN(7);
  @$pb.TagNumber(8)
  set checkBox(CheckBox v) {
    setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasCheckBox() => $_has(7);
  @$pb.TagNumber(8)
  void clearCheckBox() => clearField(8);
  @$pb.TagNumber(8)
  CheckBox ensureCheckBox() => $_ensure(7);

  @$pb.TagNumber(9)
  Toast get toast => $_getN(8);
  @$pb.TagNumber(9)
  set toast(Toast v) {
    setField(9, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasToast() => $_has(8);
  @$pb.TagNumber(9)
  void clearToast() => clearField(9);
  @$pb.TagNumber(9)
  Toast ensureToast() => $_ensure(8);
}

class PostPanelV2 extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PostPanelV2',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'start')
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'end')
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bizType',
        $pb.PbFieldType.O3)
    ..aOM<ClickButtonV2>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'clickButton',
        subBuilder: ClickButtonV2.create)
    ..aOM<TextInputV2>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'textInput',
        subBuilder: TextInputV2.create)
    ..aOM<CheckBoxV2>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'checkBox',
        subBuilder: CheckBoxV2.create)
    ..aOM<ToastV2>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'toast',
        subBuilder: ToastV2.create)
    ..aOM<BubbleV2>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bubble',
        subBuilder: BubbleV2.create)
    ..aOM<LabelV2>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'label',
        subBuilder: LabelV2.create)
    ..a<$core.int>(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'postStatus',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  PostPanelV2._() : super();
  factory PostPanelV2({
    $fixnum.Int64? start,
    $fixnum.Int64? end,
    $core.int? bizType,
    ClickButtonV2? clickButton,
    TextInputV2? textInput,
    CheckBoxV2? checkBox,
    ToastV2? toast,
    BubbleV2? bubble,
    LabelV2? label,
    $core.int? postStatus,
  }) {
    final _result = create();
    if (start != null) {
      _result.start = start;
    }
    if (end != null) {
      _result.end = end;
    }
    if (bizType != null) {
      _result.bizType = bizType;
    }
    if (clickButton != null) {
      _result.clickButton = clickButton;
    }
    if (textInput != null) {
      _result.textInput = textInput;
    }
    if (checkBox != null) {
      _result.checkBox = checkBox;
    }
    if (toast != null) {
      _result.toast = toast;
    }
    if (bubble != null) {
      _result.bubble = bubble;
    }
    if (label != null) {
      _result.label = label;
    }
    if (postStatus != null) {
      _result.postStatus = postStatus;
    }
    return _result;
  }
  factory PostPanelV2.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PostPanelV2.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PostPanelV2 clone() => PostPanelV2()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PostPanelV2 copyWith(void Function(PostPanelV2) updates) =>
      super.copyWith((message) => updates(message as PostPanelV2))
          as PostPanelV2; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PostPanelV2 create() => PostPanelV2._();
  PostPanelV2 createEmptyInstance() => create();
  static $pb.PbList<PostPanelV2> createRepeated() => $pb.PbList<PostPanelV2>();
  @$core.pragma('dart2js:noInline')
  static PostPanelV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PostPanelV2>(create);
  static PostPanelV2? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get start => $_getI64(0);
  @$pb.TagNumber(1)
  set start($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get end => $_getI64(1);
  @$pb.TagNumber(2)
  set end($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnd() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get bizType => $_getIZ(2);
  @$pb.TagNumber(3)
  set bizType($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasBizType() => $_has(2);
  @$pb.TagNumber(3)
  void clearBizType() => clearField(3);

  @$pb.TagNumber(4)
  ClickButtonV2 get clickButton => $_getN(3);
  @$pb.TagNumber(4)
  set clickButton(ClickButtonV2 v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasClickButton() => $_has(3);
  @$pb.TagNumber(4)
  void clearClickButton() => clearField(4);
  @$pb.TagNumber(4)
  ClickButtonV2 ensureClickButton() => $_ensure(3);

  @$pb.TagNumber(5)
  TextInputV2 get textInput => $_getN(4);
  @$pb.TagNumber(5)
  set textInput(TextInputV2 v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasTextInput() => $_has(4);
  @$pb.TagNumber(5)
  void clearTextInput() => clearField(5);
  @$pb.TagNumber(5)
  TextInputV2 ensureTextInput() => $_ensure(4);

  @$pb.TagNumber(6)
  CheckBoxV2 get checkBox => $_getN(5);
  @$pb.TagNumber(6)
  set checkBox(CheckBoxV2 v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasCheckBox() => $_has(5);
  @$pb.TagNumber(6)
  void clearCheckBox() => clearField(6);
  @$pb.TagNumber(6)
  CheckBoxV2 ensureCheckBox() => $_ensure(5);

  @$pb.TagNumber(7)
  ToastV2 get toast => $_getN(6);
  @$pb.TagNumber(7)
  set toast(ToastV2 v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasToast() => $_has(6);
  @$pb.TagNumber(7)
  void clearToast() => clearField(7);
  @$pb.TagNumber(7)
  ToastV2 ensureToast() => $_ensure(6);

  @$pb.TagNumber(8)
  BubbleV2 get bubble => $_getN(7);
  @$pb.TagNumber(8)
  set bubble(BubbleV2 v) {
    setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasBubble() => $_has(7);
  @$pb.TagNumber(8)
  void clearBubble() => clearField(8);
  @$pb.TagNumber(8)
  BubbleV2 ensureBubble() => $_ensure(7);

  @$pb.TagNumber(9)
  LabelV2 get label => $_getN(8);
  @$pb.TagNumber(9)
  set label(LabelV2 v) {
    setField(9, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasLabel() => $_has(8);
  @$pb.TagNumber(9)
  void clearLabel() => clearField(9);
  @$pb.TagNumber(9)
  LabelV2 ensureLabel() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.int get postStatus => $_getIZ(9);
  @$pb.TagNumber(10)
  set postStatus($core.int v) {
    $_setSignedInt32(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasPostStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearPostStatus() => clearField(10);
}

class Response extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Response',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'code',
        $pb.PbFieldType.O3)
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'message')
    ..hasRequiredFields = false;

  Response._() : super();
  factory Response({
    $core.int? code,
    $core.String? message,
  }) {
    final _result = create();
    if (code != null) {
      _result.code = code;
    }
    if (message != null) {
      _result.message = message;
    }
    return _result;
  }
  factory Response.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Response.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Response clone() => Response()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Response copyWith(void Function(Response) updates) =>
      super.copyWith((message) => updates(message as Response))
          as Response; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Response create() => Response._();
  Response createEmptyInstance() => create();
  static $pb.PbList<Response> createRepeated() => $pb.PbList<Response>();
  @$core.pragma('dart2js:noInline')
  static Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Response>(create);
  static Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class SubtitleItem extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'SubtitleItem',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'idStr')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'lan')
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'lanDoc')
    ..aOS(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'subtitleUrl')
    ..aOM<UserInfo>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'author',
        subBuilder: UserInfo.create)
    ..e<SubtitleType>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'type',
        $pb.PbFieldType.OE,
        defaultOrMaker: SubtitleType.CC,
        valueOf: SubtitleType.valueOf,
        enumValues: SubtitleType.values)
    ..aOS(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'lanDocBrief')
    ..e<SubtitleAiType>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'aiType',
        $pb.PbFieldType.OE,
        defaultOrMaker: SubtitleAiType.Normal,
        valueOf: SubtitleAiType.valueOf,
        enumValues: SubtitleAiType.values)
    ..e<SubtitleAiStatus>(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'aiStatus',
        $pb.PbFieldType.OE,
        defaultOrMaker: SubtitleAiStatus.None,
        valueOf: SubtitleAiStatus.valueOf,
        enumValues: SubtitleAiStatus.values)
    ..hasRequiredFields = false;

  SubtitleItem._() : super();
  factory SubtitleItem({
    $fixnum.Int64? id,
    $core.String? idStr,
    $core.String? lan,
    $core.String? lanDoc,
    $core.String? subtitleUrl,
    UserInfo? author,
    SubtitleType? type,
    $core.String? lanDocBrief,
    SubtitleAiType? aiType,
    SubtitleAiStatus? aiStatus,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (idStr != null) {
      _result.idStr = idStr;
    }
    if (lan != null) {
      _result.lan = lan;
    }
    if (lanDoc != null) {
      _result.lanDoc = lanDoc;
    }
    if (subtitleUrl != null) {
      _result.subtitleUrl = subtitleUrl;
    }
    if (author != null) {
      _result.author = author;
    }
    if (type != null) {
      _result.type = type;
    }
    if (lanDocBrief != null) {
      _result.lanDocBrief = lanDocBrief;
    }
    if (aiType != null) {
      _result.aiType = aiType;
    }
    if (aiStatus != null) {
      _result.aiStatus = aiStatus;
    }
    return _result;
  }
  factory SubtitleItem.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SubtitleItem.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SubtitleItem clone() => SubtitleItem()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SubtitleItem copyWith(void Function(SubtitleItem) updates) =>
      super.copyWith((message) => updates(message as SubtitleItem))
          as SubtitleItem; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SubtitleItem create() => SubtitleItem._();
  SubtitleItem createEmptyInstance() => create();
  static $pb.PbList<SubtitleItem> createRepeated() =>
      $pb.PbList<SubtitleItem>();
  @$core.pragma('dart2js:noInline')
  static SubtitleItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubtitleItem>(create);
  static SubtitleItem? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get idStr => $_getSZ(1);
  @$pb.TagNumber(2)
  set idStr($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasIdStr() => $_has(1);
  @$pb.TagNumber(2)
  void clearIdStr() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get lan => $_getSZ(2);
  @$pb.TagNumber(3)
  set lan($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasLan() => $_has(2);
  @$pb.TagNumber(3)
  void clearLan() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get lanDoc => $_getSZ(3);
  @$pb.TagNumber(4)
  set lanDoc($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasLanDoc() => $_has(3);
  @$pb.TagNumber(4)
  void clearLanDoc() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get subtitleUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set subtitleUrl($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasSubtitleUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearSubtitleUrl() => clearField(5);

  @$pb.TagNumber(6)
  UserInfo get author => $_getN(5);
  @$pb.TagNumber(6)
  set author(UserInfo v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasAuthor() => $_has(5);
  @$pb.TagNumber(6)
  void clearAuthor() => clearField(6);
  @$pb.TagNumber(6)
  UserInfo ensureAuthor() => $_ensure(5);

  @$pb.TagNumber(7)
  SubtitleType get type => $_getN(6);
  @$pb.TagNumber(7)
  set type(SubtitleType v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasType() => $_has(6);
  @$pb.TagNumber(7)
  void clearType() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get lanDocBrief => $_getSZ(7);
  @$pb.TagNumber(8)
  set lanDocBrief($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasLanDocBrief() => $_has(7);
  @$pb.TagNumber(8)
  void clearLanDocBrief() => clearField(8);

  @$pb.TagNumber(9)
  SubtitleAiType get aiType => $_getN(8);
  @$pb.TagNumber(9)
  set aiType(SubtitleAiType v) {
    setField(9, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasAiType() => $_has(8);
  @$pb.TagNumber(9)
  void clearAiType() => clearField(9);

  @$pb.TagNumber(10)
  SubtitleAiStatus get aiStatus => $_getN(9);
  @$pb.TagNumber(10)
  set aiStatus(SubtitleAiStatus v) {
    setField(10, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasAiStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearAiStatus() => clearField(10);
}

class TextInput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'TextInput',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pPS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'portraitPlaceholder')
    ..pPS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'landscapePlaceholder')
    ..e<RenderType>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'renderType',
        $pb.PbFieldType.OE,
        defaultOrMaker: RenderType.RenderTypeNone,
        valueOf: RenderType.valueOf,
        enumValues: RenderType.values)
    ..aOB(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'placeholderPost')
    ..aOB(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'show')
    ..pc<Avatar>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'avatar',
        $pb.PbFieldType.PM,
        subBuilder: Avatar.create)
    ..e<PostStatus>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'postStatus',
        $pb.PbFieldType.OE,
        defaultOrMaker: PostStatus.PostStatusNormal,
        valueOf: PostStatus.valueOf,
        enumValues: PostStatus.values)
    ..aOM<Label>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'label',
        subBuilder: Label.create)
    ..hasRequiredFields = false;

  TextInput._() : super();
  factory TextInput({
    $core.Iterable<$core.String>? portraitPlaceholder,
    $core.Iterable<$core.String>? landscapePlaceholder,
    RenderType? renderType,
    $core.bool? placeholderPost,
    $core.bool? show,
    $core.Iterable<Avatar>? avatar,
    PostStatus? postStatus,
    Label? label,
  }) {
    final _result = create();
    if (portraitPlaceholder != null) {
      _result.portraitPlaceholder.addAll(portraitPlaceholder);
    }
    if (landscapePlaceholder != null) {
      _result.landscapePlaceholder.addAll(landscapePlaceholder);
    }
    if (renderType != null) {
      _result.renderType = renderType;
    }
    if (placeholderPost != null) {
      _result.placeholderPost = placeholderPost;
    }
    if (show != null) {
      _result.show = show;
    }
    if (avatar != null) {
      _result.avatar.addAll(avatar);
    }
    if (postStatus != null) {
      _result.postStatus = postStatus;
    }
    if (label != null) {
      _result.label = label;
    }
    return _result;
  }
  factory TextInput.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory TextInput.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  TextInput clone() => TextInput()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  TextInput copyWith(void Function(TextInput) updates) =>
      super.copyWith((message) => updates(message as TextInput))
          as TextInput; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TextInput create() => TextInput._();
  TextInput createEmptyInstance() => create();
  static $pb.PbList<TextInput> createRepeated() => $pb.PbList<TextInput>();
  @$core.pragma('dart2js:noInline')
  static TextInput getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TextInput>(create);
  static TextInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get portraitPlaceholder => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$core.String> get landscapePlaceholder => $_getList(1);

  @$pb.TagNumber(3)
  RenderType get renderType => $_getN(2);
  @$pb.TagNumber(3)
  set renderType(RenderType v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRenderType() => $_has(2);
  @$pb.TagNumber(3)
  void clearRenderType() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get placeholderPost => $_getBF(3);
  @$pb.TagNumber(4)
  set placeholderPost($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasPlaceholderPost() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlaceholderPost() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get show => $_getBF(4);
  @$pb.TagNumber(5)
  set show($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasShow() => $_has(4);
  @$pb.TagNumber(5)
  void clearShow() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<Avatar> get avatar => $_getList(5);

  @$pb.TagNumber(7)
  PostStatus get postStatus => $_getN(6);
  @$pb.TagNumber(7)
  set postStatus(PostStatus v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasPostStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearPostStatus() => clearField(7);

  @$pb.TagNumber(8)
  Label get label => $_getN(7);
  @$pb.TagNumber(8)
  set label(Label v) {
    setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasLabel() => $_has(7);
  @$pb.TagNumber(8)
  void clearLabel() => clearField(8);
  @$pb.TagNumber(8)
  Label ensureLabel() => $_ensure(7);
}

class TextInputV2 extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'TextInputV2',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pPS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'portraitPlaceholder')
    ..pPS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'landscapePlaceholder')
    ..e<RenderType>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'renderType',
        $pb.PbFieldType.OE,
        defaultOrMaker: RenderType.RenderTypeNone,
        valueOf: RenderType.valueOf,
        enumValues: RenderType.values)
    ..aOB(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'placeholderPost')
    ..pc<Avatar>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'avatar',
        $pb.PbFieldType.PM,
        subBuilder: Avatar.create)
    ..a<$core.int>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'textInputLimit',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  TextInputV2._() : super();
  factory TextInputV2({
    $core.Iterable<$core.String>? portraitPlaceholder,
    $core.Iterable<$core.String>? landscapePlaceholder,
    RenderType? renderType,
    $core.bool? placeholderPost,
    $core.Iterable<Avatar>? avatar,
    $core.int? textInputLimit,
  }) {
    final _result = create();
    if (portraitPlaceholder != null) {
      _result.portraitPlaceholder.addAll(portraitPlaceholder);
    }
    if (landscapePlaceholder != null) {
      _result.landscapePlaceholder.addAll(landscapePlaceholder);
    }
    if (renderType != null) {
      _result.renderType = renderType;
    }
    if (placeholderPost != null) {
      _result.placeholderPost = placeholderPost;
    }
    if (avatar != null) {
      _result.avatar.addAll(avatar);
    }
    if (textInputLimit != null) {
      _result.textInputLimit = textInputLimit;
    }
    return _result;
  }
  factory TextInputV2.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory TextInputV2.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  TextInputV2 clone() => TextInputV2()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  TextInputV2 copyWith(void Function(TextInputV2) updates) =>
      super.copyWith((message) => updates(message as TextInputV2))
          as TextInputV2; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TextInputV2 create() => TextInputV2._();
  TextInputV2 createEmptyInstance() => create();
  static $pb.PbList<TextInputV2> createRepeated() => $pb.PbList<TextInputV2>();
  @$core.pragma('dart2js:noInline')
  static TextInputV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TextInputV2>(create);
  static TextInputV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get portraitPlaceholder => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$core.String> get landscapePlaceholder => $_getList(1);

  @$pb.TagNumber(3)
  RenderType get renderType => $_getN(2);
  @$pb.TagNumber(3)
  set renderType(RenderType v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRenderType() => $_has(2);
  @$pb.TagNumber(3)
  void clearRenderType() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get placeholderPost => $_getBF(3);
  @$pb.TagNumber(4)
  set placeholderPost($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasPlaceholderPost() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlaceholderPost() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<Avatar> get avatar => $_getList(4);

  @$pb.TagNumber(6)
  $core.int get textInputLimit => $_getIZ(5);
  @$pb.TagNumber(6)
  set textInputLimit($core.int v) {
    $_setSignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasTextInputLimit() => $_has(5);
  @$pb.TagNumber(6)
  void clearTextInputLimit() => clearField(6);
}

class Toast extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Toast',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'text')
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'duration',
        $pb.PbFieldType.O3)
    ..aOB(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'show')
    ..aOM<Button>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'button',
        subBuilder: Button.create)
    ..hasRequiredFields = false;

  Toast._() : super();
  factory Toast({
    $core.String? text,
    $core.int? duration,
    $core.bool? show,
    Button? button,
  }) {
    final _result = create();
    if (text != null) {
      _result.text = text;
    }
    if (duration != null) {
      _result.duration = duration;
    }
    if (show != null) {
      _result.show = show;
    }
    if (button != null) {
      _result.button = button;
    }
    return _result;
  }
  factory Toast.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Toast.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Toast clone() => Toast()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Toast copyWith(void Function(Toast) updates) =>
      super.copyWith((message) => updates(message as Toast))
          as Toast; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Toast create() => Toast._();
  Toast createEmptyInstance() => create();
  static $pb.PbList<Toast> createRepeated() => $pb.PbList<Toast>();
  @$core.pragma('dart2js:noInline')
  static Toast getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Toast>(create);
  static Toast? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get duration => $_getIZ(1);
  @$pb.TagNumber(2)
  set duration($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasDuration() => $_has(1);
  @$pb.TagNumber(2)
  void clearDuration() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get show => $_getBF(2);
  @$pb.TagNumber(3)
  set show($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasShow() => $_has(2);
  @$pb.TagNumber(3)
  void clearShow() => clearField(3);

  @$pb.TagNumber(4)
  Button get button => $_getN(3);
  @$pb.TagNumber(4)
  set button(Button v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasButton() => $_has(3);
  @$pb.TagNumber(4)
  void clearButton() => clearField(4);
  @$pb.TagNumber(4)
  Button ensureButton() => $_ensure(3);
}

class ToastButtonV2 extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ToastButtonV2',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'text')
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'action',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  ToastButtonV2._() : super();
  factory ToastButtonV2({
    $core.String? text,
    $core.int? action,
  }) {
    final _result = create();
    if (text != null) {
      _result.text = text;
    }
    if (action != null) {
      _result.action = action;
    }
    return _result;
  }
  factory ToastButtonV2.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ToastButtonV2.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ToastButtonV2 clone() => ToastButtonV2()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ToastButtonV2 copyWith(void Function(ToastButtonV2) updates) =>
      super.copyWith((message) => updates(message as ToastButtonV2))
          as ToastButtonV2; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ToastButtonV2 create() => ToastButtonV2._();
  ToastButtonV2 createEmptyInstance() => create();
  static $pb.PbList<ToastButtonV2> createRepeated() =>
      $pb.PbList<ToastButtonV2>();
  @$core.pragma('dart2js:noInline')
  static ToastButtonV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToastButtonV2>(create);
  static ToastButtonV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get action => $_getIZ(1);
  @$pb.TagNumber(2)
  set action($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => clearField(2);
}

class ToastV2 extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ToastV2',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'text')
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'duration',
        $pb.PbFieldType.O3)
    ..aOM<ToastButtonV2>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'toastButtonV2',
        subBuilder: ToastButtonV2.create)
    ..hasRequiredFields = false;

  ToastV2._() : super();
  factory ToastV2({
    $core.String? text,
    $core.int? duration,
    ToastButtonV2? toastButtonV2,
  }) {
    final _result = create();
    if (text != null) {
      _result.text = text;
    }
    if (duration != null) {
      _result.duration = duration;
    }
    if (toastButtonV2 != null) {
      _result.toastButtonV2 = toastButtonV2;
    }
    return _result;
  }
  factory ToastV2.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ToastV2.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ToastV2 clone() => ToastV2()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ToastV2 copyWith(void Function(ToastV2) updates) =>
      super.copyWith((message) => updates(message as ToastV2))
          as ToastV2; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ToastV2 create() => ToastV2._();
  ToastV2 createEmptyInstance() => create();
  static $pb.PbList<ToastV2> createRepeated() => $pb.PbList<ToastV2>();
  @$core.pragma('dart2js:noInline')
  static ToastV2 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ToastV2>(create);
  static ToastV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get duration => $_getIZ(1);
  @$pb.TagNumber(2)
  set duration($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasDuration() => $_has(1);
  @$pb.TagNumber(2)
  void clearDuration() => clearField(2);

  @$pb.TagNumber(3)
  ToastButtonV2 get toastButtonV2 => $_getN(2);
  @$pb.TagNumber(3)
  set toastButtonV2(ToastButtonV2 v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasToastButtonV2() => $_has(2);
  @$pb.TagNumber(3)
  void clearToastButtonV2() => clearField(3);
  @$pb.TagNumber(3)
  ToastButtonV2 ensureToastButtonV2() => $_ensure(2);
}

class UserInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'UserInfo',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'mid')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'name')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'sex')
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'face')
    ..aOS(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'sign')
    ..a<$core.int>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'rank',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  UserInfo._() : super();
  factory UserInfo({
    $fixnum.Int64? mid,
    $core.String? name,
    $core.String? sex,
    $core.String? face,
    $core.String? sign,
    $core.int? rank,
  }) {
    final _result = create();
    if (mid != null) {
      _result.mid = mid;
    }
    if (name != null) {
      _result.name = name;
    }
    if (sex != null) {
      _result.sex = sex;
    }
    if (face != null) {
      _result.face = face;
    }
    if (sign != null) {
      _result.sign = sign;
    }
    if (rank != null) {
      _result.rank = rank;
    }
    return _result;
  }
  factory UserInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory UserInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  UserInfo clone() => UserInfo()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  UserInfo copyWith(void Function(UserInfo) updates) =>
      super.copyWith((message) => updates(message as UserInfo))
          as UserInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UserInfo create() => UserInfo._();
  UserInfo createEmptyInstance() => create();
  static $pb.PbList<UserInfo> createRepeated() => $pb.PbList<UserInfo>();
  @$core.pragma('dart2js:noInline')
  static UserInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserInfo>(create);
  static UserInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get mid => $_getI64(0);
  @$pb.TagNumber(1)
  set mid($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearMid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get sex => $_getSZ(2);
  @$pb.TagNumber(3)
  set sex($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSex() => $_has(2);
  @$pb.TagNumber(3)
  void clearSex() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get face => $_getSZ(3);
  @$pb.TagNumber(4)
  set face($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasFace() => $_has(3);
  @$pb.TagNumber(4)
  void clearFace() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get sign => $_getSZ(4);
  @$pb.TagNumber(5)
  set sign($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasSign() => $_has(4);
  @$pb.TagNumber(5)
  void clearSign() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get rank => $_getIZ(5);
  @$pb.TagNumber(6)
  set rank($core.int v) {
    $_setSignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasRank() => $_has(5);
  @$pb.TagNumber(6)
  void clearRank() => clearField(6);
}

class VideoMask extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'VideoMask',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'cid')
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'plat',
        $pb.PbFieldType.O3)
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'fps',
        $pb.PbFieldType.O3)
    ..aInt64(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'time')
    ..aOS(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'maskUrl')
    ..hasRequiredFields = false;

  VideoMask._() : super();
  factory VideoMask({
    $fixnum.Int64? cid,
    $core.int? plat,
    $core.int? fps,
    $fixnum.Int64? time,
    $core.String? maskUrl,
  }) {
    final _result = create();
    if (cid != null) {
      _result.cid = cid;
    }
    if (plat != null) {
      _result.plat = plat;
    }
    if (fps != null) {
      _result.fps = fps;
    }
    if (time != null) {
      _result.time = time;
    }
    if (maskUrl != null) {
      _result.maskUrl = maskUrl;
    }
    return _result;
  }
  factory VideoMask.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory VideoMask.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  VideoMask clone() => VideoMask()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  VideoMask copyWith(void Function(VideoMask) updates) =>
      super.copyWith((message) => updates(message as VideoMask))
          as VideoMask; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VideoMask create() => VideoMask._();
  VideoMask createEmptyInstance() => create();
  static $pb.PbList<VideoMask> createRepeated() => $pb.PbList<VideoMask>();
  @$core.pragma('dart2js:noInline')
  static VideoMask getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoMask>(create);
  static VideoMask? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get cid => $_getI64(0);
  @$pb.TagNumber(1)
  set cid($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCid() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get plat => $_getIZ(1);
  @$pb.TagNumber(2)
  set plat($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPlat() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlat() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get fps => $_getIZ(2);
  @$pb.TagNumber(3)
  set fps($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasFps() => $_has(2);
  @$pb.TagNumber(3)
  void clearFps() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get time => $_getI64(3);
  @$pb.TagNumber(4)
  set time($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearTime() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get maskUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set maskUrl($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasMaskUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaskUrl() => clearField(5);
}

class VideoSubtitle extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'VideoSubtitle',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'lan')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'lanDoc',
        protoName: 'lanDoc')
    ..pc<SubtitleItem>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'subtitles',
        $pb.PbFieldType.PM,
        subBuilder: SubtitleItem.create)
    ..hasRequiredFields = false;

  VideoSubtitle._() : super();
  factory VideoSubtitle({
    $core.String? lan,
    $core.String? lanDoc,
    $core.Iterable<SubtitleItem>? subtitles,
  }) {
    final _result = create();
    if (lan != null) {
      _result.lan = lan;
    }
    if (lanDoc != null) {
      _result.lanDoc = lanDoc;
    }
    if (subtitles != null) {
      _result.subtitles.addAll(subtitles);
    }
    return _result;
  }
  factory VideoSubtitle.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory VideoSubtitle.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  VideoSubtitle clone() => VideoSubtitle()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  VideoSubtitle copyWith(void Function(VideoSubtitle) updates) =>
      super.copyWith((message) => updates(message as VideoSubtitle))
          as VideoSubtitle; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VideoSubtitle create() => VideoSubtitle._();
  VideoSubtitle createEmptyInstance() => create();
  static $pb.PbList<VideoSubtitle> createRepeated() =>
      $pb.PbList<VideoSubtitle>();
  @$core.pragma('dart2js:noInline')
  static VideoSubtitle getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoSubtitle>(create);
  static VideoSubtitle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lan => $_getSZ(0);
  @$pb.TagNumber(1)
  set lan($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasLan() => $_has(0);
  @$pb.TagNumber(1)
  void clearLan() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get lanDoc => $_getSZ(1);
  @$pb.TagNumber(2)
  set lanDoc($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasLanDoc() => $_has(1);
  @$pb.TagNumber(2)
  void clearLanDoc() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<SubtitleItem> get subtitles => $_getList(2);
}

class DMApi {
  $pb.RpcClient _client;
  DMApi(this._client);

  $async.Future<DmSegMobileReply> dmSegMobile(
      $pb.ClientContext? ctx, DmSegMobileReq request) {
    var emptyResponse = DmSegMobileReply();
    return _client.invoke<DmSegMobileReply>(
        ctx, 'DM', 'DmSegMobile', request, emptyResponse);
  }

  $async.Future<DmViewReply> dmView($pb.ClientContext? ctx, DmViewReq request) {
    var emptyResponse = DmViewReply();
    return _client.invoke<DmViewReply>(
        ctx, 'DM', 'DmView', request, emptyResponse);
  }

  $async.Future<Response> dmPlayerConfig(
      $pb.ClientContext? ctx, DmPlayerConfigReq request) {
    var emptyResponse = Response();
    return _client.invoke<Response>(
        ctx, 'DM', 'DmPlayerConfig', request, emptyResponse);
  }

  $async.Future<DmSegOttReply> dmSegOtt(
      $pb.ClientContext? ctx, DmSegOttReq request) {
    var emptyResponse = DmSegOttReply();
    return _client.invoke<DmSegOttReply>(
        ctx, 'DM', 'DmSegOtt', request, emptyResponse);
  }

  $async.Future<DmSegSDKReply> dmSegSDK(
      $pb.ClientContext? ctx, DmSegSDKReq request) {
    var emptyResponse = DmSegSDKReply();
    return _client.invoke<DmSegSDKReply>(
        ctx, 'DM', 'DmSegSDK', request, emptyResponse);
  }

  $async.Future<DmExpoReportRes> dmExpoReport(
      $pb.ClientContext? ctx, DmExpoReportReq request) {
    var emptyResponse = DmExpoReportRes();
    return _client.invoke<DmExpoReportRes>(
        ctx, 'DM', 'DmExpoReport', request, emptyResponse);
  }
}
