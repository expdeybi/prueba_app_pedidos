import 'package:flutter/material.dart';
import 'package:pedidos_app/models/producto.dart';

class BuscarProductos extends SearchDelegate {
  final List<Producto> listaProds;
  List<Producto> _filtroProds = [];

  BuscarProductos({
    required this.listaProds
  });

  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => 'Buscar productos';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.close),
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Producto> prods = [];

    for (var item in listaProds) {
      if (item.producto.toUpperCase().contains(
        query.toUpperCase().trim())) {
        prods.add(
          Producto(
            id: item.id,
            codigo: item.codigo,
            producto: item.producto,
            idCategoria: item.idCategoria,
            existencia: item.existencia)
        );
      }
    }

    return ListView.builder(
      itemCount: prods.length,
      itemBuilder: (context, index) {
        return _createWidgetProd(prods[index]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _filtroProds = listaProds.where((prod) {
        return prod.producto.toUpperCase().contains(query.toUpperCase().trim());
      },
    ).toList();

    return ListView.builder(
      itemCount: _filtroProds.length,
      itemBuilder: (context, index) {
        return _createWidgetProd(_filtroProds[index]);
      },
    );
  }

  Widget _createWidgetProd(Producto prod)
  {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(prod.id),
        ),
        title: Text(prod.producto),
        subtitle: Align(
          child: Column(
            children: [
              Text('Codigo: ${prod.codigo}'),
              Text('Disponible: ${prod.existencia}'),
            ],
          ),
        ),
        trailing: Text('cat: ${prod.idCategoria}'),
      ),
    );
  }
}