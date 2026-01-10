import 'package:dio/dio.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../../core/utils/logger.dart';

class EmergencyRepository {
  final DioClient _dioClient;

  EmergencyRepository(this._dioClient);

  Future<void> sendPanicAlert({
    required double latitude,
    required double longitude,
    String? shiftId,
    String? siteId,
    String? message,
  }) async {
    try {
      // Build request data - backend requires either siteId or shiftId
      final data = <String, dynamic>{
        'latitude': latitude,
        'longitude': longitude,
      };

      if (shiftId != null) {
        data['shiftId'] = shiftId;
      }
      if (siteId != null) {
        data['siteId'] = siteId;
      }
      if (message != null && message.isNotEmpty) {
        data['message'] = message;
      }

      final response = await _dioClient.dio.post(
        ApiEndpoints.panicAlert,
        data: data,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw NetworkException('Failed to send panic alert: ${response.statusMessage}');
      }

      AppLogger.info('Panic alert sent successfully');
    } on DioException catch (e) {
      AppLogger.error('Send panic alert API call failed', e);

      if (e.response?.statusCode == 400) {
        final errorMsg = e.response?.data['error'] ?? 'Invalid request';
        throw ValidationException(errorMsg);
      }

      throw NetworkException('Network error sending panic alert: ${e.message}');
    } catch (e) {
      AppLogger.error('Unexpected error sending panic alert', e);
      throw AppException('Failed to send panic alert: $e');
    }
  }
}
