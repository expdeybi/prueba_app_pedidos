import 'dart:convert';

import 'package:pedidos_app/models/user.dart';
import 'package:pedidos_app/storage/user_storage.dart';

final userStorage = UserStorage();

Future<List<Usuario>> obtenerUsuariosLocal() async {
  final response = await userStorage.readUser();

  List<Usuario> usuarios = [];

  if (response.isNotEmpty) {
    final jsonData = jsonDecode(response);

    for (var item in jsonData) {
      usuarios.add(
        Usuario(
          id: item['id'],
          fullName: item['full_name'],
          userEmail: item['email']
        )
      );
    }
  }

  return usuarios;
}