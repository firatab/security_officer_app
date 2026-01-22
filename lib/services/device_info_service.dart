import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../core/utils/logger.dart';

class DeviceInfoModel {
  final String deviceId;
  final String platform;
  final String? osVersion;
  final String? deviceName;
  final String appType;
  final String? appVersion;
  final String? appBuildNumber;

  DeviceInfoModel({
    required this.deviceId,
    required this.platform,
    this.osVersion,
    this.deviceName,
    required this.appType,
    this.appVersion,
    this.appBuildNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'platform': platform,
      'osVersion': osVersion,
      'deviceName': deviceName,
      'appType': appType,
      'appVersion': appVersion,
      'appBuildNumber': appBuildNumber,
    };
  }
}

class DeviceInfoService {
  static const String _appType = 'officer'; // Officer app identifier

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Get comprehensive device information
  Future<DeviceInfoModel> getDeviceInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      
      if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return DeviceInfoModel(
          deviceId: iosInfo.identifierForVendor ?? 'unknown-ios',
          platform: 'ios',
          osVersion: 'iOS ${iosInfo.systemVersion}',
          deviceName: iosInfo.name ?? _getIOSDeviceModel(iosInfo.utsname.machine),
          appType: _appType,
          appVersion: packageInfo.version,
          appBuildNumber: packageInfo.buildNumber,
        );
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return DeviceInfoModel(
          deviceId: androidInfo.id, // Android ID
          platform: 'android',
          osVersion: 'Android ${androidInfo.version.release}',
          deviceName: '${androidInfo.manufacturer} ${androidInfo.model}',
          appType: _appType,
          appVersion: packageInfo.version,
          appBuildNumber: packageInfo.buildNumber,
        );
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    } catch (e) {
      AppLogger.error('Failed to get device info', e);
      rethrow;
    }
  }

  /// Get user-friendly iOS device model name from machine identifier
  String _getIOSDeviceModel(String machine) {
    // Map of common iOS device identifiers to friendly names
    final deviceMap = {
      'iPhone14,2': 'iPhone 13 Pro',
      'iPhone14,3': 'iPhone 13 Pro Max',
      'iPhone14,4': 'iPhone 13 mini',
      'iPhone14,5': 'iPhone 13',
      'iPhone15,2': 'iPhone 14 Pro',
      'iPhone15,3': 'iPhone 14 Pro Max',
      'iPhone15,4': 'iPhone 14',
      'iPhone15,5': 'iPhone 14 Plus',
      'iPhone16,1': 'iPhone 15 Pro',
      'iPhone16,2': 'iPhone 15 Pro Max',
      'iPad13,1': 'iPad Air (5th generation)',
      'iPad13,2': 'iPad Air (5th generation)',
    };
    
    return deviceMap[machine] ?? machine;
  }
}
