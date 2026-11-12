/// Calculates bitrate, bandwidth and storage requirements for CCTV systems.
class CCTVCalculator {
  /// Calculates Bitrate per camera in Megabits per second (Mbps)
  static double calculateCameraBitrate({
    required double resolutionMP, // e.g., 2.0 for 1080p, 8.0 for 4K
    required int fps, // e.g., 15, 25, 30
    required String codec, // 'H.264', 'H.265', 'H.265+'
  }) {
    // Base estimate multiplier per pixel/frame
    double baseBitrate = (resolutionMP * 0.4) * (fps / 30.0);

    // Apply compression efficiency multipliers
    switch (codec) {
      case 'H.265':
        baseBitrate *= 0.5; // ~50% savings over H.264
        break;
      case 'H.265+':
        baseBitrate *= 0.3; // ~70% savings over H.264
        break;
      case 'H.264':
      default:
        baseBitrate *= 1.0;
        break;
    }

    return double.parse(baseBitrate.toStringAsFixed(2));
  }

  /// Calculates total network bandwidth for all cameras in Mbps
  static double calculateTotalBandwidth({
    required int cameraCount,
    required double singleCameraMbps,
  }) {
    return double.parse((cameraCount * singleCameraMbps).toStringAsFixed(2));
  }

  /// Calculates total required hard drive storage in Terabytes (TB)
  static double calculateStorageTB({
    required double totalBandwidthMbps,
    required int retentionDays,
    required int hoursPerDay, // Usually 24, or less for motion-only
  }) {
    // Formula: Bitrate (Mbps) * 3600 (sec/hr) * hours * days / 8 (bits to bytes) / 1,000,000,000,000 (to TB)
    double totalBitsPerSecond = totalBandwidthMbps * 1000000;
    double totalSeconds = retentionDays * hoursPerDay * 3600.0;
    double totalBytes = (totalBitsPerSecond * totalSeconds) / 8.0;

    double storageTB = totalBytes / 1000000000000.0; // Decimal TB standard
    return double.parse(storageTB.toStringAsFixed(2));
  }
}
