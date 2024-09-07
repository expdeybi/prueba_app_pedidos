// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:pedidos_app/extensions/extension_string.dart';
import 'package:pedidos_app/models/category.dart';

class BuscarCategoria extends SearchDelegate {
  final List<Categoria> listaCategorias;
  List<Categoria> _filtroCategorias = [];

  BuscarCategoria({
    required this.listaCategorias,
  });

  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => 'Buscar categoria';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }
  
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }
  
  @override
  Widget buildResults(BuildContext context) {
    List<Categoria> categorias = [];

    if (query.isNotEmpty) {
      query = query.capitalize().trim();
    }

    for (var item in listaCategorias) {
      if (item.categoria.contains(query)) {
        categorias.add(
          Categoria(
            id: item.id,
            categoria: item.categoria
          )
        );
      }
    }

    return ListView.builder(
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        return createCategoryCard(categorias[index]);
      },
    );
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      query = query.capitalize().trim();
    }

    _filtroCategorias = listaCategorias.where((cat) {      
      return cat.categoria.contains(query);
    }
    ).toList();

    return ListView.builder(
      itemCount: _filtroCategorias.length,
      itemBuilder: (context, index) {
        return createCategoryCard(_filtroCategorias[index]);
      },
    );
  }

  Widget createCategoryCard(Categoria cat) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(cat.id),
        ),
        title: Text(cat.categoria),
      ),
    );
  }
}
