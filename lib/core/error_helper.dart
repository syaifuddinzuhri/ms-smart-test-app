class ErrorHelper {
  static String getMessage(dynamic error) {
    try {
      // Kalau dari Dio (error.response.data)
      final data = error?.response?.data ?? error;

      if (data is Map<String, dynamic>) {
        // Ambil message default
        String message = data['message'] ?? "Terjadi kesalahan";

        // Kalau ada errors (validasi Laravel)
        if (data['errors'] != null && data['errors'] is Map) {
          final errors = data['errors'] as Map<String, dynamic>;

          if (errors.isNotEmpty) {
            final firstError = errors.values.first;

            if (firstError is List && firstError.isNotEmpty) {
              return firstError.first.toString();
            }
          }
        }

        return message;
      }

      return "Terjadi kesalahan server. Silahkan hubungi admin!";
    } catch (e) {
      return "Terjadi kesalahan";
    }
  }
}