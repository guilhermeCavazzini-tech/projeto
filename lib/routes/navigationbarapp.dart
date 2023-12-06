import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto/widgets/bsiglechoice.dart';

var textEditingController = TextEditingController(text: " ");
var singleChoice = const SingleChoice();
final formKey = GlobalKey<FormState>();

var descricao = '';
var valor = '';
var saldo = '';
var contador = 0;

final descricaoadd = <String>[];
final valoradd = <String>[];

CollectionReference user = FirebaseFirestore.instance.collection('user');

class NavigationBarApp extends StatelessWidget {
  NavigationBarApp({super.key});
  final Stream<QuerySnapshot> user =
      FirebaseFirestore.instance.collection('user').snapshots();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color.fromARGB(255, 0, 213, 255),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.swap_horiz),
            icon: Icon(Icons.swap_horiz_outlined),
            label: 'ENTRADA/SAIDA',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.receipt)),
            label: 'REGISTROS',
          ),
          NavigationDestination(
            icon: Badge(
              child: Icon(Icons.track_changes),
            ),
            label: 'METAS',
          ),
        ],
      ),
      body: SafeArea(
        child: <Widget>[
          /// Home page

          Center(
            child: SizedBox(
              width: 800,
              child: Card(
                shadowColor: const Color.fromARGB(0, 249, 3, 19),
                margin: const EdgeInsets.all(8.0),
                child: SizedBox.expand(
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: Form(
                      key: formKey,
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 100,
                        children: [
                          TextFormField(
                              decoration: const InputDecoration(
                                  labelText: "Descrição",
                                  hintText: "Digite uma descrição"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Insira uma descrição";
                                } else {
                                  descricao = value;
                                }
                                return null;
                              }),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Valor",
                                hintText: "Digite um Valor"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Insira um valor";
                              } else {
                                valor = value;
                              }
                              return null;
                            },
                          ),
                          const SingleChoice(),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.

                                // ignore: avoid_print
                                formKey.currentState?.save();
                                formKey.currentState!.context;

                                if (formKey.currentState!.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                }

                                contador = contador + 1;
                                print(descricaoadd);
                                print(valoradd);
                                print(contador);

                                user
                                    .add({
                                      'descricao': descricao,
                                      'valor': valor
                                    })
                                    .then(
                                        (value) => print('Produto adicionado'))
                                    .catchError(
                                        // ignore: avoid_print
                                        (error) => print('falaha erro $error'));
                              },
                              child: const Text('Enviar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                ),
              ),
            ),
          ),

          /// Notifications page
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: Icon(Icons.swap_horiz),
                    title: Text('Registro 1'),
                    subtitle: Text("Entrada no valor de R\$ 500"),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.swap_horiz),
                    title: Text('Registro 2'),
                    subtitle: Text('Saida no valor de R\$ 500'),
                  ),
                ),
              ],
            ),
          ),

          /// Messages page
          ListView.builder(
              reverse: true,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Align(
                    alignment: Alignment.center,
                    child: Row(children: [
                      Container(
                        height: 40,
                        width: 200,
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                            controller: textEditingController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
                            inputFormatters: const [],
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center),
                      ),
                      ElevatedButton(
                          onPressed: () => {},
                          child: const Text(
                            'CONFIRMAR',
                          ))
                    ]),
                  );
                }
                return null;
              })
        ][currentPageIndex],
      ),
    );
  }
}
