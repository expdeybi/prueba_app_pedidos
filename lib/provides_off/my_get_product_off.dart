import 'dart:convert';

import 'package:pedidos_app/models/producto.dart';
import 'package:pedidos_app/storage/existencia_storage.dart';

final productStorage = ProductoStorage();

Future<List<Producto>> obtenerProductosLocal() async {
  final response = await productStorage.readProducto();

  List<Producto> productos = [];

  if (response.isNotEmpty) {
    final jsonData = jsonDecode(response);

    for (var item in jsonData) {
      productos.add(
        Producto(
          id: item['id'],
          codigo: item['codigo'],
          producto: item['producto'],
          idCategoria: item['idcategoria'],
          existencia: item['existencia']
        )
      );
    }
  }
  else {
    return Future.error('El archivo de producto.json no existe.');
  }

  return productos;
}