import 'action_type.dart';
import 'segment_type.dart';

class SegmentDataModel {
  final SegmentType? category;
  final ActionType? actionType;
  final List? segment;
  final String? uuid;
  final int? videoDuration;
  final int? locked;
  final int? votes;
  final String? description;
  // 是否已经跳过
  bool isSkip = false;

  SegmentDataModel({
    this.category,
    this.actionType,
    this.segment,
    this.uuid,
    this.videoDuration,
    this.locked,
    this.votes,
    this.description,
  });

  factory SegmentDataModel.fromJson(Map<String, dynamic> json) {
    return SegmentDataModel(
      category: SegmentType.values.firstWhere(
          (e) => e.value == json['category'],
          orElse: () => SegmentType.sponsor),
      actionType: ActionType.values.firstWhere(
          (e) => e.value == json['actionType'],
          orElse: () => ActionType.skip),
      segment: json['segment'],
      uuid: json['UUID'],
      videoDuration: json['videoDuration'],
      locked: json['locked'],
      votes: json['votes'],
      description: json['description'],
    );
  }
}
