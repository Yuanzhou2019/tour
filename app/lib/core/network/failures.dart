import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.network(NetworkFailureType type) = NetworkFailure;
  const factory Failure.server({required int statusCode, String? code}) = ServerFailure;
  const factory Failure.cache({required String message}) = CacheFailure;
  const factory Failure.permission(PermissionType type) = PermissionFailure;
  const factory Failure.unknown(String message) = UnknownFailure;
}

enum NetworkFailureType { offline, timeout, noConnection }
enum PermissionType { location, notification, camera }
