class Calculate {
  String calculate;
  String date;

  Calculate({required this.calculate, required this.date});

  Map<String, dynamic> toJson() {
    return {
      'calculate': calculate,
      'date': date,
    };
  }

  factory Calculate.fromJson(Map json) {
    return Calculate(
      calculate: json['calculate'],
      date: json['date'],
    );
  }
}
