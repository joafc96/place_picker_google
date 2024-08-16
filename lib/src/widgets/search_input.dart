import 'dart:async';

import 'package:flutter/material.dart';
import 'package:place_picker_google/place_picker_google.dart';

/// Custom Search input field, showing the search and clear icons.
class SearchInput extends StatefulWidget {
  /// Value changed callback for search input field
  final ValueChanged<String> onSearchInput;

  ///  Search input decoration config
  final SearchInputDecorationConfig config;

  /// Whether the search input be auto focused or not
  final bool autoFocus;

  final TextStyle? style;



  const SearchInput({
    super.key,
    required this.onSearchInput,
    required this.config,
    this.autoFocus = false,
    this.style,
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
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      autofocus: widget.autoFocus,
      style: widget.style,
      decoration: InputDecoration(
        label: widget.config.label,
        labelText: widget.config.labelText,
        labelStyle: widget.config.labelStyle,
        helperText: widget.config.helperText,
        helperStyle: widget.config.helperStyle,
        helperMaxLines: widget.config.helperMaxLines,
        hintText: widget.config.hintText,
        hintStyle: widget.config.hintStyle,
        hintTextDirection: widget.config.hintTextDirection,
        hintFadeDuration: widget.config.hintFadeDuration,
        hintMaxLines: widget.config.hintMaxLines,
        prefixIcon: widget.config.prefixIcon ??
            const Icon(
              Icons.search,
            ),
        prefixIconConstraints: widget.config.prefixIconConstraints,
        prefixIconColor: widget.config.prefixIconColor,
        prefixText: widget.config.prefixText,
        prefixStyle: widget.config.prefixStyle,
        suffixIcon: hasSearchEntry
            ? GestureDetector(
                child: widget.config.suffixIcon ?? const Icon(Icons.clear),
                onTap: () {
                  editController.clear();
                  setState(() {
                    hasSearchEntry = false;
                  });
                },
              )
            : null,
        suffixIconConstraints: widget.config.suffixIconConstraints,
        suffixIconColor: widget.config.suffixIconColor,
        suffixText: widget.config.suffixText,
        suffixStyle: widget.config.suffixStyle,
        errorBorder: widget.config.errorBorder,
        focusedBorder: widget.config.focusedBorder,
        focusedErrorBorder: widget.config.focusedErrorBorder,
        disabledBorder: widget.config.disabledBorder,
        enabledBorder: widget.config.enabledBorder,
        border: widget.config.border ?? InputBorder.none,
        isDense: widget.config.isDense,
        filled: widget.config.filled,
        fillColor: widget.config.fillColor ?? Theme.of(context).canvasColor,
        contentPadding: widget.config.contentPadding,
        enabled: widget.config.enabled,
        constraints: widget.config.constraints,
      ),
      controller: editController,
      onChanged: (value) {
        setState(() {
          hasSearchEntry = value.isNotEmpty;
        });
      },
    );
  }
}
