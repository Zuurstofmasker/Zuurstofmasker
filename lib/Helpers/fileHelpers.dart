import 'dart:convert';
import 'dart:io';
import 'package:zuurstofmasker/Helpers/csvHelpers.dart';
import 'package:zuurstofmasker/Helpers/jsonHelpers.dart';

// Reading from file
Future<String> stringFromFile(String path) async =>
    await File(path).readAsString();

// Writing to file
Future<File> stringToFile(String path, String data,
        [FileMode fileMode = FileMode.write]) async =>
    await File(path).writeAsString(data, mode: fileMode);

// Appending to file
Future<File> appendStringToFile(String path, String content) async =>
    await stringToFile(path, content, FileMode.append);

// Retrieving map from file
Future<Map<String, dynamic>> getMapFromFile(String path) async =>
    jsonToMap(await stringFromFile(path));

// Retrieving list from file
Future<List<T>> getListFromFile<T>(String path) async =>
    jsonToList<T>(await stringFromFile(path));

// Write map to file
Future<File> writeMapToFile(Map<String, dynamic> data, String path) async =>
    await stringToFile(path, jsonEncode(data));

// Write list to file
Future<File> writeListToFile<T>(List<T> data, String path) async =>
    await stringToFile(path, jsonEncode(data));

// Append item to json in file
Future<List<T>> appendItemToListFile<T>(T item, String path) async =>
    await appendItemsToListFile([item], path);

// Append items to json in file
Future<List<T>> appendItemsToListFile<T>(List<T> items, String path) async {
  // Retrieving current items
  List<T> items = await getListFromFile<T>(path);

  // Adding new item
  items.addAll(items);

  // Updating the file
  writeListToFile(items, path);

  // Returing all items
  return items;
}

// Updating item by index
Future<List<T>> updateItemInListFile<T>(T item, int index, String path) async {
  // Retrieving current items
  List<T> items = await getListFromFile<T>(path);

  // Updating the given item
  items[index] = item;

  // Updating the file
  writeListToFile(items, path);

  // Returing all items
  return items;
}

// Retrieve item by index
Future<T> getItemInListFile<T>(int index, String path) async =>
    (await getListFromFile<T>(path))[index];

// Delete item by index
Future<List<T>> deleteItemInListFile<T>(int index, String path) async {
  // Retrieving current items
  List<T> items = await getListFromFile<T>(path);

  // Updating the given item
  items.removeAt(index);

  // Updating the file
  writeListToFile(items, path);

  // Returing all items
  return items;
}

// Writing csv to a file
Future<File> csvToFile<T>(List<List<T>> csv, String path) async =>
    await stringToFile(path, listToCsv(csv));

// Retrieve csv from a file
Future<List<List<T>>> csvFromFile<T>(String path) async =>
    csvToList<T>(await stringFromFile(path));

// Apending csv to a file
Future<File> appendCsvToFile<T>(List<List<T>> csv, String path) async =>
    await appendStringToFile(path, '\n${listToCsv(csv)}');

Future<FileSystemEntity> deleteFile(String path) async =>
    await File(path).delete();
