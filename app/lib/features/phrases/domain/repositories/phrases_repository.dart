import '../entities/phrase.dart';

abstract class PhrasesRepository {
  Future<List<Phrase>> fetchByCategory(String category);
}
