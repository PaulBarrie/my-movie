

class CountryEmoji {
  final Map<String, String> emojiList = {
    'en': '🇬🇧',
    'fr': '🇫🇷',
    'us': '🇺🇸'
  };
  
  String get(String countryCode) {
    return emojiList[countryCode.toLowerCase()] ?? countryCode;
  }
}