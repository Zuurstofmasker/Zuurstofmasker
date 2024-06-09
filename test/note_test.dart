import 'package:flutter_test/flutter_test.dart';
import 'package:zuurstofmasker/Models/note.dart';

void main() {
  test('Test Note to JSON conversion', () {
    // Maak een voorbeeldnotitie
    const note = Note(
      id: '123',
      noteTime: Duration(seconds: 3600),
      title: 'Mijn notitie',
      description: 'Dit is een testnotitie',
    );

    // Converteer de notitie naar een JSON-map
    final jsonMap = note.toJson();

    // Controleer of de waarden correct zijn
    expect(jsonMap['id'], '123');
    expect(jsonMap['noteTime'], 3600000);
    expect(jsonMap['title'], 'Mijn notitie');
    expect(jsonMap['description'], 'Dit is een testnotitie');
  });
}
