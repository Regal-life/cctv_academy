import 'package:flutter/material.dart';

class WirePinout {
  final int pin;
  final String colorName;
  final Color solidColor;
  final Color? stripeColor; // Null if solid wire

  WirePinout({
    required this.pin,
    required this.colorName,
    required this.solidColor,
    this.stripeColor,
  });
}

class CableStandards {
  // T-568B Standard (Most common for standard patch cables)
  static List<WirePinout> get t568b => [
        WirePinout(
          pin: 1,
          colorName: 'White / Orange',
          solidColor: Colors.white,
          stripeColor: Colors.orange,
        ),
        WirePinout(pin: 2, colorName: 'Orange', solidColor: Colors.orange),
        WirePinout(
          pin: 3,
          colorName: 'White / Green',
          solidColor: Colors.white,
          stripeColor: Colors.green,
        ),
        WirePinout(pin: 4, colorName: 'Blue', solidColor: Colors.blue),
        WirePinout(
          pin: 5,
          colorName: 'White / Blue',
          solidColor: Colors.white,
          stripeColor: Colors.blue,
        ),
        WirePinout(pin: 6, colorName: 'Green', solidColor: Colors.green),
        WirePinout(
          pin: 7,
          colorName: 'White / Brown',
          solidColor: Colors.white,
          stripeColor: Colors.brown,
        ),
        WirePinout(pin: 8, colorName: 'Brown', solidColor: Colors.brown),
      ];

  // T-568A Standard (Used in older installations & crossover cables)
  static List<WirePinout> get t568a => [
        WirePinout(
          pin: 1,
          colorName: 'White / Green',
          solidColor: Colors.white,
          stripeColor: Colors.green,
        ),
        WirePinout(pin: 2, colorName: 'Green', solidColor: Colors.green),
        WirePinout(
          pin: 3,
          colorName: 'White / Orange',
          solidColor: Colors.white,
          stripeColor: Colors.orange,
        ),
        WirePinout(pin: 4, colorName: 'Blue', solidColor: Colors.blue),
        WirePinout(
          pin: 5,
          colorName: 'White / Blue',
          solidColor: Colors.white,
          stripeColor: Colors.blue,
        ),
        WirePinout(pin: 6, colorName: 'Orange', solidColor: Colors.orange),
        WirePinout(
          pin: 7,
          colorName: 'White / Brown',
          solidColor: Colors.white,
          stripeColor: Colors.brown,
        ),
        WirePinout(pin: 8, colorName: 'Brown', solidColor: Colors.brown),
      ];
}
