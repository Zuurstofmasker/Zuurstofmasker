import 'package:flutter_test/flutter_test.dart';
import 'package:zuurstofmasker/Models/session.dart';

void main() {
  test('Test Session to JSON conversion', () {
    // Create a sample session
    final session = Session(
      id: '123',
      weight: 3500,
      babyId: '456',
      nameMother: 'Alice',
      note: 'This is a test session',
      birthDateTime: DateTime(2023, 1, 1, 10, 0),
      endDateTime: DateTime(2023, 1, 1, 11, 0),
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
    expect(jsonMap['birthTime'], 1672567200000);
    expect(jsonMap['endTime'], 1672567200000);
    expect(jsonMap['roomNumber'], 101);
  });
}
