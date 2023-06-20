class SearchSuggestModel {
  SearchSuggestModel({
    this.tag,
    this.term,
  });

  List<SearchSuggestItem>? tag;
  String? term;

  SearchSuggestModel.fromJson(Map<String, dynamic> json) {
    tag = json['tag']
        .map<SearchSuggestItem>(
            (e) => SearchSuggestItem.fromJson(e, json['term']))
        .toList();
  }
}

class SearchSuggestItem {
  SearchSuggestItem({
    this.value,
    this.term,
    this.name,
    this.spid,
  });

  String? value;
  String? term;
  List? name;
  int? spid;

  SearchSuggestItem.fromJson(Map<String, dynamic> json, String inputTerm) {
    value = json['value'];
    term = json['term'];
    String reg = '<em class=\"suggest_high_light\">$inputTerm</em>';
    try {
      if (json['name'].indexOf(inputTerm) != -1) {
        print(json['name']);
        String str = json['name'].replaceAll(reg, '^');
        List arr = str.split('^');
        arr.insert(arr.length - 1, inputTerm);
        name = arr;
      } else {
        name = ['', '', json['term']];
      }
    } catch (err) {
      name = ['', '', json['term']];
    }

    spid = json['spid'];
  }
}
