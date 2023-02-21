enum DateTimeComponentEnum { time, dayOfMonthAndTime, dayOfWeekAndTime, year }

extension CategoryX on DateTimeComponentEnum {
  String get displayName {
    switch (this) {
      case DateTimeComponentEnum.time:
        return "Repeat Specific day of month and time";
      case DateTimeComponentEnum.dayOfWeekAndTime:
        return "Repeat Specific Day and Time";
      case DateTimeComponentEnum.dayOfMonthAndTime:
        return "Repeat Daily";
      case DateTimeComponentEnum.year:
        return "Repeat Specific year and time";
      default:
        return name;
    }
  }
}

enum Repeat { one, two, three, four, five, six }

extension Repeatx on Repeat {
  String get displayName {
    switch (this) {
      case Repeat.one:
        return "1";
      case Repeat.two:
        return "2";
      case Repeat.three:
        return "3";
      case Repeat.four:
        return "4";
      case Repeat.five:
        return "5";
      case Repeat.six:
        return "6";
      default:
        return name;
    }
  }
}
