import 'package:zuurstofmasker/Models/sessionDetail.dart';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';

import 'package:zuurstofmasker/config.dart';

Future<List<SessionDetail>> getSessions() async {
  return await getListFromFileOpZijnTims<SessionDetail>(
      SessionPath, SessionDetail.fromJson);
}

saveSession(SessionDetail session) async {
  var sessions = await getSessions();
  var lastSession = sessions.last;
  session.id = lastSession.id! + 1;
  sessions.add(session);
  await writeListToFile(sessions, SessionPath);
}
