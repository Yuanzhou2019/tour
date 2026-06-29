import '../entities/policy.dart';

abstract class PolicyRepository {
  Future<List<Policy>> fetchPolicies(String country);
  Future<Policy> fetchPolicyById(String id);
}