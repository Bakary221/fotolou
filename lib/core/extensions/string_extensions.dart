extension NullableStringX on String? {
  bool get isBlank => this == null || this!.trim().isEmpty;
}
