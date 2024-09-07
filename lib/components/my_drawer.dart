// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pedidos_app/inherited/my_inherited.dart';
import 'package:pedidos_app/screens/categorias.dart';
import 'package:pedidos_app/screens/client_screen.dart';
import 'package:flutter/material.dart';
import 'package:pedidos_app/components/my_user_account.dart';
import 'package:pedidos_app/screens/dashboard.dart';
import 'package:pedidos_app/screens/existencias.dart';
import 'package:pedidos_app/screens/historico_pedidos.dart';
import 'package:pedidos_app/screens/order_pedidos.dart';
import 'package:pedidos_app/screens/ver_pedidos.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    super.key,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        //padding: EdgeInsets.zero,
        children: [
          Expanded(
            child: Column(
              children: [
                MyUserAccount(
                  userEmail: GetInfoUser.of(context).userEmail!,
                  fullName: GetInfoUser.of(context).fullName!,
                ),
                ListTile(
                  leading: Image.asset('assets/img/dashboard.png'),
                  title: Text(
                    'Inicio',
                    style: TextStyle(
                      fontSize: 20.0
                    ),
                  ),
                  trailing: Icon(
                    Icons.home,
                    color: Color(0xffec1c24),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dashboard()
                      )
                    );
                  },
                ),
                Divider(
                  color: Color(0xffec1c24),
                ),
                ListTile(
                  leading: Image.asset('assets/img/categorias.png'),
                  title: const Text('Categorias'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListadoCategorias(),
                      )
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset('assets/img/pedidos.png'),
                  title: const Text('Historico de pedidos'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => HistoricoPedidos(),
                      )
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset('assets/img/clientes.png'),
                  title: const Text('Clientes'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClientScreen(),
                      )
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset('assets/img/existencias.png'),
                  title: const Text('Existencias'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListadoExistencias(),
                      )
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset('assets/img/order.png'),
                  title: const Text('Orden de pedido'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrdenPedido(),
                      )
                    );
                  },                  
                ),

                ListTile(
                  leading: Image.asset('assets/img/carrito.png'),
                  title: const Text('Carrito de pedidos'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerPedidos(),
                      )
                    );
                  },
                ),
              ],
            ),
          ),
          Divider(
            color: Color(0xffec1c24),
          ),
          Container(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.logout_outlined),
                    title: const Text('Cerrar sesion'),
                    onTap: () {
                      logout();
                    },
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }

  void logout() async {
    if (GetInfoUser.of(context).conexion!) {
      await supabase.auth.signOut();
    }

    exit(0); // Windows, Linux
    //SystemNavigator.pop(); // Android

    // SystemChannels.platform // Investigar la forma de detectar la plataforma
  }
}
