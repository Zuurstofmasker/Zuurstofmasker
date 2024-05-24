import 'package:uuid/uuid.dart';
import 'package:zuurstofmasker/Helpers/csvHelpers.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/Models/sessionSerialData.dart';

import 'package:zuurstofmasker/config.dart';

Future<List<Session>> getSessions() async =>
    await getListFromFile<Session>(sessionsJsonPath, Session.fromJson);

Future<String> getNewSessionUuid() async {
  List<Session> sessions = await getSessions();

  // Generate a new unique id
  late Uuid newId;
  do {
    newId = const Uuid();
  } while (sessions.any((element) => element.id == newId.v4()));

  return newId.v4();
}

Future<List<Session>> createSession(Session session) async {
  // Creating the folder for the session with the correct files included
  final newSessionPath = sessionPath + session.id;
  await createFolder(newSessionPath);
  await writeListToFile([], '$newSessionPath/videoNotes.json');
  await createFile('$newSessionPath/recordedData.csv');
  await createFile('$newSessionPath/video.mp4');

  // Append the session to the list of sessions
  return await appendItemToListFile(
      session, sessionsJsonPath, Session.fromJson);
}

Future<void> updateSession(Session session) async {
  final List<Session> sessions = await getSessions();
  final int index = sessions.indexWhere((element) => element.id == session.id);

  if (index == -1) {
    throw Exception('Session not found');
  }

  sessions[index] = session;
  await writeListToFile(sessions, sessionsJsonPath);
}

Future<void> updateRecordedData(SessionSerialData data) async {
  String csvPath = sessionPath + data.sessionId;
  String csv = listToCsv(data.csvData);

  await stringToFile('$csvPath/recordedData.csv', csv);
}

Future<List<List<double>>> getSessionSerialData(String sessionId) async {
  String csvPath = sessionPath + sessionId;
  String data = await stringFromFile('${csvPath}/recordedData.csv');

  return csvToList(data);
}
