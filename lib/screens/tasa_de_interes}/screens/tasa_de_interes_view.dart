import 'package:flutter/material.dart';

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
  bool _useDateRange =
      false; // Cambiado a false para usar días/meses por defecto

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
      appBar: AppBar(title: const Text('Calculadora de Interés')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _principalController,
                decoration: const InputDecoration(labelText: 'Principal (\$)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el principal';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tasaInteresController,
                decoration: const InputDecoration(
                  labelText: 'Tasa de Interés (%)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la tasa de interés';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text("Usar rango de fechas"),
                value: _useDateRange,
                onChanged: (bool value) {
                  setState(() {
                    _useDateRange = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              if (_useDateRange) ...[
                TextFormField(
                  controller: _startDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Fecha de Inicio",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed:
                          () => _selectDate(context, _startDateController),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la fecha de inicio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _endDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Fecha de Finalización",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, _endDateController),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la fecha de finalización';
                    }
                    return null;
                  },
                ),
              ] else ...[
                TextFormField(
                  controller: _daysController,
                  decoration: const InputDecoration(
                    labelText: 'Número de Días',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _monthsController,
                  decoration: const InputDecoration(
                    labelText: 'Número de Meses',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _yearsController,
                  decoration: const InputDecoration(
                    labelText: 'Número de Años',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularInteres,
                child: const Text('Calcular'),
              ),
              const SizedBox(height: 20),
              Text(
                'Interés: \$${_interes.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Monto Total: \$${_montoTotal.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
