import 'package:pedidos_app/components/my_appbar.dart';
import 'package:pedidos_app/components/my_button_drawer.dart';
import 'package:pedidos_app/components/my_drawer.dart';
import 'package:pedidos_app/inherited/my_inherited.dart';
import 'package:pedidos_app/provides_off/my_get_user_off.dart';
import 'package:pedidos_app/screens/categorias.dart';
import 'package:pedidos_app/screens/client_screen.dart';
import 'package:flutter/material.dart';
import 'package:pedidos_app/screens/existencias.dart';
import 'package:pedidos_app/screens/historico_pedidos.dart';
import 'package:pedidos_app/models/user.dart';
import 'package:pedidos_app/screens/order_pedidos.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final supabase = Supabase.instance.client;

  late Future<List<Usuario>>? listaUsuarios;

  @override
  void initState() {
    super.initState();
    
  }
  
  @override
  Widget build(BuildContext context) {
    if (!GetInfoUser.of(context).conexion!) {
      getInfoUserOffline();
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      appBar: MyAppBar(
        myButtonDrawer: MyButtonDrawer(
          scaffoldKey: _scaffoldKey,
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 4.0),
            child: Card(
              color: Color(0xffffffff),
              elevation: 3.0,
              child: ListTile(
                title: Text('Categorias',
                            textAlign: TextAlign.center,),
                subtitle: Image.asset('assets/img/categorias.png'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ListadoCategorias(),
                    )
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 4.0),
            child: Card(
              color: Color(0xffffffff),
              elevation: 3.0,
              child: ListTile(
                title: Text('Historico de pedidos',
                            textAlign: TextAlign.center,),
                subtitle: Image.asset('assets/img/pedidos.png'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => HistoricoPedidos(),
                    )
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 4.0),
            child: Card(
              color: Color(0xffffffff),
              elevation: 3.0,
              child: ListTile(
                title: Text('Clientes',
                             textAlign: TextAlign.center,),
                subtitle: Image.asset('assets/img/clientes.png',),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientScreen(),
                    )
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 4.0),
            child: Card(
              color: Color(0xffffffff),
              elevation: 3.0,
              child: ListTile(
                title: Text('Existencias',
                             textAlign: TextAlign.center,),
                subtitle: Image.asset('assets/img/existencias.png'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ListadoExistencias(),
                    )
                  );
                },
              ),
            ),
          ),
        ],
      ), 
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrdenPedido())
            );
         },
        label: Text(
          'Pedidos',
          style: TextStyle(
            color: Color(0xffffffff),
          )
        ),
        icon: Icon(
          Icons.thumb_up_alt,
          color: Color(0xffffffff)),
        backgroundColor: Color(0xffec1c24),
      ),
    );
  }

  void getInfoUserOffline() {
    listaUsuarios = obtenerUsuariosLocal();
    
    listaUsuarios!.then((value) {
      GetInfoUser infoUser;

      infoUser = GetInfoUser.of(context);

      if (value.isNotEmpty)
      {
        for (var item in value) {
          infoUser.setId(item.id);
          infoUser.setTokenType('');
          infoUser.setFullName(item.fullName);
          infoUser.setUserEmail(item.userEmail);
        }
      }
      else {
        infoUser.setId('');
        infoUser.setTokenType('');
        infoUser.setUserEmail('jhondoe@gamil.com');
        infoUser.setFullName('Jhon Doe');
      }
    });
  }
}
