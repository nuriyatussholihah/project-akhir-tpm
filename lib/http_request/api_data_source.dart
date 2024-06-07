import 'base_network.dart';

class ApiDataSource {
  static ApiDataSource instance = ApiDataSource();

  Future<Map<String, dynamic>> loadCharacter() {
    return BaseNetwork.get("character");
  }

  Future<Map<String, dynamic>> loadDetailCharacter(int idDiterima) {
    String id = idDiterima.toString();
    return BaseNetwork.get("character/$id");
  }
}
