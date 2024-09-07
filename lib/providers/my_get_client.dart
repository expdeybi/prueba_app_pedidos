import 'package:pedidos_app/models/cliente.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<List<Cliente>> obtenerDatosClientes(String table) async {
  final response = await supabase.from(table).select('*');

  List<Cliente> listDatos = [];

  if (response.isNotEmpty) {
    for (var item in response) {
      listDatos.add(
        Cliente(
          id: item['id'].toString(),
          cliente: item['cliente'],
          rif: item['rif'],
          grupoCliente: item['grupo_cliente'],
        )
      );      
    }

    return listDatos;
  }
  else {
    return Future.error('Fallo la conexion');
  }
}