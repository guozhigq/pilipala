import 'package:flutter/material.dart';

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
    return Material(
      color: isSelect
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withOpacity(0.5),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: () {
            onSelect!(searchText);
          },
          onLongPress: () {
            onLongSelect!(searchText);
          },
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 11, right: 11),
            child: Text(
              searchText!,
              style: TextStyle(
                color: isSelect
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
