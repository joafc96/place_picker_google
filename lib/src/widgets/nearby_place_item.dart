import 'package:material_ui/material_ui.dart';
import 'package:place_picker_google/src/entities/index.dart';

class NearbyPlaceItem extends StatelessWidget {
  static const _fallbackIcon = Icon(Icons.place, size: 16);

  final NearbyPlace nearbyPlace;
  final VoidCallback onTap;
  final TextStyle? nearbyPlaceStyle;

  const NearbyPlaceItem({
    super.key,
    required this.nearbyPlace,
    required this.onTap,
    this.nearbyPlaceStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: <Widget>[
            _buildIcon(),
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                "${nearbyPlace.name}",
                style: nearbyPlaceStyle ?? const TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (nearbyPlace.icon == null) {
      return _fallbackIcon;
    }

    final bgColor = _parseHexColor(nearbyPlace.iconBackgroundColor);

    final iconImage = Image.network(
      nearbyPlace.icon!,
      width: 16,
      height: 16,
      color: bgColor != null ? Colors.white : null,
      errorBuilder: (_, __, ___) => _fallbackIcon,
    );

    if (bgColor == null) return iconImage;

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(4),
      child: iconImage,
    );
  }

  static Color? _parseHexColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    final digits = hex.startsWith('#') ? hex.substring(1) : hex;
    final withAlpha = digits.length == 6 ? 'FF$digits' : digits;
    final value = int.tryParse(withAlpha, radix: 16);
    return value != null ? Color(value) : null;
  }
}
