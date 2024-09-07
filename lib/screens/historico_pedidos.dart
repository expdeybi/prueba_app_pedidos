import 'package:flutter/material.dart';
import 'package:pedidos_app/components/my_appbar.dart';
import 'package:pedidos_app/components/my_button_drawer.dart';
import 'package:pedidos_app/components/my_drawer.dart';

class HistoricoPedidos extends StatefulWidget {
  const HistoricoPedidos({super.key});

  @override
  State<HistoricoPedidos> createState() => _HistoricoPedidosState();
}

class _HistoricoPedidosState extends State<HistoricoPedidos> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: MyDrawer(),
        appBar: MyAppBar(
          myButtonDrawer: MyButtonDrawer(
            scaffoldKey: _scaffoldKey,
          ),
        ),
        body: Center(
          child: Text('Historico de pedidos'),
        ),
    );
  }
}