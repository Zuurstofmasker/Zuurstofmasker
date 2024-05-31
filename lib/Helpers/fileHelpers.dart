import 'dart:io';
import 'package:zuurstofmasker/Helpers/csvHelpers.dart';
import 'package:zuurstofmasker/Helpers/jsonHelpers.dart';

// Creation of files and folders
Future<File> createFile(String path, [bool recursive = false]) async =>
    await File(path).create(recursive: recursive);

Future<Directory> createFolder(String path, [bool recursive = false]) async =>
    await Directory(path).create(recursive: recursive);

Future<FileSystemEntity> deleteFile(String path) async =>
    await File(path).delete();

Future<bool> doesFolderOrFileExist(String path,
        [bool isFolder = false]) async =>
    isFolder ? await Directory(path).exists() : await File(path).exists();

// Reading from file
Future<String> stringFromFile(String path) async =>
    await File(path).readAsString();

// Reading from file
String stringFromFileSync(String path) => File(path).readAsStringSync();

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

// Retrieving generic from file
Future<T> getGenericFromFile<T>(
  String path, [
  JsonToObject<T> jsonToObject,
]) async =>
    jsonToGeneric<T>(await stringFromFile(path), jsonToObject);

// Retrieving list from file
Future<List<T>> getListFromFile<T>(
  String path, [
  JsonToObject<T> jsonToObject,
]) async =>
    jsonToList<T>(await stringFromFile(path), jsonToObject);

// Write map to file
Future<File> writeMapToFile(Map<String, dynamic> data, String path) async =>
    await stringToFile(path, genericToJson(data));

// Write generic to file
Future<File> writeGenericToFile<T>(T data, String path) async =>
    await stringToFile(path, genericToJson(data));

// Write list to file
Future<File> writeListToFile<T>(List<T> data, String path) async =>
    await stringToFile(path, listToJson(data));

// Append item to json in file
Future<List<T>> appendItemToListFile<T>(
  T item,
  String path, [
  JsonToObject<T> jsonToObject,
]) async =>
    await appendItemsToListFile([item], path, jsonToObject);

// Append items to json in file
Future<List<T>> appendItemsToListFile<T>(
  List<T> items,
  String path, [
  JsonToObject<T> jsonToObject,
]) async {
  // Retrieving current items
  List<T> currentItems = await getListFromFile<T>(path, jsonToObject);

  // Adding new item
  currentItems.addAll(items);

  // Updating the file
  await writeListToFile<T>(currentItems, path);

  // Returing all items
  return currentItems;
}

// Updating item by index
Future<List<T>> updateItemInListFile<T>(
  T item,
  int index,
  String path, [
  JsonToObject<T> jsonToObject,
]) async {
  // Retrieving current items
  List<T> items = await getListFromFile<T>(path, jsonToObject);

  // Updating the given item
  items[index] = item;

  // Updating the file
  await writeListToFile(items, path);

  // Returing all items
  return items;
}

// Retrieve item by index
Future<T> getItemInListFile<T>(
  int index,
  String path, [
  JsonToObject<T> jsonToObject,
]) async =>
    (await getListFromFile<T>(path, jsonToObject))[index];

// Delete item by index
Future<List<T>> deleteItemInListFile<T>(
  int index,
  String path, [
  JsonToObject<T> jsonToObject,
]) async {
  // Retrieving current items
  List<T> items = await getListFromFile<T>(path, jsonToObject);

  // Updating the given item
  items.removeAt(index);

  // Updating the file
  await writeListToFile(items, path);

  // Returing all items
  return items;
}

// Writing csv to a file
Future<File> csvToFile<T>(List<List<T>> csv, String path) async =>
    await stringToFile(path, listToCsv(csv));

// Retrieve csv from a file
Future<List<List<T>>> csvFromFile<T>(String path) async =>
    csvToList<T>(await stringFromFile(path));

// Retrieve csv from a file
List<List<T>> csvFromFileSync<T>(String path) =>
    csvToList<T>(stringFromFileSync(path));

// Apending csv to a file
Future<File> appendCsvToFile<T>(List<List<T>> csv, String path) async =>
    await appendStringToFile(path, '\n${listToCsv(csv)}');
