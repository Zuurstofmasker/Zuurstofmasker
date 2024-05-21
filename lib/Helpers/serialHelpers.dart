import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_libserialport/flutter_libserialport.dart';

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
