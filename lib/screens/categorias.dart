import 'package:flutter/material.dart';
import 'package:pedidos_app/components/my_appbar.dart';
import 'package:pedidos_app/components/my_button_drawer.dart';
import 'package:pedidos_app/components/my_drawer.dart';
import 'package:pedidos_app/delegates/search_category.dart';
import 'package:pedidos_app/inherited/my_inherited.dart';
import 'package:pedidos_app/models/category.dart';
import 'package:pedidos_app/providers/my_get_category.dart';
import 'package:pedidos_app/provides_off/my_get_category_off.dart';
import 'package:pedidos_app/storage/categoria_storage.dart';

class ListadoCategorias extends StatefulWidget {
  const ListadoCategorias({super.key});

  @override
  State<ListadoCategorias> createState() => _ListadoCategoriasState();
}

class _ListadoCategoriasState extends State<ListadoCategorias> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<Categoria>> listaCategorias;
  final categoriaStorage = CategoriaStorage();
  
  @override
  void initState() {    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (GetInfoUser.of(context).conexion!) {
      listaCategorias = obtenerDatos('categorias');
    }
    else {
      listaCategorias = obtenerCategoriasLocal();
    }

    // debugPrint('$listaCategorias');

    return Scaffold(
        key: _scaffoldKey,
        drawer: MyDrawer(),
        appBar: MyAppBar(
          myButtonDrawer: MyButtonDrawer(
            scaffoldKey: _scaffoldKey,
          ),
        ),
        body: FutureBuilder(
          future: listaCategorias,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {              
                return ListView(children: verCategorias(snapshot.data!));
              }
              else {
                return Center(
                  child: Text(
                    'No hay datos',
                    style: TextStyle(fontSize: 20.0),
                  ),
                );
              }
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

  List<Widget> verCategorias(List<Categoria> datos) {
    List<Widget> widgetCategorias = [];

    widgetCategorias.add(
      Card(
        child: ListTile(
          title: Text(
            'Listado de categorias',
            style: TextStyle(fontSize: 20.0),
          ),
          trailing: IconButton(            
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BuscarCategoria(listaCategorias: datos),
              );
            },
          ),
        ),
      )
    );

    for (var item in datos) {
      widgetCategorias.add(
        Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(item.id),
            ),
            title: Text(item.categoria),
          ),
        )
      );      
    }

    categoriaStorage.writeCategoria(datos);

    return widgetCategorias;
  }
}
