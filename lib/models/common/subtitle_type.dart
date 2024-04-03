enum SubtitleType {
  // 中文（中国）
  zhCN,
  // 中文（自动翻译）
  aizh,
  // 英语（自动生成）
  aien,
}

extension SubtitleTypeExtension on SubtitleType {
  String get description {
    switch (this) {
      case SubtitleType.zhCN:
        return '中文（中国）';
      case SubtitleType.aizh:
        return '中文（自动翻译）';
      case SubtitleType.aien:
        return '英语（自动生成）';
    }
  }
}

extension SubtitleIdExtension on SubtitleType {
  String get id {
    switch (this) {
      case SubtitleType.zhCN:
        return 'zh-CN';
      case SubtitleType.aizh:
        return 'ai-zh';
      case SubtitleType.aien:
        return 'ai-en';
    }
  }
}

extension SubtitleCodeExtension on SubtitleType {
  int get code {
    switch (this) {
      case SubtitleType.zhCN:
        return 1;
      case SubtitleType.aizh:
        return 2;
      case SubtitleType.aien:
        return 3;
    }
  }
}
