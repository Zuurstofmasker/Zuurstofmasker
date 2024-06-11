import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/Models/session.dart';

void main() {
  group('File Operations', () {
    const testFilePath = 'test_file.json';
    const testFolderPath = 'test_folder';

    setUp(() async {
      // Create a test folder
      await createFolder(testFolderPath, true);
    });

    tearDown(() async {
      // Clean up test files and folders
      if (await doesFolderOrFileExist(testFilePath)) {
        await deleteFile(testFilePath);
      }
      if (await doesFolderOrFileExist(testFolderPath, true)) {
        await Directory(testFolderPath).delete(recursive: true);
      }
    });

    test('Create and delete file', () async {
      await createFile(testFilePath);
      expect(await doesFolderOrFileExist(testFilePath), true);

      await deleteFile(testFilePath);
      expect(await doesFolderOrFileExist(testFilePath), false);
    });

    test('Write and read string from file', () async {
      const content = 'Hello, World!';
      await stringToFile(testFilePath, content);
      final result = await stringFromFile(testFilePath);
      expect(result, content);
    });

    test('Append string to file', () async {
      const initialContent = 'Hello';
      const appendedContent = ', World!';
      await stringToFile(testFilePath, initialContent);
      await appendStringToFile(testFilePath, appendedContent);
      final result = await stringFromFile(testFilePath);
      expect(result, initialContent + appendedContent);
    });

    test('Write and read JSON map from file', () async {
      final session = Session(
        id: '123',
        weight: 3,
        babyId: 'baby_1',
        nameMother: 'Jane Doe',
        birthDateTime: DateTime.now(),
        endDateTime: DateTime.now().add(const Duration(hours: 1)),
        note: 'Note',
        roomNumber: 101,
      );
      await writeMapToFile(session.toJson(), testFilePath);
      final result = await getMapFromFile(testFilePath);
      expect(result, session.toJson());
    });

    test('Append item to JSON list in file', () async {
      final session1 = Session(
        id: '123',
        weight: 3,
        babyId: 'baby_1',
        nameMother: 'Jane Doe',
        birthDateTime: DateTime.now(),
        endDateTime: DateTime.now().add(const Duration(hours: 1)),
        note: 'Note',
        roomNumber: 101,
      );
      final session2 = Session(
        id: '124',
        weight: 4,
        babyId: 'baby_2',
        nameMother: 'Mary Smith',
        birthDateTime: DateTime.now(),
        endDateTime: DateTime.now().add(const Duration(hours: 2)),
        note: 'Another note',
        roomNumber: 102,
      );

      await writeListToFile([session1], testFilePath);
      final result =
          await appendItemToListFile(session2, testFilePath, Session.fromJson);
      expect(result.length, 2);
      expect(result[1].id, session2.id);
    });

    test('Update item in JSON list in file', () async {
      final session1 = Session(
        id: '123',
        weight: 3,
        babyId: 'baby_1',
        nameMother: 'Jane Doe',
        birthDateTime: DateTime.now(),
        endDateTime: DateTime.now().add(const Duration(hours: 1)),
        note: 'Note',
        roomNumber: 101,
      );
      final session2 = Session(
        id: '124',
        weight: 4,
        babyId: 'baby_2',
        nameMother: 'Mary Smith',
        birthDateTime: DateTime.now(),
        endDateTime: DateTime.now().add(const Duration(hours: 2)),
        note: 'Another note',
        roomNumber: 102,
      );

      await writeListToFile([session1, session2], testFilePath);

      final updatedSession2 = Session(
        id: '124',
        weight: 4,
        babyId: 'baby_2',
        nameMother: 'Mary Smith',
        birthDateTime: DateTime.now(),
        endDateTime: DateTime.now().add(const Duration(hours: 3)),
        note: 'Updated note',
        roomNumber: 102,
      );

      final result = await updateItemInListFile(
          updatedSession2, 1, testFilePath, Session.fromJson);
      expect(result[1].weight, updatedSession2.weight);
      expect(result[1].note, updatedSession2.note);
    });

    test('Delete item from JSON list in file', () async {
      final session1 = Session(
        id: '123',
        weight: 3,
        babyId: 'baby_1',
        nameMother: 'Jane Doe',
        birthDateTime: DateTime.now(),
        endDateTime: DateTime.now().add(const Duration(hours: 1)),
        note: 'Note',
        roomNumber: 101,
      );
      final session2 = Session(
        id: '124',
        weight: 4,
        babyId: 'baby_2',
        nameMother: 'Mary Smith',
        birthDateTime: DateTime.now(),
        endDateTime: DateTime.now().add(const Duration(hours: 2)),
        note: 'Another note',
        roomNumber: 102,
      );

      await writeListToFile([session1, session2], testFilePath);
      final result =
          await deleteItemInListFile(0, testFilePath, Session.fromJson);
      expect(result.length, 1);
      expect(result[0].id, session2.id);
    });

    test('Write and read CSV from file', () async {
      final csvData = [
        ['ID', 'Name', 'LastName'],
        [1, 'Alice', 'Alice2'],
        [2, 'Bob', 'Bob2'],
      ];
      await csvToFile(csvData, testFilePath);
      final result = await csvFromFile(testFilePath);
      expect(result, csvData);
    });
  });
}
