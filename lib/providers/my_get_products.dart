import 'package:pedidos_app/models/producto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<List<Producto>> obtenerDatosProductos(String table) async {
  final response = await supabase.from(table).select('*');

  List<Producto> listDatos = [];

  if (response.isNotEmpty) {
    for (var item in response) {
      listDatos.add(
        Producto(
          id: item['id'].toString(),
          codigo: item['codigo'].toString(),
          producto: item['producto'].toString(),
          idCategoria: item['idcategoria'].toString(),
          existencia: item['existencia'].toString()
        )
      );      
    }

    return listDatos;
  }
  else {
    return Future.error('Fallo la conexion');
  }
}