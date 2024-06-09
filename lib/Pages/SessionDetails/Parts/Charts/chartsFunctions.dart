import 'package:video_player/video_player.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Widgets/Charts/timeChart.dart';

String getNearestChartValue(VideoPlayerValue? videoController, List<TimeChartData> timeChartData, Session session) {
  String value = '-';
  if (videoController == null) return value; 
  int videoPosition = videoController.position.inMilliseconds + session.birthDateTime.millisecondsSinceEpoch; 
  for(int i = 0; i < timeChartData.length; i++) {
    if(timeChartData[i].time.millisecondsSinceEpoch >  videoPosition) {
      return timeChartData[i].y.toString();
    }
  }
  return value;
}