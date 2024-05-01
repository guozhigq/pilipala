enum SubtitleType {
  // 中文（中国）
  zhCN,
  // 中文（自动翻译）
  aizh,
  // 英语（自动生成）
  aien,
  // 中文（简体）
  zhHans,
  // 英文（美国）
  enUS,
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
      case SubtitleType.zhHans:
        return '中文（简体）';
      case SubtitleType.enUS:
        return '英文（美国）';
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
      case SubtitleType.zhHans:
        return 'zh-Hans';
      case SubtitleType.enUS:
        return 'en-US';
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
      case SubtitleType.zhHans:
        return 4;
      case SubtitleType.enUS:
        return 5;
    }
  }
}
