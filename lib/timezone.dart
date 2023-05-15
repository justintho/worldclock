//Defining a timezone class
class TimeZone {
  String name;
  String fullName;
  String offsetLabel;
  int offsetHour;
  int offsetMin;
  bool isOn;
  TimeZone(this.name, this.fullName, this.offsetLabel, this.offsetHour, this.offsetMin, this.isOn);

  //Converts from JSON to TimeZone object
  factory TimeZone.fromJson(dynamic json) {
    return TimeZone(
      json['name'] as String,
      json['fullName'] as String,
      json['offsetLabel'] as String,
      json['offsetHour'] as int,
      json['offsetMin'] as int,
      json['isOn'] as bool,
    );
  }

  //Converts TimeZone object to JSON to easily save data via shared preferences
  Map toJson() {
    return {
      'name': name,
      'fullName': fullName,
      'offsetLabel': offsetLabel,
      'offsetHour': offsetHour,
      'offsetMin': offsetMin,
      'isOn': isOn
    };
  }
}