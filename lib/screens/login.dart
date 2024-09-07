import 'package:pedidos_app/components/my_appbar.dart';
import 'package:pedidos_app/inherited/my_inherited.dart';
import 'package:pedidos_app/models/auth.dart'; // Auth
import 'package:pedidos_app/models/profile.dart';
import 'package:pedidos_app/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:pedidos_app/storage/user_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final supabase = Supabase.instance.client;
  late bool passwordVisible;
  late Future<Auth> loginUser;

  final userStorage = UserStorage();

  final emailUser = TextEditingController();
  final passwordUser = TextEditingController();

  @override
  void dispose() {
    emailUser.dispose();
    passwordUser.dispose();
    super.dispose();
  }


  void toogle() {
    setState(() {
      passwordVisible = !passwordVisible;  
    });    
  }

  @override
  void initState() {    
    super.initState();
    passwordVisible = true;
    // TEMPORAL - REMOVER LUEGO
    emailUser.text = 'expdeybiandroid@gmail.com';
    passwordUser.text = 'demo1234';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: cuerpo(),
    );
  }

  Widget cuerpo() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          titulo(),
          SizedBox(height: 22.0),
          email(),
          clave(),
          SizedBox(height: 22.0),
          entrar(),
        ],
      ),
    );
  }

  Widget titulo() {
    return Text(
      'Iniciar Sesion',
      style: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget email() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 1.0),
      child: TextField(
        controller: emailUser,
        decoration: InputDecoration(
          hintText: 'Escribe tu correo',
        ),
        autofocus: true,
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }

  Widget clave() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 1.0),
      child: TextField(
        controller: passwordUser,
        decoration: InputDecoration(
          hintText: 'Escribe tu clave',
          suffixIcon: IconButton(
            onPressed: () {
              toogle();
            },
            icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
            color: Theme.of(context).primaryColor,
          ),
        ),
        obscureText: passwordVisible,
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }

  Widget entrar() {
    return ElevatedButton.icon(
      onPressed: () {
        loginUser = authUser();
        loginUser.then((value) => {
          value.accessToken.isNotEmpty ? 
          goDashBoard(value.id, value.accessToken, value.tokenType, value.userEmail) :
          msgErrorLogin()
        });
      },
      icon: Icon(Icons.login_rounded),
      label: Text('Entrar', style: TextStyle(fontSize: 18.0),),
    );
  }

  Future<Auth> authUser() async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: emailUser.text,
        password: passwordUser.text,
      );

      final session = response.session!;
      final user = response.user!;

      //debugPrint(response.toString());

      return Auth(
        id: user.id,
        accessToken: session.accessToken,
        tokenType: session.tokenType,
        // email se refiere al campo email de la tabla usuario (users (schema: auth))
        userEmail: user.email.toString(),
      );
    }
    catch(ex) {
      return Auth(
        id: '',
        accessToken: '',
        tokenType: '',
        userEmail: '',
      );
    }
  }

  Future<Profile> obtenerPerfil(String id) async {
    final response = await supabase.from('profiles').select('*').eq('id', id);

    debugPrint(response.toString());
                                      // full_name es un campo de la tabla Profile en supabase
    return Profile(fullName: response[0]['full_name']);

    //return Future.error('Fallo la conexion');
  }

  void goDashBoard(String id, String accessToken,
                   String tokenType, String userEmail) {
    obtenerPerfil(id).then(
      (perfil) {
        GetInfoUser infoUser = GetInfoUser.of(context);
        
        infoUser.setId(id);
        infoUser.setTokenType(tokenType);
        infoUser.setUserEmail(userEmail);
        infoUser.setFullName(perfil.fullName);

        userStorage.writeUser(id, perfil.fullName, userEmail);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          )
        );
      }
    );
  }

  void msgErrorLogin() {
    showDialog(context: context,
               builder: (context) => AlertDialog(
                  title: Text('Aviso importante'),
                  content: Text('Credenciales no registradas'),
                  actions: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.check_circle),
                      label: Text('Aceptar'),
                    )
                  ],
               ),
    );
  }
}
