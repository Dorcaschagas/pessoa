import 'package:flutter/material.dart';
import 'package:pessoa_app/paciente.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Inicializa o sqflite_common_ffi
  sqfliteFfiInit();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    
    return MaterialApp(
      title: 'Pessoa App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PessoaScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


