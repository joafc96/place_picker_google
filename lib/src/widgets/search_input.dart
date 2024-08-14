import 'dart:async';

import 'package:flutter/material.dart';

/// Custom Search input field, showing the search and clear icons.
class SearchInput extends StatefulWidget {
  final ValueChanged<String> onSearchInput;
  final BorderRadiusGeometry searchInputBorderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String hintText;

  const SearchInput({
    super.key,
    required this.onSearchInput,
    this.searchInputBorderRadius = const BorderRadius.all(
      Radius.circular(6.0),
    ),
    this.prefixIcon,
    this.suffixIcon,
    this.hintText = "Search place...",
  });

  @override
  State<StatefulWidget> createState() => SearchInputState();
}

class SearchInputState extends State<SearchInput> {
  TextEditingController editController = TextEditingController();

  Timer? debouncer;

  bool hasSearchEntry = false;

  @override
  void initState() {
    super.initState();
    editController.addListener(onSearchInputChange);
  }

  @override
  void dispose() {
    editController.removeListener(onSearchInputChange);
    editController.dispose();

    super.dispose();
  }

  void onSearchInputChange() {
    if (editController.text.isEmpty) {
      debouncer?.cancel();
      widget.onSearchInput(editController.text);
      return;
    }

    if (debouncer?.isActive ?? false) {
      debouncer?.cancel();
    }

    debouncer = Timer(const Duration(milliseconds: 500), () {
      widget.onSearchInput(editController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: widget.searchInputBorderRadius,
        color: Theme.of(context).canvasColor,
      ),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon ??
              const Icon(
                Icons.search,
              ),
          suffixIcon: hasSearchEntry
              ? GestureDetector(
                  child: widget.suffixIcon ?? const Icon(Icons.clear),
                  onTap: () {
                    editController.clear();
                    setState(() {
                      hasSearchEntry = false;
                    });
                  },
                )
              : null,
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
        controller: editController,
        onChanged: (value) {
          setState(() {
            hasSearchEntry = value.isNotEmpty;
          });
        },
      ),
    );
  }
}
