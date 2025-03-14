import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class InteresCalculadora extends StatefulWidget {
  @override
  _InteresCalculadoraState createState() => _InteresCalculadoraState();
}

class _InteresCalculadoraState extends State<InteresCalculadora> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _tasaInteresController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  double _interes = 0;
  double _montoTotal = 0;
  bool _useDateRange = false;

  void _calcularInteres() {
    if (_formKey.currentState!.validate()) {
      final double principal = double.parse(_principalController.text);
      final double tasaInteres = double.parse(_tasaInteresController.text);
      DateTime startDate;
      DateTime endDate;

      if (_useDateRange) {
        startDate = _parseDate(_startDateController.text);
        endDate = _parseDate(_endDateController.text);
      } else {
        final int days = int.tryParse(_daysController.text) ?? 0;
        final int months = int.tryParse(_monthsController.text) ?? 0;
        final int years = int.tryParse(_yearsController.text) ?? 0;
        startDate = DateTime.now();
        endDate = startDate.add(
          Duration(days: days + months * 30 + years * 365),
        );
      }

      final double tiempoEnAnios = _calculateTimeInYears(startDate, endDate);

      setState(() {
        _interes = (principal * tasaInteres * tiempoEnAnios) / 100;
        _montoTotal = principal + _interes;
      });
    }
  }

  double _calculateTimeInYears(DateTime startDate, DateTime endDate) {
    final Duration difference = endDate.difference(startDate);
    return difference.inDays / 365;
  }

  DateTime _parseDate(String date) {
    final List<String> parts = date.split('/');
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
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
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
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
                          'Calculadora de Interés',
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
                              controller: _principalController,
                              label: 'Principal (\$)',
                              icon: Icons.attach_money,
                            ),
                            const SizedBox(height: 16),
                            _buildInputField(
                              controller: _tasaInteresController,
                              label: 'Tasa de Interés (%)',
                              icon: Icons.percent,
                            ),
                            const SizedBox(height: 16),
                            SwitchListTile(
                              title: const Text(
                                "Usar rango de fechas",
                                style: TextStyle(color: Colors.black87),
                              ),
                              value: _useDateRange,
                              onChanged: (bool value) {
                                setState(() {
                                  _useDateRange = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_useDateRange) ...[
                    FadeInUp(
                      duration: const Duration(milliseconds: 700),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              _buildDateField(
                                controller: _startDateController,
                                label: "Fecha de Inicio",
                                context: context,
                              ),
                              const SizedBox(height: 16),
                              _buildDateField(
                                controller: _endDateController,
                                label: "Fecha de Finalización",
                                context: context,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    FadeInUp(
                      duration: const Duration(milliseconds: 700),
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
                                controller: _daysController,
                                label: 'Número de Días',
                                icon: Icons.calendar_today,
                              ),
                              const SizedBox(height: 16),
                              _buildInputField(
                                controller: _monthsController,
                                label: 'Número de Meses',
                                icon: Icons.calendar_today,
                              ),
                              const SizedBox(height: 16),
                              _buildInputField(
                                controller: _yearsController,
                                label: 'Número de Años',
                                icon: Icons.calendar_today,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    child: ElevatedButton(
                      onPressed: _calcularInteres,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
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
                        'Calcular',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_interes > 0 || _montoTotal > 0)
                    FadeInUp(
                      duration: const Duration(milliseconds: 900),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                'Interés: \$${_interes.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0A4D68),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Monto Total: \$${_montoTotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0A4D68),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
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

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required BuildContext context,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF088395)),
        prefixIcon: Icon(Icons.calendar_today, color: const Color(0xFF05BFDB)),
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
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today, color: Color(0xFF05BFDB)),
          onPressed: () => _selectDate(context, controller),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese este campo';
        }
        return null;
      },
    );
  }
}
