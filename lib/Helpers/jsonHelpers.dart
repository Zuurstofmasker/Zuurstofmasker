import 'dart:convert';

typedef JsonToObject<T> = T Function(Map<String, dynamic>)?;

T jsonToGeneric<T>(
  String json, [
  JsonToObject<T> jsonToObject,
  T? fallbackValue,
]) {
  try {
    // Decoding the json to dynamic to convert to the correct type later
    dynamic decodedJson = jsonDecode(json);

    if (jsonToObject == null) return decodedJson as T;

    // Using the given conversion method convert the json to the correct object
    if (decodedJson is! Map<String, dynamic>) return fallbackValue as T;

    return jsonToObject(decodedJson);
  } catch (e) {
    return fallbackValue as T;
  }
}

String genericToJson<T>(T value) {
  try {
    // Trying to use the toJson method on the object
    return jsonEncode(value, toEncodable: (item) {
      return (item as dynamic).toJson();
    });
  } catch (e) {
    // If no toJson method is present just try to encode it
    return jsonEncode(value);
  }
}

String listToJson<T>(List<T> items) {
  return jsonEncode(items.map((e) {
    // Trying to convert the item to a proper map format else just store the normal item.
    try {
      return (e as dynamic).toJson();
    } catch (e) {
      return e;
    }
  }).toList());
}

Map<String, dynamic> jsonToMap(
  String json, {
  Map<String, dynamic> fallbackValue = const {},
}) =>
    jsonToGeneric<Map<String, dynamic>>(json, null, fallbackValue);

List<T> jsonToList<T>(
  String json, [
  JsonToObject<T> jsonToObject,
  List<T> fallbackValue = const [],
]) {
  // Use normal conversion when the generic has a normal json type
  if (jsonToObject == null) {
    return List<T>.from(
        jsonToGeneric<List<dynamic>>(json, null, fallbackValue));
  }

  // If no conversion method is passed send the fallback value
  return List<Map<String, dynamic>>.from(jsonToGeneric<List<dynamic>>(json))
      .map((e) => jsonToObject(e))
      .toList();
}
