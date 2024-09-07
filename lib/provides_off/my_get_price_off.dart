import 'dart:convert';
import 'package:pedidos_app/models/price.dart';
import 'package:pedidos_app/storage/precio_storage.dart';

final priceStorage = PriceStorage();

Future<List<Precio>> obtenerPreciosLocal() async {
  final response = await priceStorage.readPrecios();

  List<Precio> precios = [];

  if (response.isNotEmpty) {
    final jsonData = jsonDecode(response);

    for (var item in jsonData) {
      precios.add(
        Precio(
          id: item['id'].toString(),
          codigo: item['codigo'],
          precio: item['precio'],
          idProducto: item['idproducto']
        )
      );
    }
  }
  else {
    return Future.error('El archivo de precio.json no existe.');
  }

  return precios;
}