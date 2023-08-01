enum VideoQuality {
  speed240,
  flunt360,
  clear480,
  high720,
  high72060,
  high1080,
  high1080plus,
  high108060,
  super4K,
  hdr,
  dolbyVision,
  super8k
}

extension VideoQualityCode on VideoQuality {
  static final List<int> _codeList = [
    6,
    16,
    32,
    64,
    74,
    80,
    112,
    116,
    120,
    125,
    126,
    127,
  ];
  int get code => _codeList[index];

  static VideoQuality? fromCode(int code) {
    final index = _codeList.indexOf(code);
    if (index != -1) {
      return VideoQuality.values[index];
    }
    return null;
  }
}

extension VideoQualityDesc on VideoQuality {
  static final List<String> _descList = [
    '240P 极速',
    '360P 流畅',
    '480P 清晰',
    '720P 高清',
    '720P60 高帧率',
    '1080P 高清',
    '1080P+ 高码率',
    '1080P60 高帧率',
    '4K 超清',
    'HDR 真彩色',
    '杜比视界',
    '8K 超高清'
  ];
  get description => _descList[index];
}

///
enum AudioQuality { k64, k132, k192, dolby, hiRes }

extension AudioQualityCode on AudioQuality {
  static final List<int> _codeList = [
    30216,
    30232,
    30280,
    30250,
    30251,
  ];
  int get code => _codeList[index];

  static AudioQuality? fromCode(int code) {
    final index = _codeList.indexOf(code);
    if (index != -1) {
      return AudioQuality.values[index];
    }
    return null;
  }
}

extension AudioQualityDesc on AudioQuality {
  static final List<String> _descList = [
    '64K',
    '132K',
    '192K',
    '杜比全景声',
    'Hi-Res无损',
  ];
  get description => _descList[index];
}
