import 'package:flutter/material.dart';
import 'dart:math';
import 'package:animate_do/animate_do.dart';

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
    'Años',
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A4D68), Color(0xFF088395)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 500),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Text(
                        'Calculadora de Anualidades',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildInputField(
                            controller: _pagoController,
                            label: 'Pago Periódico (\$)',
                            icon: Icons.attach_money,
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            controller: _tasaAnualController,
                            label: 'Tasa de Interés Anual (%)',
                            icon: Icons.percent,
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            controller: _periodosController,
                            label: 'Número de Períodos',
                            icon: Icons.calendar_today,
                          ),
                          const SizedBox(height: 16),
                          _buildDropdown(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  duration: const Duration(milliseconds: 700),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _calcularValorFuturo,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          backgroundColor: const Color(0xFF05BFDB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Valor Futuro',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _calcularValorPresente,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          backgroundColor: const Color(0xFF05BFDB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Valor Presente',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _resultado,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0A4D68),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF088395)),
        prefixIcon: Icon(icon, color: const Color(0xFF05BFDB)),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF05BFDB), width: 2),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _periodoSeleccionado,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF05BFDB)),
          onChanged: (String? newValue) {
            setState(() {
              _periodoSeleccionado = newValue!;
            });
          },
          items:
              _periodos.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
        ),
      ),
    );
  }
}
