import 'package:csv/csv.dart';

String listToCsv<T>(List<List<T>> csv) =>
    const ListToCsvConverter().convert(csv);

List<List<T>> csvToList<T>(String csv) => const CsvToListConverter()
    .convert(csv)
    .map((e) => List.castFrom<dynamic, T>(e))
    .toList();
