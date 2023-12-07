import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto/routes/navigationbarapp.dart';

Future CreateUser({required String descricao}) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc();

  final user = User(
      id: docUser.id,
      descricao: descricao,
      valor: valor,
      selectedOption: selectedOption);

  final json = user.toJson();
  await docUser.set(json);
}

class User {
  String id;
  final String descricao;
  final double valor;
  final String selectedOption;

  User(
      {this.id = '',
      required this.descricao,
      required this.valor,
      required this.selectedOption});

  Map<String, dynamic> toJson() => {
        'id': id,
        'descricao': descricao,
        'valor': valor,
        'selectedOption': selectedOption
      };
}
