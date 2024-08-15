import 'package:flutter/material.dart';
import 'package:place_picker_google/src/entities/index.dart';

class RichSuggestion extends StatelessWidget {
  final VoidCallback? onTap;
  final AutoCompleteItem autoCompleteItem;

  const RichSuggestion({
    super.key,
    required this.autoCompleteItem,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: RichText(
          text: TextSpan(
            children: getStyledTexts(context),
          ),
        ),
      ),
    );
  }

  List<TextSpan> getStyledTexts(BuildContext context) {
    final List<TextSpan> result = [];
    const style = TextStyle(color: Colors.grey, fontSize: 15);

    final startText =
        autoCompleteItem.text?.substring(0, autoCompleteItem.offset);
    if (startText?.isNotEmpty == true) {
      result.add(TextSpan(text: startText, style: style));
    }

    final boldText = autoCompleteItem.text?.substring(
      autoCompleteItem.offset!,
      autoCompleteItem.offset! + autoCompleteItem.length!,
    );
    result.add(
      TextSpan(
        text: boldText,
        style:
            style.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
    );

    final remainingText = autoCompleteItem.text
        ?.substring(autoCompleteItem.offset! + autoCompleteItem.length!);
    result.add(
      TextSpan(text: remainingText, style: style),
    );

    return result;
  }
}
