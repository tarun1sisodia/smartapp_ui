import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final Map<String, dynamic> deviceData = {
        'app_name': packageInfo.appName,
        'package_name': packageInfo.packageName,
        'version': packageInfo.version,
        'build_number': packageInfo.buildNumber,
      };

      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        deviceData.addAll({
          'device_id': androidInfo.id,
          'brand': androidInfo.brand,
          'model': androidInfo.model,
          'os_version': androidInfo.version.release,
          'sdk_version': androidInfo.version.sdkInt.toString(),
          'manufacturer': androidInfo.manufacturer,
          'is_physical_device': androidInfo.isPhysicalDevice,
        });
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        deviceData.addAll({
          'device_id': iosInfo.identifierForVendor,
          'model': iosInfo.model,
          'os_version': iosInfo.systemVersion,
          'name': iosInfo.name,
          'is_physical_device': iosInfo.isPhysicalDevice,
        });
      }

      return deviceData;
    } catch (e) {
      throw Exception('Failed to get device info: $e');
    }
  }

  Future<bool> isDeveloperModeEnabled() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.isPhysicalDevice &&
            await _isAndroidDeveloperModeOn();
      }
      // iOS doesn't have a traditional developer mode like Android
      return false;
    } catch (e) {
      throw Exception('Failed to check developer mode: $e');
    }
  }

  Future<bool> _isAndroidDeveloperModeOn() async {
    try {
      // This is a basic check. You might want to use platform channels
      // for a more reliable check on Android
      return Platform.isAndroid &&
          const bool.fromEnvironment('dart.vm.product') == false;
    } catch (e) {
      return false;
    }
  }

  Future<String> getUniqueDeviceId() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? '';
      }
      throw Exception('Unsupported platform');
    } catch (e) {
      throw Exception('Failed to get device ID: $e');
    }
  }
}
