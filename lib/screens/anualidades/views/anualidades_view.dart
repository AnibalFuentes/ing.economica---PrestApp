import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Anualidades',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AnualidadScreen(),
    );
  }
}

class AnualidadScreen extends StatefulWidget {
  const AnualidadScreen({super.key});

  @override
  _AnualidadScreenState createState() => _AnualidadScreenState();
}

class _AnualidadScreenState extends State<AnualidadScreen> {
  final _pagoController = TextEditingController();
  final _tasaAnualController = TextEditingController();
  final _periodosController = TextEditingController();
  String _resultado = '';
  String _periodoSeleccionado = 'Meses';

  final List<String> _periodos = [
    'Meses',
    'Bimestres',
    'Trimestres',
    'Cuatrimestres',
    'Semestres',
    'Años', // Nuevo periodo agregado
  ];

  void _calcularValorFuturo() {
    final pago = double.tryParse(_pagoController.text) ?? 0;
    final tasaAnual = double.tryParse(_tasaAnualController.text) ?? 0;
    final periodos = int.tryParse(_periodosController.text) ?? 0;

    if (pago <= 0 || tasaAnual <= 0 || periodos <= 0) {
      setState(() {
        _resultado = 'Por favor, ingresa valores válidos.';
      });
      return;
    }

    double tasaPeriodica;
    switch (_periodoSeleccionado) {
      case 'Meses':
        tasaPeriodica = tasaAnual / 12 / 100;
        break;
      case 'Bimestres':
        tasaPeriodica = tasaAnual / 6 / 100;
        break;
      case 'Trimestres':
        tasaPeriodica = tasaAnual / 4 / 100;
        break;
      case 'Cuatrimestres':
        tasaPeriodica = tasaAnual / 3 / 100;
        break;
      case 'Semestres':
        tasaPeriodica = tasaAnual / 2 / 100;
        break;
      case 'Años':
        tasaPeriodica = tasaAnual / 100;
        break;
      default:
        tasaPeriodica = 0;
    }

    final valorFuturo =
        pago * ((pow(1 + tasaPeriodica, periodos) - 1) / tasaPeriodica);

    setState(() {
      _resultado = 'Valor Futuro: \$${valorFuturo.toStringAsFixed(2)}';
    });
  }

  void _calcularValorPresente() {
    final pago = double.tryParse(_pagoController.text) ?? 0;
    final tasaAnual = double.tryParse(_tasaAnualController.text) ?? 0;
    final periodos = int.tryParse(_periodosController.text) ?? 0;

    if (pago <= 0 || tasaAnual <= 0 || periodos <= 0) {
      setState(() {
        _resultado = 'Por favor, ingresa valores válidos.';
      });
      return;
    }

    double tasaPeriodica;
    switch (_periodoSeleccionado) {
      case 'Meses':
        tasaPeriodica = tasaAnual / 12 / 100;
        break;
      case 'Bimestres':
        tasaPeriodica = tasaAnual / 6 / 100;
        break;
      case 'Trimestres':
        tasaPeriodica = tasaAnual / 4 / 100;
        break;
      case 'Cuatrimestres':
        tasaPeriodica = tasaAnual / 3 / 100;
        break;
      case 'Semestres':
        tasaPeriodica = tasaAnual / 2 / 100;
        break;
      case 'Años':
        tasaPeriodica = tasaAnual / 100;
        break;
      default:
        tasaPeriodica = 0;
    }

    final valorPresente =
        pago * (1 - pow(1 + tasaPeriodica, -periodos)) / tasaPeriodica;

    setState(() {
      _resultado = 'Valor Presente: \$${valorPresente.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Anualidades')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _pagoController,
              decoration: const InputDecoration(
                labelText: 'Pago Periódico (\$)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tasaAnualController,
              decoration: const InputDecoration(
                labelText: 'Tasa de Interés Anual (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _periodosController,
              decoration: const InputDecoration(
                labelText: 'Número de Períodos',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _periodoSeleccionado,
              items:
                  _periodos.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _periodoSeleccionado = newValue!;
                });
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _calcularValorFuturo,
                  child: const Text('Calcular Valor Futuro'),
                ),
                ElevatedButton(
                  onPressed: _calcularValorPresente,
                  child: const Text('Calcular Valor Presente'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              _resultado,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
