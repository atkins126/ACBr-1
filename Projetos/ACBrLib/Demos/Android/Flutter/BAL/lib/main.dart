import 'dart:async';

import 'package:flutter/material.dart';
import 'acbrbalplugin.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo ACBrBal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _resultPeso = '0.0';
  bool _ativado = false;
  bool _inicializado = false;
  final acbrbalplugin = Acbrbalplugin();

  void inicializar() async {
    try {
      if (!_inicializado) {
        await acbrbalplugin.inicializar();
        _inicializado = true;
      }
    } on Exception catch (e) {
      print("Erro: '${e.toString()}'.");
    }
  }

  void setResultPeso(double peso) {
    setState(() {
      _resultPeso = peso.toString();
    });
  }

  void toggleAtivado() {
    setState(() {
      if (_ativado) {
        acbrbalplugin.desativar();
      } else {
        acbrbalplugin.ativar();
      }
      _ativado = !_ativado;
    });
  }

  Future<double> getPeso() async {
    try {
      double peso = await acbrbalplugin.lePeso(1000);
      return peso;
    } catch (error) {
      return -1.0;
    }
  }

  void onClickButtonGetPeso() async {
    if (!_ativado) {
      Fluttertoast.showToast(
        msg: "Balança não ativada",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    setResultPeso(await getPeso());
  }

  void onClickButtonResetPeso() {
    setResultPeso(0.0);
  }

  @override
  Widget build(BuildContext context) {
    inicializar();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Peso Atual:',
            ),
            Text(
              '$_resultPeso',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            MaterialButton(
              onPressed: onClickButtonGetPeso,
              child: const Text('Ler Peso'),
              color: Theme.of(context).colorScheme.primary, // Cor do botão
              textColor: Colors.white, // Cor do texto
              padding: EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 15.0), // Padding interno
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
              ),
            ),
            MaterialButton(
              onPressed: onClickButtonResetPeso,
              child: const Text('Zerar Peso'),
              color: Theme.of(context).colorScheme.primary, // Cor do botão
              textColor: Colors.white, // Cor do texto
              padding: EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 15.0), // Padding interno
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
              ),
            ),
            MaterialButton(
              onPressed: () {
                toggleAtivado();
              },
              child: Text(_ativado ? 'Desativar' : 'Ativar'),
              color: Theme.of(context).colorScheme.primary, // Cor do botão
              textColor: Colors.white, // Cor do texto
              padding: EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 15.0), // Padding interno
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
              ),
            ),
          ],
        ),
      ),
    );
  }
}