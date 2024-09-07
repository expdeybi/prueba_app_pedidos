import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pedidos_app/components/my_appbar.dart';
import 'package:pedidos_app/components/my_button_drawer.dart';
import 'package:pedidos_app/components/my_drawer.dart';
import 'package:pedidos_app/inherited/my_inherited.dart';
import 'package:pedidos_app/models/cliente.dart';
import 'package:pedidos_app/models/producto.dart';
import 'package:pedidos_app/providers/my_get_client.dart';
import 'package:pedidos_app/providers/my_get_products.dart';
import 'package:pedidos_app/provides_off/my_get_client_off.dart';
import 'package:pedidos_app/provides_off/my_get_product_off.dart';
import 'package:pedidos_app/screens/ver_pedidos.dart';
import 'package:pedidos_app/storage/cliente_storage.dart';
import 'package:pedidos_app/storage/existencia_storage.dart';

class OrdenPedido extends StatefulWidget {
  const OrdenPedido({super.key});

  @override
  State<OrdenPedido> createState() => _OrdenPedidoState();
}

class _OrdenPedidoState extends State<OrdenPedido> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var maskCantidad = MaskTextInputFormatter(
    mask: '#####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  // Clientes 
  late Future<List<Cliente>> listaClientes;
  final clienteStorage = ClienteStorage();
  String? selectedValueClient;
  final textEditingControllerClient = TextEditingController();

  // Productos
  late Future<List<Producto>> listaProductos;
  final productoStorage = ProductoStorage();
  String? selectedValueProducto;
  final textEditingControllerProductos = TextEditingController();

  // Otros
  final textEditingControllerCantidad = TextEditingController();

  @override
  void dispose() {
    textEditingControllerClient.dispose(); // Se elimina de la RAM
    textEditingControllerProductos.dispose();
    textEditingControllerCantidad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (GetInfoUser.of(context).conexion!) {
      listaClientes = obtenerDatosClientes('clientes');
      listaProductos = obtenerDatosProductos('productos');
    }
    else {
      listaClientes = obtenerClienteLocal();
      listaProductos = obtenerProductosLocal();
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      appBar: MyAppBar(
        myButtonDrawer: MyButtonDrawer(
          scaffoldKey: _scaffoldKey,
        ),
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              leading: Image.asset('assets/img/order.png'),
              title: Text(
                'Realizar pedido',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              subtitle: Text('Emision del pedido'),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                   context,
                   MaterialPageRoute(
                    builder: (context) => VerPedidos(),
                   )
                  );
                },
                icon: Icon(Icons.shopping_cart_sharp),
              ),
            ),
          ),
          // Clientes
          FutureBuilder(
            future: listaClientes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        'Seleccionar cliente',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      // NOTA: Donde snapshot.data es la lista de clientes
                      items: snapshot.data!
                          .map((item) => DropdownMenuItem(
                                value: '${item.cliente} - ${item.id}',
                                child: Text(
                                  item.cliente,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      value: selectedValueClient,
                      onChanged: (value) {
                        setState(() {
                          selectedValueClient = value;
                        });
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 40,
                        width: 200,
                      ),
                      dropdownStyleData: const DropdownStyleData(
                        maxHeight: 200,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                      ),
                      dropdownSearchData: DropdownSearchData(
                        searchController: textEditingControllerClient,
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Container(
                          height: 50,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: TextFormField(
                            // NOTA: En windows textCapitalization no funciono
                            //       solo trabaja en android.
                            textCapitalization: TextCapitalization.characters,
                            expands: true,
                            maxLines: null,
                            controller: textEditingControllerClient,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: 'Search for an item...',
                              hintStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return item.value.toString().contains(searchValue);
                        },
                      ),
                      //This to clear the search value when you close the menu
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          textEditingControllerClient.clear();
                        }
                      },
                    ),
                  ),
                );
              }
              else if (snapshot.hasError) {
                return Text('No hay datos de clientes...');
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),

          // Productos
          FutureBuilder(
            future: listaProductos,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        'Seleccionar producto',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      // NOTA: Donde snapshot.data es la lista de clientes
                      items: snapshot.data!
                          .map((item) => DropdownMenuItem(
                                value: '${item.producto} - ${item.id}',
                                child: Text(
                                  item.producto,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      value: selectedValueProducto,
                      onChanged: (value) {
                        setState(() {
                          selectedValueProducto = value;
                        });
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 40,
                        width: 200,
                      ),
                      dropdownStyleData: const DropdownStyleData(
                        maxHeight: 200,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                      ),
                      dropdownSearchData: DropdownSearchData(
                        searchController: textEditingControllerProductos,
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Container(
                          height: 50,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: TextFormField(
                            // NOTA: En windows textCapitalization no funciono
                            //       solo trabaja en android.
                            textCapitalization: TextCapitalization.characters,
                            expands: true,
                            maxLines: null,
                            controller: textEditingControllerProductos,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: 'Buscar producto...',
                              hintStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return item.value.toString().contains(searchValue);
                        },
                      ),
                      //This to clear the search value when you close the menu
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          textEditingControllerProductos.clear();
                        }
                      },
                    ),
                  ),
                );
              }
              else if (snapshot.hasError) {
                return Text('No hay datos de productos...');
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),

          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.red,
                            ), 
                          ),
                        ),
                        child: Text(
                          'Precio x unidad',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.red,
                            ), 
                          ),
                        ),
                        child: Text(
                          'Existencia',
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),

          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      child: TextFormField(
                        controller: textEditingControllerCantidad,
                        inputFormatters: [maskCantidad],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            ), 
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          hintText: 'Cantidad',
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.red,
                            ), 
                          ),
                        ),
                        child: Text(
                          'Sub-total',
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ]
      ),
    );
  }
}