import 'dart:convert';

import 'package:pedidos_app/models/category.dart';
import 'package:pedidos_app/storage/categoria_storage.dart';

final categoriaStorage = CategoriaStorage();

Future<List<Categoria>> obtenerCategoriasLocal() async {
  final response = await categoriaStorage.readCategoria();

  List<Categoria> categorias = [];

  if (response.isNotEmpty) {
    final jsonData = jsonDecode(response);

    for (var item in jsonData) {
      categorias.add(
        Categoria(
          id: item['id'].toString(),
          categoria: item['categoria']
        )
      );
    }
  } 

  return categorias;
}