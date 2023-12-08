/// Returns whether a dynamic value PROBABLY
/// has the isEmpty getter/method by checking
/// standard dart types that contains it.
///
/// This is here to for the 'DRY'
bool? _isEmpty(dynamic value) {
  if (value is String) {
    return value.trim().isEmpty;
  }
  if (value is Iterable || value is Map) {
    // ignore: avoid_dynamic_calls
    return value.isEmpty as bool?;
  }
  return false;
}

/// This class is used for reducing the boilerplate code for the extensions that'd in the boilerplate.
/// With the help of this class, Users will be able to write extensions much more faster.
class ExtensionUtils {
  ExtensionUtils._();

  /// Checks if string is URL.
  static bool isURL(String s) => hasMatch(
        s,
        r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,7}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-]+))*$",
      );

  /// Capitalize each word inside string
  /// Example: your name => Your Name, your name => Your name
  static String capitalize(String value) {
    if (isBlank(value)!) return value;
    return value.split(' ').map(capitalizeFirst).join(' ');
  }

  /// Uppercase first letter inside string and let the others lowercase
  /// Example: your name => Your name
  static String capitalizeFirst(String s) {
    if (isBlank(s)!) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  /// Remove all whitespace inside string
  /// Example: your name => yourname
  static String removeAllWhitespace(String value) {
    return value.replaceAll(' ', '');
  }

  /// Camelcase string
  /// Example: your name => yourName
  static String? camelCase(String value) {
    if (isNullOrBlank(value)!) {
      return null;
    }

    final separatedWords = value.split(RegExp(r'[!@#<>?":`~;[\]\\|=+)(*&^%-\s_]+'));
    var newString = '';

    for (final word in separatedWords) {
      // ignore: use_string_buffers
      newString += word[0].toUpperCase() + word.substring(1).toLowerCase();
    }

    return newString[0].toLowerCase() + newString.substring(1);
  }

  /// param-case
  static String? paramCase(String? text) => snakeCase(text, separator: '-');

  /// snake_case
  static String? snakeCase(String? text, {String separator = '_'}) {
    if (isNullOrBlank(text)!) {
      return null;
    }
    return _groupIntoWords(text!).map((word) => word.toLowerCase()).join(separator);
  }

  /// Checks if data is null or blank (empty or only contains whitespace).
  static bool? isNullOrBlank(dynamic value) {
    if (isNull(value)) {
      return true;
    }

    // Pretty sure that isNullOrBlank should be validating
    // iterables... but I'm going to keep this for compatibility.
    return _isEmpty(value);
  }

  /// Checks if data is null.
  static bool isNull(dynamic value) => value == null;

  /// Checks if data is null or blank (empty or only contains whitespace).
  static bool? isBlank(dynamic value) {
    return _isEmpty(value);
  }

  /// credits to "ReCase" package.
  static final RegExp _upperAlphaRegex = RegExp('[A-Z]');
  static final _symbolSet = {' ', '.', '/', '_', r'\', '-'};
  static List<String> _groupIntoWords(String text) {
    final sb = StringBuffer();
    final words = <String>[];
    final isAllCaps = text.toUpperCase() == text;

    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      final nextChar = i + 1 == text.length ? null : text[i + 1];
      if (_symbolSet.contains(char)) {
        continue;
      }
      sb.write(char);
      final isEndOfWord = nextChar == null ||
          (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
          _symbolSet.contains(nextChar);
      if (isEndOfWord) {
        words.add('$sb');
        sb.clear();
      }
    }
    return words;
  }

  static bool hasMatch(String? value, String pattern) {
    return (value == null) ? false : RegExp(pattern).hasMatch(value);
  }

  static String createPath(String path, [Iterable? segments]) {
    if (segments == null || segments.isEmpty) {
      return path;
    }
    final list = segments.map((e) => '/$e');
    return path + list.join();
  }
}
