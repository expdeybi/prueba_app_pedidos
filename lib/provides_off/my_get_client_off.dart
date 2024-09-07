import 'dart:convert';

import 'package:pedidos_app/models/cliente.dart';
import 'package:pedidos_app/storage/cliente_storage.dart';

final clientStorage = ClienteStorage();

Future<List<Cliente>> obtenerClienteLocal() async {
  final response = await clientStorage.readCliente();

  List<Cliente> clientes = [];

  if (response.isNotEmpty) {
    final jsonData = jsonDecode(response);

    for (var item in jsonData) {
      clientes.add(
        Cliente(
          id: item['id'].toString(),
          cliente: item['cliente'],
          rif: item['rif'],
          grupoCliente: item['grupo_cliente'],
        )
      );
    }
  }
  else {
    return Future.error('El archivo de cliente.json no existe.');
  }

  return clientes;
}