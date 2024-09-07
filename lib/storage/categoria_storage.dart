import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pedidos_app/models/category.dart';

class CategoriaStorage {
  Future<String> get _localPath async {
    // Windows: C:\Mis documentos
    // Web: Downloads
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/categoria.json');
  }

  Future<String> readCategoria() async {
    try {
      final file = await _localFile;
      // Lee todo el archivo como una cadane de caracteres
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return '';
    }
  }

  Future<File> writeCategoria(List<Categoria> categorias) async {
    final file = await _localFile;    
    final String jsonCats = jsonEncode(categorias);
    return file.writeAsString(jsonCats);
  }
}