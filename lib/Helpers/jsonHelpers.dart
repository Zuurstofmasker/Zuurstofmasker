import 'dart:convert';

T jsonToGeneric<T>(String json, [T? defaultValue]) {
  try {
    return jsonDecode(json) as T;
  } catch (e) {
    return defaultValue!;
  }
}

Map<String, dynamic> jsonToMap(String json,
        [Map<String, dynamic>? defaultValue = const {}]) =>
    jsonToGeneric<Map<String, dynamic>>(json, defaultValue);

List<T> jsonToList<T>(String json, [List<T>? defaultValue = const []]) =>
    jsonToGeneric<List<T>>(json, defaultValue);

List<T> jsonToListOpTims<T>(
    String jsonString, T Function(Map<String, dynamic>) fromJson) {
  final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
  return parsed.map<T>((jsonString) => fromJson(jsonString)).toList();
}
