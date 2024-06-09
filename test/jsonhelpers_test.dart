import 'package:flutter_test/flutter_test.dart';
import 'package:zuurstofmasker/Helpers/jsonHelpers.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'dart:convert';

void main() {
  group('jsonToGeneric', () {
    test('should convert JSON string to a Map', () {
      final jsonString = '{"id": "123", "nameMother": "Jane Doe"}';
      final result = jsonToGeneric<Map<String, dynamic>>(jsonString);

      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], '123');
      expect(result['nameMother'], 'Jane Doe');
    });

    test('should convert JSON string to a Session object', () {
      final jsonString = '''
        {
          "id": "123",
          "weight": 3000,
          "babyId": "456",
          "nameMother": "Jane Doe",
          "birthTime": ${DateTime(2023, 1, 1, 12, 0, 0).millisecondsSinceEpoch},
          "endTime": ${DateTime(2023, 1, 1, 14, 0, 0).millisecondsSinceEpoch},
          "note": "Healthy baby",
          "roomNumber": 101
        }
      ''';

      final result = jsonToGeneric<Session>(
        jsonString,
        (json) => Session.fromJson(json),
      );

      expect(result, isA<Session>());
      expect(result.id, '123');
      expect(result.weight, 3000);
      expect(result.babyId, '456');
      expect(result.nameMother, 'Jane Doe');
      expect(result.birthDateTime, DateTime(2023, 1, 1, 12, 0, 0));
      expect(result.endDateTime, DateTime(2023, 1, 1, 14, 0, 0));
      expect(result.note, 'Healthy baby');
      expect(result.roomNumber, 101);
    });
  });

  group('genericToJson', () {
    test('should convert a Session object to JSON string', () {
      final session = Session(
        id: '123',
        weight: 3000,
        babyId: '456',
        nameMother: 'Jane Doe',
        birthDateTime: DateTime(2023, 1, 1, 12, 0, 0),
        endDateTime: DateTime(2023, 1, 1, 14, 0, 0),
        note: 'Healthy baby',
        roomNumber: 101,
      );

      final jsonString = genericToJson<Session>(session);

      final jsonMap = jsonDecode(jsonString);

      expect(jsonMap['id'], '123');
      expect(jsonMap['weight'], 3000);
      expect(jsonMap['babyId'], '456');
      expect(jsonMap['nameMother'], 'Jane Doe');
      expect(jsonMap['birthTime'],
          DateTime(2023, 1, 1, 12, 0, 0).millisecondsSinceEpoch);
      expect(jsonMap['endTime'],
          DateTime(2023, 1, 1, 14, 0, 0).millisecondsSinceEpoch);
      expect(jsonMap['note'], 'Healthy baby');
      expect(jsonMap['roomNumber'], 101);
    });
  });

  group('listToJson', () {
    test('should convert a list of Session objects to JSON string', () {
      final sessions = [
        Session(
          id: '123',
          weight: 3000,
          babyId: '456',
          nameMother: 'Jane Doe',
          birthDateTime: DateTime(2023, 1, 1, 12, 0, 0),
          endDateTime: DateTime(2023, 1, 1, 14, 0, 0),
          note: 'Healthy baby',
          roomNumber: 101,
        ),
        Session(
          id: '124',
          weight: 3200,
          babyId: '457',
          nameMother: 'Alice Smith',
          birthDateTime: DateTime(2023, 2, 1, 12, 0, 0),
          endDateTime: DateTime(2023, 2, 1, 14, 0, 0),
          note: 'Healthy baby',
          roomNumber: 102,
        ),
      ];

      final jsonString = listToJson<Session>(sessions);
      final jsonList = jsonDecode(jsonString);

      expect(jsonList, isA<List>());
      expect(jsonList[0]['id'], '123');
      expect(jsonList[1]['id'], '124');
    });
  });

  group('jsonToMap', () {
    test('should convert JSON string to a Map', () {
      final jsonString = '{"id": "123", "nameMother": "Jane Doe"}';
      final result = jsonToMap(jsonString);

      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], '123');
      expect(result['nameMother'], 'Jane Doe');
    });

    test('should return fallback value if JSON string is invalid', () {
      final jsonString = 'invalid json';
      final fallbackValue = {'error': 'Invalid JSON'};
      final result = jsonToMap(jsonString, fallbackValue: fallbackValue);

      expect(result, fallbackValue);
    });
  });

  group('jsonToList', () {
    test('should convert JSON string to a list of Session objects', () {
      final jsonString = '''
        [
          {
            "id": "123",
            "weight": 3000,
            "babyId": "456",
            "nameMother": "Jane Doe",
            "birthTime": ${DateTime(2023, 1, 1, 12, 0, 0).millisecondsSinceEpoch},
            "endTime": ${DateTime(2023, 1, 1, 14, 0, 0).millisecondsSinceEpoch},
            "note": "Healthy baby",
            "roomNumber": 101
          },
          {
            "id": "124",
            "weight": 3200,
            "babyId": "457",
            "nameMother": "Alice Smith",
            "birthTime": ${DateTime(2023, 2, 1, 12, 0, 0).millisecondsSinceEpoch},
            "endTime": ${DateTime(2023, 2, 1, 14, 0, 0).millisecondsSinceEpoch},
            "note": "Healthy baby",
            "roomNumber": 102
          }
        ]
      ''';

      final result = jsonToList<Session>(
        jsonString,
        (json) => Session.fromJson(json),
      );

      expect(result, isA<List<Session>>());
      expect(result.length, 2);
      expect(result[0].id, '123');
      expect(result[1].id, '124');
    });

    test('should return fallback value if JSON string is invalid', () {
      final jsonString = 'invalid json';
      final fallbackValue = <Session>[];
      final result = jsonToList<Session>(jsonString, null, fallbackValue);

      expect(result, fallbackValue);
    });
  });
}
