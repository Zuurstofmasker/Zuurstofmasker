import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:zuurstofmasker/Helpers/sessionHelpers.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/config.dart';

// Hulpfuncties voor het instellen van testbestanden en directories
Future<String> createTempDir(String prefix) async {
  final tempDir = await Directory.systemTemp.createTemp(prefix);
  return tempDir.path;
}

void main() {
  group('Session Tests', () {
    test('getSessions returns a list of sessions', () async {
      var tempDir0 = await createTempDir("0000");

      var tempSessionsJsonPath = p.join(tempDir0, 'sessions.json');
      sessionPath = "$tempDir0\\";
      sessionsJsonPath = '${sessionPath}sessions.json';
      final sessionsJson = jsonEncode([
        {
          'id': '1',
          'weight': 3500,
          'nameMother': 'Jane Doe',
          'note': 'Healthy baby',
          'birthTime': DateTime.now().millisecondsSinceEpoch,
          'endTime': DateTime.now().millisecondsSinceEpoch,
          'roomNumber': 101
        }
      ]);
      await File(tempSessionsJsonPath).writeAsString(sessionsJson);

      var sessions = await getSessions();
      expect(sessions, isA<List<Session>>());
      expect(sessions.length, 1);
      expect(sessions[0].nameMother, 'Jane Doe');
    });

    test('getNewSessionUuid generates a unique UUID', () async {
      var tempDir1 = await createTempDir("1111");
      var tempSessionsJsonPath = p.join(tempDir1, 'sessions.json');
      sessionPath = "$tempDir1\\";
      sessionsJsonPath = '${sessionPath}sessions.json';
      final existingSessions = [
        Session(
          id: 'existing-uuid',
          weight: 3500,
          nameMother: 'Jane Doe',
          note: 'Healthy baby',
          birthDateTime: DateTime.now(),
          endDateTime: DateTime.now(),
          roomNumber: 101,
        )
      ];
      final sessionsJson =
          jsonEncode(existingSessions.map((s) => s.toJson()).toList());
      await File(tempSessionsJsonPath).writeAsString(sessionsJson);

      var newUuid = await getNewSessionUuid();
      expect(newUuid, isNotNull);
      expect(newUuid, isNot(anyOf(existingSessions.map((s) => s.id))));
    });

    test('createSession creates a session with correct files', () async {
      var tempDir2 = await createTempDir("2222");

      var tempSessionsJsonPath = p.join(tempDir2, 'sessions.json');
      sessionPath = "$tempDir2\\";
      sessionsJsonPath = '${sessionPath}sessions.json';
      final session = Session(
        id: 'new-uuid',
        weight: 3500,
        nameMother: 'Jane Doe',
        note: 'Healthy baby',
        birthDateTime: DateTime.now(),
        endDateTime: DateTime.now(),
        roomNumber: 101,
      );
      final sessionPath2 = p.join(tempDir2, session.id);
      await createFile('$tempDir2/sessions.json');
      stringToFile('$tempDir2/sessions.json', "[]");

      var sessions = await createSession(session);
      expect(sessions, isA<List<Session>>());
      expect(sessions.length, 1);
      expect(sessions[0].id, session.id);

      final sessionDir = Directory(sessionPath2);
      expect(await sessionDir.exists(), isTrue);
      expect(await File('$sessionPath2/videoNotes.json').exists(), isTrue);
      expect(await File('$sessionPath2/recordedData.csv').exists(), isTrue);
    });

    test('updateSession updates an existing session', () async {
      var tempDir3 = await createTempDir("33333");

      var tempSessionsJsonPath = p.join(tempDir3, 'sessions.json');
      sessionPath = "$tempDir3\\";
      sessionsJsonPath = '${sessionPath}sessions.json';

      final session = Session(
        id: 'existing-uuid',
        weight: 3500,
        nameMother: 'Jane Doe',
        note: 'Healthy baby',
        birthDateTime: DateTime.now(),
        endDateTime: DateTime.now(),
        roomNumber: 101,
      );
      final updatedSession = Session(
        id: 'existing-uuid',
        weight: 3600,
        nameMother: 'Jane Doe',
        note: 'Baby gained weight',
        birthDateTime: DateTime.now(),
        endDateTime: DateTime.now(),
        roomNumber: 101,
      );
      final sessionsJson = jsonEncode([session.toJson()]);
      await createFile('$tempDir3/sessions.json');
      stringToFile('$tempDir3/sessions.json', "[]");
      await File(tempSessionsJsonPath).writeAsString(sessionsJson);

      await updateSession(updatedSession);

      final updatedSessions =
          jsonDecode(await File(tempSessionsJsonPath).readAsString()) as List;
      expect(updatedSessions.length, 1);
      expect(updatedSessions[0]['weight'], updatedSession.weight);
    });
  });
}
