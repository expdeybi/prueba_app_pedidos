import 'package:pedidos_app/components/my_appbar.dart';
import 'package:pedidos_app/components/my_button_drawer.dart';
import 'package:pedidos_app/components/my_drawer.dart';
import 'package:pedidos_app/delegates/search_client.dart';
import 'package:pedidos_app/inherited/my_inherited.dart';
import 'package:pedidos_app/providers/my_get_client.dart';
import 'package:pedidos_app/models/cliente.dart';
import 'package:flutter/material.dart';
import 'package:pedidos_app/provides_off/my_get_client_off.dart';
import 'package:pedidos_app/storage/cliente_storage.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({
    super.key,
  });

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<Cliente>> listaClientes;
  final clienteStorage = ClienteStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (GetInfoUser.of(context).conexion!) {
      listaClientes = obtenerDatosClientes('clientes');
    }
    else {
      listaClientes = obtenerClienteLocal();
    }

    //debugPrint('$listaClientes');

    return Scaffold(      
      key: _scaffoldKey,
      drawer: MyDrawer(),
      appBar: MyAppBar(
        myButtonDrawer: MyButtonDrawer(
          scaffoldKey: _scaffoldKey,
        ),
      ),
      body: FutureBuilder(
        future: listaClientes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(children: verClientes(snapshot.data!));
          }
          else if (snapshot.hasError) {
            return Center(
              child: Text(
                'No hay datos',
                style: TextStyle(fontSize: 20.0),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  List<Widget> verClientes(List<Cliente> datos) {
    List<Widget> clientes = [];

    clientes.add(
      Card(
        child: ListTile(
          title: Text(
            'Listado de clientes',
            style: TextStyle(fontSize: 20.0),
          ),
          trailing: IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: BuscarCliente(listaClientes: datos),
              );
            },
            icon: Icon(Icons.search),
          ),
        ),
      ),
    );

    for (var item in datos) {
      clientes.add(
        Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                item.cliente.substring(0, 2),
              ),
            ),
            title: Text(item.cliente),
            subtitle: Text(item.rif),
            trailing: Text(item.grupoCliente),
          ),
        ),
      );
    }

    clienteStorage.writeCliente(datos);

    return clientes;
  }
}