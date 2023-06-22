import 'package:flutter/material.dart';

class SearchText extends StatelessWidget {
  String? searchText;
  Function? onSelect;
  int? searchTextIdx;
  SearchText({super.key, this.searchText, this.onSelect, this.searchTextIdx});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: () {
            onSelect!(searchText);
          },
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 11, right: 11),
            child: Text(
              searchText!,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ),
      ),
    );
  }
}
