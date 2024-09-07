import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pedidos_app/models/price.dart';

class PriceStorage {
  Future<String> get _localPath async {
    // Windows: C:\Mis documentos
    // Web: Downloads
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/precio.json');
  }

  Future<String> readPrecios() async {
    try {
      final file = await _localFile;
      // Lee todo el archivo como una cadane de caracteres
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return '';
    }
  }

  Future<File> writePrecios(List<Precio> precios) async {
    final file = await _localFile;
    final String jsonPrice = jsonEncode(precios);
    return file.writeAsString(jsonPrice);
  }
}