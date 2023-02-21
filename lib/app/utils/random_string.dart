import 'dart:math';

class RandomStringGenerator {
  static const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static Random rnd = Random();

  static String getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => chars.codeUnitAt(
            rnd.nextInt(chars.length),
          ),
        ),
      );
}
