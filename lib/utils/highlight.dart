import 'package:flutter/material.dart';
import 'package:re_highlight/languages/all.dart';
import 'package:re_highlight/re_highlight.dart';
import 'package:re_highlight/styles/all.dart';

TextSpan? highlightExistingText(String text, List<String> languages) {
  final Highlight highlight = Highlight();
  highlight.registerLanguages(builtinAllLanguages);
  final HighlightResult result = highlight.highlightAuto(text, languages);
  final TextSpanRenderer renderer =
      TextSpanRenderer(const TextStyle(), builtinAllThemes['github']!);
  result.render(renderer);
  return renderer.span;
}
