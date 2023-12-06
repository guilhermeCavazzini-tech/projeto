import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Formulario extends StatelessWidget {
  final String descricao;
  final int valor;

  const Formulario(this.descricao, this.valor, {super.key});

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference user = FirebaseFirestore.instance.collection('user');

    Future<void> Formulario() {
      // Call the user's CollectionReference to add a new user
      return user
          .add({
            'descricao': descricao,
            'valor': valor,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return TextButton(
      onPressed: Formulario,
      child: const Text(
        "Add User",
      ),
    );
  }
}
