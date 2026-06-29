import '../entities/emergency_contact.dart';

abstract class EmergencyRepository {
  Future<List<EmergencyContact>> fetchAll();
}
