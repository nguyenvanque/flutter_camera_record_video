class Language {
  static Language english = Language('en-GB', 'English (United Kingdom)');
  static Language estonian = Language('et-EE', 'Estonian');
  // TODO fill in any other languages that you like
  final String code;
  final String name;

  Language(this.code, this.name);

  @override
  String toString() {
    return 'Language{code: $code, name: $name}';
  }
}
