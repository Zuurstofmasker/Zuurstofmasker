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

  test('Test JSON to Note conversion', () {
    // Maak een voorbeeld JSON-map
    final jsonMap = {
      'id': '456',
      'noteTime': 7200000,
      'title': 'Mijn andere notitie',
      'description': 'Dit is een andere testnotitie',
    };

    // Converteer de JSON-map naar een Note-object
    final note = Note.fromJson(jsonMap);

    // Controleer of de waarden correct zijn
    expect(note.id, '456');
    expect(note.noteTime, const Duration(milliseconds: 7200000));
    expect(note.title, 'Mijn andere notitie');
    expect(note.description, 'Dit is een andere testnotitie');
  });
}
