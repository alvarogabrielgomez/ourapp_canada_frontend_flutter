import 'dart:convert';

RestResponse restResponseFromJson(String str) =>
    RestResponse.fromJson(json.decode(str));

String restResponseToJson(RestResponse data) => json.encode(data.toJson());

class RestResponse {
  String message;
  int statuscode;
  bool success;
  dynamic value;

  RestResponse({this.message, this.success, this.statuscode, this.value});
  factory RestResponse.newObject() =>
      RestResponse(message: "", statuscode: 0, success: false, value: null);

  factory RestResponse.fromJson(Map<String, dynamic> json) => RestResponse(
        message: json["message"],
        success: json["success"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
        "value": value,
      };
}
