import 'dart:async';

import 'package:flutter/material.dart';

/// Custom Search input field, showing the search and clear icons.
class SearchInput extends StatefulWidget {
  /// Value changed callback for search input field
  final ValueChanged<String> onSearchInput;

  /// Border radius geometry for search input field
  final BorderRadiusGeometry? borderRadius;

  /// Optional prefix and suffix icons for input field
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  /// Hint text string for input field
  final String? hintText;

  /// Text style for hint text for input field
  final TextStyle? hintStyle;

  const SearchInput({
    super.key,
    required this.onSearchInput,
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.hintStyle,
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
        borderRadius: widget.borderRadius,
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
          hintStyle: widget.hintStyle,
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
