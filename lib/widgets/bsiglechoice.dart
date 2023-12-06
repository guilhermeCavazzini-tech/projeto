import 'package:flutter/material.dart';

class SingleChoice extends StatefulWidget {
  const SingleChoice({super.key});

  @override
  State<SingleChoice> createState() => SingleChoiceState();
}

enum EntrarSair {
  entrada,
  saida,
}

class SingleChoiceState extends State<SingleChoice> {
  EntrarSair estadoentrada = EntrarSair.entrada;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<EntrarSair>(
      segments: const <ButtonSegment<EntrarSair>>[
        ButtonSegment<EntrarSair>(
            value: EntrarSair.entrada,
            label: Text('Entrada'),
            icon: Icon(
              Icons.expand_more,
              color: Colors.green,
            )),
        ButtonSegment<EntrarSair>(
            value: EntrarSair.saida,
            label: Text('Saida'),
            icon: Icon(
              Icons.expand_less,
              color: Colors.red,
            )),
      ],
      selected: <EntrarSair>{estadoentrada},
      selectedIcon: const Icon(Icons.adjust),
      onSelectionChanged: (Set<EntrarSair> newSelection) {
        setState(() {
          // By default there is only a single segment that can be
          // selected at one time, so its value is always the first
          // item in the selected set.
          estadoentrada = newSelection.first;
        });
      },
    );
  }
}
