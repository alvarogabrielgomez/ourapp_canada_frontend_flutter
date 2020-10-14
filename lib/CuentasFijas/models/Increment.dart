class Increment {
  Increment({
    this.sign,
    this.value,
  });

  String sign;
  double value;

  factory Increment.fromJson(Map<String, dynamic> json) => Increment(
        sign: json["sign"],
        value: json["value"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "sign": sign,
        "value": value,
      };
}
