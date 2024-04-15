import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_libserialport/flutter_libserialport.dart';

extension SerialMocker on SerialPort {
  void listen(Function(Uint8List data) event) async {
    const int maxHeartRate = 190;
    const int minHeartRate = 70;
    const int strength = 4;
    final Random random = Random();

    int heartBeat = 120;
    int state = 1;

    while (true) {
      for (int i = 0; i < 10; i++) {
        // Adding possible change
        heartBeat = (heartBeat + (random.nextBool() ? (state * strength) : 0));

        // Claming the hearbeat to some proper values
        heartBeat = heartBeat.clamp(minHeartRate, maxHeartRate);

        // Chaning the state after 20 iterations
        state = random.nextInt(3) - 1;

        // Waiting for some random time
        await Future.delayed(Duration(milliseconds: random.nextInt(500) + 500));

        // Sending the date to mock the serial port
        event(Uint8List.fromList([heartBeat]));
      }
    }
  }
}
