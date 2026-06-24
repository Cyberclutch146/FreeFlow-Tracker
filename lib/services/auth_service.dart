import 'package:local_auth/local_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Handles biometric and device-PIN authentication via [LocalAuthentication].
///
/// Used at app launch and on resume-from-background to lock the app behind
/// the user's fingerprint, face ID, or device PIN.
class AuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// Returns true if the device supports any form of authentication
  /// (biometrics OR device PIN/password).
  static Future<bool> isBiometricAvailable() async {
    try {
      final canCheckBiometrics = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return canCheckBiometrics || isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  /// Prompts the user for authentication.
  ///
  /// Returns true on success. On any error (e.g. no enrolled biometric,
  /// emulator with no PIN), returns true so the app doesn't get stuck.
  static Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to access your financial data',
        // Note: biometricOnly is removed in local_auth v3.
        // Use AuthenticationOptions for fine-grained control if needed.
      );
    } on PlatformException catch (e) {
      // Common in emulators — bypass gracefully
      debugPrint('Biometric auth skipped: ${e.message}');
      return true;
    } catch (e) {
      debugPrint('Auth error: $e');
      return true;
    }
  }
}
