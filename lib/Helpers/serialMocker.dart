import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_libserialport/flutter_libserialport.dart';

extension SerialMocker on SerialPort {
  Stream<Uint8List> listen() async* {
    const int maxHeartRate = 190;
    const int minHeartRate = 70;
    const int minSegmentLength = 6;
    const int maxSegmentLength = 12;
    const int minDelay = 500;
    const int maxDelay = 1000;
    const int strength = 2;
    const int randomStrengthMultiplyer = 5;
    final Random random = Random();

    int heartBeat = 120;
    int state = 1;

    while (true) {
      int segmentLength = random.nextInt(maxSegmentLength - minSegmentLength) +
          minSegmentLength;
      for (int i = 0; i < segmentLength; i++) {
        // Adding possible change
        int newStrenth = strength * random.nextInt(randomStrengthMultiplyer);
        heartBeat = (heartBeat + (state * newStrenth));

        // Claming the hearbeat to some proper values
        heartBeat = heartBeat.clamp(minHeartRate, maxHeartRate);

        // Chaning the state after 20 iterations
        state = random.nextInt(3) - 1;

        // Waiting for some random time
        await Future.delayed(Duration(
            milliseconds: random.nextInt(maxDelay - minDelay) + minDelay));

        // Sending the date to mock the serial port
        yield Uint8List.fromList([heartBeat]);
      }
    }
  }
}
