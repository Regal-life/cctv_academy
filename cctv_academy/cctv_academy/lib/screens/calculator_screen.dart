import 'package:material_ui/material_ui.dart';
import '../helpers/cctv_calculator.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // User Inputs
  double _cameraCount = 8;
  double _resolutionMP = 4.0; // 4MP
  double _fps = 15;
  String _codec = 'H.265';
  double _retentionDays = 30;
  double _hoursPerDay = 24;

  // Preset Resolutions (MP)
  final Map<String, double> _resolutions = {
    '1080p (2 MP)': 2.0,
    '4 MP (2K)': 4.0,
    '5 MP': 5.0,
    '4K (8 MP)': 8.0,
  };

  @override
  Widget build(BuildContext context) {
    // Calculations
    double singleBitrate = CCTVCalculator.calculateCameraBitrate(
      resolutionMP: _resolutionMP,
      fps: _fps.toInt(),
      codec: _codec,
    );

    double totalBandwidth = CCTVCalculator.calculateTotalBandwidth(
      cameraCount: _cameraCount.toInt(),
      singleCameraMbps: singleBitrate,
    );

    double totalStorage = CCTVCalculator.calculateStorageTB(
      totalBandwidthMbps: totalBandwidth,
      retentionDays: _retentionDays.toInt(),
      hoursPerDay: _hoursPerDay.toInt(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('CCTV Storage & Bandwidth'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- RESULTS SUMMARY CARDS ---
            Row(
              children: [
                Expanded(
                  child: _ResultCard(
                    title: 'Total Storage',
                    value: '$totalStorage TB',
                    icon: Icons.hard_drive,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ResultCard(
                    title: 'Throughput',
                    value: '$totalBandwidth Mbps',
                    icon: Icons.speed,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- INPUT CONTROL FORM ---
            Text('Camera Specs', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),

            // Number of Cameras
            Text('Number of Cameras: ${_cameraCount.toInt()}'),
            Slider(
              value: _cameraCount,
              min: 1,
              max: 64,
              divisions: 63,
              label: '${_cameraCount.toInt()}',
              onChanged: (val) => setState(() => _cameraCount = val),
            ),

            // Resolution Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Camera Resolution:'),
                DropdownButton<double>(
                  value: _resolutionMP,
                  items: _resolutions.entries.map((e) {
                    return DropdownMenuItem(value: e.value, child: Text(e.key));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _resolutionMP = val);
                  },
                ),
              ],
            ),

            // Codec Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Compression Codec:'),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'H.264', label: Text('H.264')),
                    ButtonSegment(value: 'H.265', label: Text('H.265')),
                    ButtonSegment(value: 'H.265+', label: Text('H.265+')),
                  ],
                  selected: {_codec},
                  onSelectionChanged: (val) {
                    setState(() => _codec = val.first);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Frame Rate Slider
            Text('Frame Rate (FPS): ${_fps.toInt()} fps'),
            Slider(
              value: _fps,
              min: 5,
              max: 30,
              divisions: 25,
              label: '${_fps.toInt()}',
              onChanged: (val) => setState(() => _fps = val),
            ),

            const SizedBox(height: 16),
            Text('Recording Schedule',
                style: Theme.of(context).textTheme.titleLarge),
            const Divider(),

            // Retention Days Slider
            Text('Retention Period: ${_retentionDays.toInt()} Days'),
            Slider(
              value: _retentionDays,
              min: 1,
              max: 90,
              divisions: 89,
              label: '${_retentionDays.toInt()} days',
              onChanged: (val) => setState(() => _retentionDays = val),
            ),

            // Hours Recorded Per Day
            Text('Recording Hours/Day: ${_hoursPerDay.toInt()} Hours'),
            Slider(
              value: _hoursPerDay,
              min: 1,
              max: 24,
              divisions: 23,
              label: '${_hoursPerDay.toInt()} hrs',
              onChanged: (val) => setState(() => _hoursPerDay = val),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom UI Widget for Summary Display
class _ResultCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _ResultCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
