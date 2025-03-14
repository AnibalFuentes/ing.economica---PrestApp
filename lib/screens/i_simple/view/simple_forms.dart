import 'package:flutter/material.dart';
import 'package:prestapp/screens/i_simple/services/interes_calculator.dart';
import 'package:animate_do/animate_do.dart';

class SimpleForms extends StatefulWidget {
  const SimpleForms({super.key});

  @override
  State<SimpleForms> createState() => _SimpleFormsState();
}

class _SimpleFormsState extends State<SimpleForms> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _capitalController = TextEditingController();
  final TextEditingController _finalCapitalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  double? _result;
  bool _knowsExactDates = true;
  String _selectedOption = 'Monto futuro';
  final InterestCalculator _calculator = InterestCalculator();

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final double? capital =
          _capitalController.text.isNotEmpty
              ? double.tryParse(_capitalController.text)
              : null;
      final double? finalCapital =
          _finalCapitalController.text.isNotEmpty
              ? double.tryParse(_finalCapitalController.text)
              : null;
      final double rate = double.parse(_rateController.text);
      DateTime startDate;
      DateTime endDate;

      if (_knowsExactDates) {
        startDate = _calculator.parseDate(_startDateController.text);
        endDate = _calculator.parseDate(_endDateController.text);
      } else {
        final int days = int.tryParse(_daysController.text) ?? 0;
        final int months = int.tryParse(_monthsController.text) ?? 0;
        final int years = int.tryParse(_yearsController.text) ?? 0;
        startDate = DateTime.now();
        endDate = startDate.add(
          Duration(days: days + months * 30 + years * 360),
        );
      }

      setState(() {
        if (capital != null && finalCapital == null) {
          if (_selectedOption == 'Monto futuro') {
            _result = _calculator.calculateFutureAmount(
              capital: capital,
              rate: rate,
              startDate: startDate,
              endDate: endDate,
            );
          } else if (_selectedOption == 'Interés') {
            final double years =
                int.tryParse(_yearsController.text)?.toDouble() ?? 0;
            final double months =
                (int.tryParse(_monthsController.text)?.toDouble() ?? 0) / 12;
            final double days =
                (int.tryParse(_daysController.text)?.toDouble() ?? 0) / 360;
            final double totalTime = years + months + days;
            _result = (capital * (rate / 100)) * totalTime;
          } else if (_selectedOption == 'Capital') {
            final double time = endDate.difference(startDate).inDays / 360;
            final tiempo =
                int.tryParse(_yearsController.text) ??
                int.tryParse(_monthsController.text) ??
                int.tryParse(_daysController.text) ??
                time;
            _result = (capital / ((rate / 100) * tiempo));
          }
        } else if (capital == null && finalCapital != null) {
          if (_selectedOption == 'Principal prestamo') {
            _result = _calculator.calculateInitialCapitalPrestamo(
              finalCapital: finalCapital,
              rate: rate,
              tiempo:
                  int.tryParse(_yearsController.text) ??
                  int.tryParse(_monthsController.text) ??
                  int.tryParse(_daysController.text) ??
                  0,
              startDate: startDate,
              endDate: endDate,
            );
          } else {
            final initialCapital = _calculator.calculateInitialCapital(
              finalCapital: finalCapital,
              rate: rate,
              tiempo:
                  int.tryParse(_yearsController.text) ??
                  int.tryParse(_monthsController.text) ??
                  int.tryParse(_daysController.text) ??
                  0,
              startDate: startDate,
              endDate: endDate,
            );
            _result = initialCapital;
          }
        }
      });

      if (_result != null) {
        _showResultDialog();
      }
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Resultado',
              style: TextStyle(
                color: Color(0xFF0A4D68),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'El valor calculado es:',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF05BFDB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: Color(0xFF0A4D68),
                        size: 32,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "$_selectedOption:",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF0A4D68),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _calculator.formatNumber(_result!),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0A4D68),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cerrar',
                  style: TextStyle(color: Color(0xFF088395)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF05BFDB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Nuevo cálculo'),
              ),
            ],
          ),
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0A4D68),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0A4D68),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = _calculator.formatDate(picked);
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
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Text(
                      'Calculadora de Interés Simple',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Datos de cálculo',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A4D68),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Ingresa los datos según el cálculo deseado',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // First section - Capital inputs
                            _buildSectionTitle('Valores del capital'),
                            const SizedBox(height: 16),
                            _buildInputField(
                              controller: _capitalController,
                              label: "Capital Inicial",
                              icon: Icons.attach_money,
                            ),
                            const SizedBox(height: 16),
                            _buildInputField(
                              controller: _finalCapitalController,
                              label: "Capital Final",
                              icon: Icons.attach_money,
                            ),
                            const SizedBox(height: 16),
                            _buildInputField(
                              controller: _rateController,
                              label: "Tasa de Interés (%)",
                              icon: Icons.percent,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingrese la tasa de interés';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Second section - Time inputs
                            _buildSectionTitle('Período de tiempo'),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF05BFDB).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _knowsExactDates
                                        ? Icons.date_range
                                        : Icons.calendar_view_week,
                                    color: const Color(0xFF0A4D68),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      "Método de ingreso de tiempo",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF0A4D68),
                                      ),
                                    ),
                                  ),
                                  Switch(
                                    value: _knowsExactDates,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _knowsExactDates = value;
                                      });
                                    },
                                    activeColor: const Color(0xFF05BFDB),
                                    activeTrackColor: const Color(
                                      0xFF05BFDB,
                                    ).withOpacity(0.4),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _knowsExactDates
                                  ? 'Usando fechas específicas'
                                  : 'Usando período de tiempo',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 16),

                            if (_knowsExactDates) ...[
                              _buildDateField(
                                controller: _startDateController,
                                label: "Fecha de Inicio",
                                icon: Icons.calendar_today,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Ingrese la fecha de inicio';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildDateField(
                                controller: _endDateController,
                                label: "Fecha de Finalización",
                                icon: Icons.calendar_today,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Ingrese la fecha de finalización';
                                  }
                                  return null;
                                },
                              ),
                            ] else ...[
                              _buildInputField(
                                controller: _daysController,
                                label: "Días",
                                icon: Icons.calendar_view_day,
                              ),
                              const SizedBox(height: 16),
                              _buildInputField(
                                controller: _monthsController,
                                label: "Meses",
                                icon: Icons.calendar_view_month,
                              ),
                              const SizedBox(height: 16),
                              _buildInputField(
                                controller: _yearsController,
                                label: "Años",
                                icon: Icons.calendar_today,
                              ),
                            ],
                            const SizedBox(height: 24),

                            // Third section - Calculation type
                            _buildSectionTitle('Tipo de cálculo'),
                            const SizedBox(height: 16),
                            _buildDropdown(),
                            const SizedBox(height: 32),

                            // Calculate button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _calculate,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(16),
                                  backgroundColor: const Color(0xFF05BFDB),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calculate_outlined),
                                    SizedBox(width: 8),
                                    Text(
                                      "Calcular",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF05BFDB),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A4D68),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF088395)),
          prefixIcon: Icon(icon, color: const Color(0xFF05BFDB)),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF05BFDB), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400, width: 2),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF088395)),
          prefixIcon: Icon(icon, color: const Color(0xFF05BFDB)),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF05BFDB), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400, width: 2),
          ),
          suffixIcon: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF05BFDB).withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.calendar_today),
              color: const Color(0xFF0A4D68),
              onPressed: () => _selectDate(context, controller),
            ),
          ),
        ),
        validator: validator,
      ),
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
          value: _selectedOption,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF05BFDB)),
          onChanged: (String? newValue) {
            setState(() {
              _selectedOption = newValue!;
            });
          },
          items:
              <String>[
                'Monto futuro',
                'Monto inicial',
                'Interés',
                'Principal prestamo',
                'Capital',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Color(0xFF0A4D68)),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
