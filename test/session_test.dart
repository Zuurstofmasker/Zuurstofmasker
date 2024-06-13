import 'package:flutter_test/flutter_test.dart';
import 'package:zuurstofmasker/Models/session.dart';

void main() {
  test('Test Session to JSON conversion', () {
    var time = DateTime(2023, 1, 1, 10, 0).toUtc();
    var time2 = DateTime(2023, 1, 1, 11, 0).toUtc();

    // Create a sample session
    final session = Session(
      id: '123',
      weight: 3500,
      babyId: '456',
      nameMother: 'Alice',
      note: 'This is a test session',
      birthDateTime: time,
      endDateTime: time2,
      roomNumber: 101,
    );

    // Convert the session to a JSON map
    final jsonMap = session.toJson();

    // Check if the values are correct
    expect(jsonMap['id'], '123');
    expect(jsonMap['weight'], 3500);
    expect(jsonMap['babyId'], '456');
    expect(jsonMap['nameMother'], 'Alice');
    expect(jsonMap['note'], 'This is a test session');
    expect(jsonMap['birthTime'], time.millisecondsSinceEpoch);
    expect(jsonMap['endTime'], time2.millisecondsSinceEpoch);
    expect(jsonMap['roomNumber'], 101);
  });

  test('Test JSON to Session conversion', () {
    var time = DateTime(2023, 1, 1, 10, 0);
    var time2 = DateTime(2023, 1, 1, 11, 0);

    // Create a sample JSON map
    final jsonMap = {
      'id': '123',
      'weight': 3500,
      'babyId': '456',
      'nameMother': 'Alice',
      'note': 'This is a test session',
      'birthTime': time.millisecondsSinceEpoch,
      'endTime': time2.millisecondsSinceEpoch,
      'roomNumber': 101,
    };

    // Convert the JSON map to a Session object
    final session = Session.fromJson(jsonMap);

    // Check if the values are correct
    expect(session.id, '123');
    expect(session.weight, 3500);
    expect(session.babyId, '456');
    expect(session.nameMother, 'Alice');
    expect(session.note, 'This is a test session');
    expect(session.birthDateTime, time);
    expect(session.endDateTime, time2);
    expect(session.roomNumber, 101);
  });
}
