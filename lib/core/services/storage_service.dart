// Placeholder for storage service
abstract class StorageService {
  Future<void> save(String key, String value);
  Future<String?> read(String key);
}
