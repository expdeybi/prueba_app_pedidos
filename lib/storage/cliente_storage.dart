import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pedidos_app/models/cliente.dart';

class ClienteStorage {
  Future<String> get _localPath async {
    // Windows: C:\Mis documentos
    // Web: Downloads
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/cliente.json');
  }

  Future<String> readCliente() async {
    try {
      final file = await _localFile;
      // Lee todo el archivo como una cadane de caracteres
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return '';
    }
  }

  Future<File> writeCliente(List<Cliente> clientes) async {
    final file = await _localFile;
    final String jsonUser = jsonEncode(clientes);
    return file.writeAsString(jsonUser);
  }
}