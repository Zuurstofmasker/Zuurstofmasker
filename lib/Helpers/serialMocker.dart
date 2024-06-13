import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:zuurstofmasker/Helpers/serialHelpers.dart';

extension SerialMocker on SerialPort {
  Stream<Uint8List> listen({int min = 70, int max = 190}) async* {
    const int minSegmentLength = 6;
    const int maxSegmentLength = 12;
    const int strength = 2;
    final double value = max * 0.05;
    int randomStrengthMultiplyer = value.toInt();
    if (randomStrengthMultiplyer == 0) randomStrengthMultiplyer = 2;
    final Random random = Random();

    int heartBeat = (min + max) ~/ 2;
    int state = 1;

    while (true) {
      final int segmentLength = random.nextInt(maxSegmentLength - minSegmentLength) +
          minSegmentLength;
      final bool timeout = random.nextBool();    
      for (int i = 0; i < segmentLength; i++) {
        // Adding possible change
        int newStrenth = strength * random.nextInt(randomStrengthMultiplyer);
        heartBeat = (heartBeat + (state * newStrenth));

        // Claming the hearbeat to some proper values
        heartBeat = heartBeat.clamp(min, max);

        // Chaning the state after 20 iterations
        state = random.nextInt(3) - 1;

        // Waiting for some random time
        await Future.delayed(const Duration(milliseconds: 1000));

        // Sending the date to mock the serial port
        yield doubleToUint8List(timeout ? 0 : heartBeat.toDouble());
      }
    }
  }
}
