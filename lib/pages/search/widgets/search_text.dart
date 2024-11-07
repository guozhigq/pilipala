import 'package:flutter/material.dart';
import 'package:pilipala/utils/feed_back.dart';

class SearchText extends StatelessWidget {
  final String? searchText;
  final Function? onSelect;
  final int? searchTextIdx;
  final Function? onLongSelect;
  final bool isSelect;
  const SearchText({
    super.key,
    this.searchText,
    this.onSelect,
    this.searchTextIdx,
    this.onLongSelect,
    this.isSelect = false,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: isSelect
          ? colorScheme.primaryContainer
          : colorScheme.surfaceVariant.withOpacity(0.5),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: () {
            onSelect?.call(searchText);
          },
          onLongPress: () {
            feedBack();
            onLongSelect?.call(searchText);
          },
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 11),
            child: Text(
              searchText!,
              style: TextStyle(
                color: isSelect
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
