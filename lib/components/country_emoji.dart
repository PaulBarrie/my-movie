class CountryEmoji {
  static final Map<String, String> emojiList = {
    'en': '🇬🇧',
    'fr': '🇫🇷',
    'us': '🇺🇸'
  };

  static String get(String countryCode) {
    return emojiList[countryCode.toLowerCase()] ?? countryCode;
  }
}
