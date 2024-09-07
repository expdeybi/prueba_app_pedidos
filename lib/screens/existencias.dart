import 'package:flutter/material.dart';
import 'package:pedidos_app/components/my_appbar.dart';
import 'package:pedidos_app/components/my_button_drawer.dart';
import 'package:pedidos_app/components/my_drawer.dart';
import 'package:pedidos_app/delegates/search_exist_prod.dart';
import 'package:pedidos_app/inherited/my_inherited.dart';
import 'package:pedidos_app/models/producto.dart';
import 'package:pedidos_app/providers/my_get_products.dart';
import 'package:pedidos_app/provides_off/my_get_product_off.dart';
import 'package:pedidos_app/storage/existencia_storage.dart';

class ListadoExistencias extends StatefulWidget {
  const ListadoExistencias({super.key});

  @override
  State<ListadoExistencias> createState() => _ListadoExistenciasState();
}

class _ListadoExistenciasState extends State<ListadoExistencias> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<Producto>> listaProductos;
  final productoStorage = ProductoStorage();

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    if (GetInfoUser.of(context).conexion!) {
      listaProductos = obtenerDatosProductos('productos');
    }
    else {
      listaProductos = obtenerProductosLocal();
    }

    //debugPrint('$listaProductos');

    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      appBar: MyAppBar(
        myButtonDrawer: MyButtonDrawer(
          scaffoldKey: _scaffoldKey,
        ),
      ),
      // Listado de existencias
      body: FutureBuilder(
        future: listaProductos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(children: verProductos(snapshot.data!));
          }
          else if (snapshot.hasError) {
            return const Center(
              child: const Text(
                'No hay datos',
                style: TextStyle(fontSize: 20.0),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  List<Widget> verProductos(List<Producto> datos) {
    List<Widget> prods = [];

    prods.add(
      Card(
        child: ListTile(
          title: Text(
            'Listado de productos',
            style: TextStyle(fontSize: 20.0),
          ),
          trailing: IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: BuscarProductos(listaProds: datos),
              );
            },
            icon: Icon(Icons.search),
          ),
        ),
      ),
    );

    for (var item in datos) {
      prods.add(
        Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(item.id),
            ),
            title: Text(item.producto),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Codigo: ${item.codigo}'),
                Text('Disponible: ${item.existencia}'),
              ],
            ),
            trailing: Text('cat: ${item.idCategoria}'),
          ),
        ),
      );
    }

    productoStorage.writeCliente(datos);

    return prods;
  }
}