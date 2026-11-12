import 'package:material_ui/material_ui.dart';
import '../helpers/cable_data.dart';

class WiringScreen extends StatefulWidget {
  const WiringScreen({super.key});

  @override
  State<WiringScreen> createState() => _WiringScreenState();
}

class _WiringScreenState extends State<WiringScreen> {
  String _selectedStandard = 'T568B'; // Default standard

  @override
  Widget build(BuildContext context) {
    List<WirePinout> activePinout =
        _selectedStandard == 'T568B' ? CableStandards.t568b : CableStandards.t568a;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RJ45 & Wiring Guide'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- STANDARD TOGGLE SELECTOR ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Crimping Standard:',
                    style: Theme.of(context).textTheme.titleMedium),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'T568B', label: Text('T-568B (Std)')),
                    ButtonSegment(value: 'T568A', label: Text('T-568A')),
                  ],
                  selected: {_selectedStandard},
                  onSelectionChanged: (val) {
                    setState(() => _selectedStandard = val.first);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- RJ45 VISUAL PINOUT LIST ---
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'RJ45 Clip Facing Down (Pins 1-8 Left to Right)',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 12),
                    ...activePinout.map((wire) => _WireRowTile(wire: wire)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- POE REFERENCE CHEAT-SHEET ---
            Text('PoE Standards Guide',
                style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            const SizedBox(height: 8),

            const _PoEInfoCard(
              standard: 'PoE (IEEE 802.3af)',
              maxPower: '15.4 W (12.95W at camera)',
              idealFor: 'Standard Fixed IP Cameras & Audio Devices',
            ),
            const SizedBox(height: 8),
            const _PoEInfoCard(
              standard: 'PoE+ (IEEE 802.3at)',
              maxPower: '30.0 W (25.5W at camera)',
              idealFor: 'PTZ Cameras, Heaters, Blower Enclosures',
            ),
            const SizedBox(height: 8),
            const _PoEInfoCard(
              standard: 'PoE++ / Hi-PoE (802.3bt)',
              maxPower: '60 W – 90 W',
              idealFor: 'Long-range Outdoor PTZs, Multi-sensor Cameras',
            ),
          ],
        ),
      ),
    );
  }
}

// Custom UI Row for displaying wire colors with stripes
class _WireRowTile extends StatelessWidget {
  final WirePinout wire;

  const _WireRowTile({required this.wire});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          // Pin Number Badge
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${wire.pin}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(width: 16),

          // Wire Color Swatch Indicator
          Container(
            width: 44,
            height: 18,
            decoration: BoxDecoration(
              color: wire.solidColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: wire.stripeColor != null
                ? CustomPaint(
                    painter: _StripePainter(wire.stripeColor!),
                  )
                : null,
          ),
          const SizedBox(width: 16),

          // Color Name Text Label
          Text(
            wire.colorName,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// Custom Painter to render striped wires accurately (e.g. White/Orange)
class _StripePainter extends CustomPainter {
  final Color stripeColor;

  _StripePainter(this.stripeColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = stripeColor
      ..strokeWidth = 3;

    // Draw diagonal stripe across wire preview rectangle
    canvas.drawLine(
        Offset(size.width * 0.2, 0), Offset(size.width * 0.5, size.height), paint);
    canvas.drawLine(
        Offset(size.width * 0.6, 0), Offset(size.width * 0.9, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Component for PoE standard summaries
class _PoEInfoCard extends StatelessWidget {
  final String standard;
  final String maxPower;
  final String idealFor;

  const _PoEInfoCard({
    required this.standard,
    required this.maxPower,
    required this.idealFor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueGrey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(standard,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(maxPower,
                  style: const TextStyle(
                      color: Colors.blueAccent, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Best used for: $idealFor',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade800)),
        ],
      ),
    );
  }
}
