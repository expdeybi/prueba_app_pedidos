import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pedidos_app/models/user.dart';

class UserStorage {
  Future<String> get _localPath async {
    // Windows: C:\Mis documentos
    // Web: Downloads
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/user.json');
  }

  Future<String> readUser() async {
    try {
      final file = await _localFile;
      // Lee todo el archivo como una cadane de caracteres
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return '';
    }
  }

  Future<File> writeUser(String id, String fullName, String userEmail) async {
    final file = await _localFile;
    final user = Usuario(id: id, fullName: fullName, userEmail: userEmail);
    final String jsonUser = jsonEncode([user]);
    return file.writeAsString(jsonUser);
  }
}