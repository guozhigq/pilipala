class HttpString {
  static const String baseUrl = 'https://www.bilibili.com';
  static const String apiBaseUrl = 'https://api.bilibili.com';
  static const String tUrl = 'https://api.vc.bilibili.com';
  static const String appBaseUrl = 'https://app.bilibili.com';
  static const String liveBaseUrl = 'https://api.live.bilibili.com';
  static const String passBaseUrl = 'https://passport.bilibili.com';
  static const List<int> validateStatusCodes = [
    302,
    304,
    307,
    400,
    401,
    403,
    404,
    405,
    409,
    412,
    500,
    503,
    504,
    509,
    616,
    617,
    625,
    626,
    628,
    629,
    632,
    643,
    650,
    652,
    658,
    662,
    688,
    689,
    701,
    799,
    8888
  ];
}
