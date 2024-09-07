import 'package:pedidos_app/models/price.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<List<Precio>> obtenerDatos(String table) async {
  final response = await supabase.from(table).select('*');

  List<Precio> listDatos = [];

  if (response.isNotEmpty) {
    for (var item in response) {
      listDatos.add(
        Precio(
          id: item['id'].toString(),
          codigo: item['codigo'],
          precio: item['precio'],
          idProducto: item['idproducto'],
        )
      );      
    }

    return listDatos;
  }
  else {
    return Future.error('Fallo la conexion');
  }
}