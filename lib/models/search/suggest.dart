import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    this.spid,
    this.textRich,
  });

  String? value;
  String? term;
  int? spid;
  Widget? textRich;

  SearchSuggestItem.fromJson(Map<String, dynamic> json, String inputTerm) {
    value = json['value'];
    term = json['term'];
    textRich = highlightText(json['name']);
  }
}

Widget highlightText(String str) {
  // 创建正则表达式，匹配 <em class="suggest_high_light">...</em> 格式的文本
  RegExp regex = RegExp(r'<em class="suggest_high_light">(.*?)<\/em>');

  // 用于存储每个匹配项的列表
  List<InlineSpan> children = [];

  // 获取所有匹配项
  Iterable<Match> matches = regex.allMatches(str);

  // 当前索引位置
  int currentIndex = 0;

  // 遍历每个匹配项
  for (var match in matches) {
    // 获取当前匹配项之前的普通文本部分
    String normalText = str.substring(currentIndex, match.start);

    // 获取需要高亮显示的文本部分
    String highlightedText = match.group(1)!;

    // 如果普通文本部分不为空，则将其添加到 children 列表中
    if (normalText.isNotEmpty) {
      children.add(TextSpan(
        text: normalText,
        style: DefaultTextStyle.of(Get.context!).style,
      ));
    }

    // 将需要高亮显示的文本部分添加到 children 列表中，并设置相应样式
    children.add(TextSpan(
      text: highlightedText,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(Get.context!).colorScheme.primary),
    ));

    // 更新当前索引位置
    currentIndex = match.end;
  }

  // 如果当前索引位置小于文本长度，表示还有剩余的普通文本部分
  if (currentIndex < str.length) {
    String remainingText = str.substring(currentIndex);

    // 将剩余的普通文本部分添加到 children 列表中
    children.add(TextSpan(
      text: remainingText,
      style: DefaultTextStyle.of(Get.context!).style,
    ));
  }

  // 使用 Text.rich 创建包含高亮显示的富文本小部件，并返回
  return Text.rich(TextSpan(children: children));
}
