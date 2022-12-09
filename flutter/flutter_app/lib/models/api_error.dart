class ApiError {
  String? error;

  ApiError(String this.error);

  ApiError.fromJson(Map<String, dynamic> json) {
    error = json["body"][0]["message"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = error;
    return data;
  }
}
