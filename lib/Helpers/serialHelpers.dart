import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:zuurstofmasker/Helpers/serialMocker.dart';
import 'package:zuurstofmasker/config.dart';

Stream<Uint8List> readFromSerialPort(String name) {
  SerialPort port = SerialPort(name);
  port.openRead();
  SerialPortReader reader = SerialPortReader(port);
  return reader.stream;
}

void closeSerialPort(String name) {
  SerialPort port = SerialPort(name);
  port.close();
}

void writeToSerialPort(String name, Uint8List data) {
  SerialPort port = SerialPort(name);
  port.openWrite();
  port.write(data);
}

int uint8ListToInt(Uint8List ui8l) => ui8l.buffer.asByteData().getInt64(0);

int? uint8ListToIntNullable(Uint8List ui8l) {
  try {
    return uint8ListToInt(ui8l);
  } catch (e) {
    return null;
  }
}

double uint8ListToDouble(Uint8List ui8l) =>
    ui8l.buffer.asByteData().getFloat64(0);

double? uint8ListToDoubleNullable(Uint8List ui8l) {
  try {
    return (uint8ListToDouble(ui8l));
  } catch (e) {
    return null;
  }
}

Uint8List intToUint8List(int intVar) {
  ByteData byteData = ByteData(8);
  byteData.setInt64(0, intVar);
  return byteData.buffer.asUint8List();
}

Uint8List doubleToUint8List(double doubleVar) {
  ByteData byteData = ByteData(8);
  byteData.setFloat64(0, doubleVar);
  return byteData.buffer.asUint8List();
}

Stream<Uint8List> createNewStream(String name, int min, int max) =>
    SerialPort(name).listen(min: min, max: max).asBroadcastStream();

bool serialDataValidator(Uint8List data) {
  if (uint8ListToDouble(data) == 0) return false;
  return true;
}

Stream<List<bool>> streamsHasData<T>(List<Stream<T>> streams,
    {Duration timeout = const Duration(seconds: serialTimeoutInSeconds),
    Duration interval = const Duration(seconds: 1),
    bool Function(T data)? validator}) {
  // Creating the stream controller to push custom data
  final StreamController<List<bool>> controller = StreamController.broadcast();

  // Keeping track of the last time data was received
  final int streamsCount = streams.length;
  final List<DateTime> lastDateTimes = List<DateTime>.filled(
      streamsCount, DateTime.fromMillisecondsSinceEpoch(0));
  final List<DateTime> lastCorrectValueDateTimes = List<DateTime>.filled(
      streamsCount, DateTime.fromMillisecondsSinceEpoch(0));

  StreamSubscription<int>? periodicStream;
  List<StreamSubscription<T>>? dataStreams;
  controller.onListen = () {
    // Checkes all datetimes to make sure all the streams are still active
    bool checkDate(DateTime dateTime) =>
        DateTime.now().difference(dateTime) > timeout;

    // Creating a periodic stream to check if the data is still being received
    periodicStream =
        Stream.periodic(interval, (int count) => count).listen((int count) {
      final List<bool> results = List<bool>.filled(streamsCount, true);
      for (var i = 0; i < streamsCount; i++) {
        if (checkDate(lastDateTimes[i])) {
          results[i] = false;
          continue;
        }
        if (validator != null && checkDate(lastCorrectValueDateTimes[i])) {
          results[i] = false;
          continue;
        }
      }
      controller.add(results);
    });

    // Subscribing to all the streams to receive possible data
    dataStreams = streams
        .asMap()
        .map<int, StreamSubscription<T>>(
            (index, stream) => MapEntry<int, StreamSubscription<T>>(
                  index,
                  stream.listen(
                    (T data) {
                      // Updating the last datetime
                      lastDateTimes[index] = DateTime.now();
                      if (validator != null && validator(data)) {
                        lastCorrectValueDateTimes[index] = DateTime.now();
                      }
                    },
                  ),
                ))
        .values
        .toList();
  };

  // Cancelling all the streams when the controller is cancelled
  controller.onCancel = () {
    periodicStream?.cancel();
    for (var stream in (dataStreams ?? const Iterable.empty())) {
      stream.cancel();
    }
  };
  return controller.stream;
}
