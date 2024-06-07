import 'package:hive/hive.dart';
import 'package:project_tpm/model_hive/datauser_model.dart';
import 'package:project_tpm/encryp/encryption_helper.dart';

class HiveDatabase {
  static Box<DataUserModel> get _localDB =>
      Hive.box<DataUserModel>('data_user');
  static Box<String> get _sessionBox => Hive.box<String>('session_box');

  static void addData(DataUserModel data) {
    // Hash the password before saving
    data.password = hashPassword(data.password);
    _localDB.add(data);
  }

  static int getLength() {
    return _localDB.length;
  }

  static bool checkLogin(String username, String password) {
    bool found = false;
    String hashedPassword = hashPassword(password); // Hash the password

    for (int i = 0; i < getLength(); i++) {
      final user = _localDB.getAt(i);
      if (user != null &&
          username == user.username &&
          hashedPassword == user.password) {
        _sessionBox.put('current_user', username); // Save current user session
        print("Login Berhasil");
        found = true;
        break;
      }
    }
    return found;
  }

  static String? getCurrentUser() {
    return _sessionBox.get('current_user');
  }

  static void logout() {
    _sessionBox.delete('current_user');
  }

  static DataUserModel? getUserAt(int index) {
    return _localDB.getAt(index);
  }
}
