import 'package:logger/logger.dart';

class AppLogger {
  AppLogger({required this.enabled, Logger? logger})
    : _logger = logger ?? Logger();

  final bool enabled;
  final Logger _logger;

  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    if (!enabled) {
      return;
    }

    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void info(String message, {Object? error, StackTrace? stackTrace}) {
    if (!enabled) {
      return;
    }

    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
