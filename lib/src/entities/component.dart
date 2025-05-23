class Component {
  static const route = 'route';
  static const locality = 'locality';
  static const administrativeArea = 'administrative_area';
  static const postalCode = 'postal_code';
  static const country = 'country';

  final String component;
  final String value;

  const Component(this.component, this.value);

  @override
  String toString() => '$component:$value';
}
