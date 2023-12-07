import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto/widgets/bsiglechoice.dart';
import 'package:projeto/widgets/escrita.dart';

var textEditingController = TextEditingController(text: " ");
var singleChoice = const SingleChoice();
final formKey = GlobalKey<FormState>();

String selectedOption = "Entrada";
var name = '';
var descricao = '';
var valor = 0.0;
var saldo = 0.0;
var contador = 0;

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

class SaldoWidget extends StatelessWidget {
  final double saldo;

  SaldoWidget({required this.saldo});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Saldo Atual:',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            'R\$ ${saldo.toStringAsFixed(2)}', // Formatando para exibir duas casas decimais
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ],
      ),
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
  var controllerdescricao = TextEditingController();
  var controllervalor = TextEditingController();

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
            icon: Badge(child: Icon(Icons.account_balance_wallet)),
            label: 'SALDO',
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
                              controller: controllerdescricao =
                                  TextEditingController(),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
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
                            controller: controllervalor =
                                TextEditingController(),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Valor",
                                hintText: "Digite um Valor"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Insira um valor";
                              } else {
                                try {
                                  valor = double.parse(value);
                                  // Validar se o valor é um número válido
                                  if (valor.isNaN || valor.isInfinite) {
                                    throw const FormatException();
                                  }
                                  return null;
                                } catch (e) {
                                  // Se não puder ser convertido para double, mostrar aviso.
                                  return "Insira um valor numérico válido";
                                }
                              }
                            },
                          ),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Ajuste o valor conforme necessário
                                border: Border.all(
                                    color: const Color.fromARGB(255, 255, 255,
                                        255)), // Adicione uma borda se desejar
                              ),
                              child: DropdownButton<String>(
                                icon: const Icon(Icons.arrow_downward),
                                value: selectedOption,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedOption = newValue!;
                                  });
                                },
                                items: <String>['Entrada', 'Saida']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )),
                          const SizedBox(height: 18),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            Colors.green)),
                                onPressed: () async {
                                  // Validate returns true if the form is valid, or false otherwise.

                                  // ignore: avoid_print
                                  formKey.currentState?.save();
                                  formKey.currentState!.context;

                                  if (formKey.currentState!.validate()) {
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    final user = User(
                                        descricao: descricao,
                                        valor: valor,
                                        selectedOption: selectedOption);
                                    await CreateUser(descricao: user.descricao);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.cyan,
                                        content: Text('Registrado'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                    if (user.selectedOption == 'Entrada') {
                                      saldo += user.valor;
                                    } else if (user.selectedOption == 'Saida') {
                                      saldo -= user.valor;
                                    }

                                    formKey.currentState?.reset();
                                  }
                                },
                                child: const Text('ENVIAR'),
                              ),
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

          Card(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro: ${snapshot.error}'),
                  );
                }

                final List<DocumentSnapshot> documents = snapshot.data!.docs;

                return documents.isEmpty
                    ? const Center(child: Text('Nenhum dado disponível.'))
                    : ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final Map<String, dynamic> data =
                              documents[index].data() as Map<String, dynamic>;

                          return Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Descrição: ${data['descricao']}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Valor: ${data['valor']}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Tipo: ${data['selectedOption']}'),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
              },
            ),
          ),

          SaldoWidget(saldo: saldo)
        ][currentPageIndex],
      ),
    );
  }
}
