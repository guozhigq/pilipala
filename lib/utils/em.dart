class Em {
  static regCate(String origin) {
    String str = origin;
    RegExp exp = RegExp('<[^>]*>([^<]*)</[^>]*>');
    Iterable<Match> matches = exp.allMatches(origin);
    for (Match match in matches) {
      str = match.group(1)!;
    }
    return str;
  }

  static regTitle(String origin) {
    RegExp exp = RegExp('<[^>]*>([^<]*)</[^>]*>');
    List res = [];
    origin.splitMapJoin(exp, onMatch: (Match match) {
      String matchStr = match[0]!;
      Map map = {'type': 'em', 'text': regCate(matchStr)};
      res.add(map);
      return regCate(matchStr);
    }, onNonMatch: (String str) {
      if (str != '') {
        str = str
            .replaceAll('&lt;', '<')
            .replaceAll('&gt;', '>')
            .replaceAll('&#34;', '"')
            .replaceAll('&#39;', "'")
            .replaceAll('&quot;', '"')
            .replaceAll('&apos;', "'")
            .replaceAll('&nbsp;', " ")
            .replaceAll('&amp;', "&");
        Map map = {'type': 'text', 'text': str};
        res.add(map);
      }
      return str;
    });
    return res;
  }
}
