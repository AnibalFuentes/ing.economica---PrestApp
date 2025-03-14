import 'package:flutter/material.dart';
import 'package:prestapp/screens/i_compuesto/services/calcularMontoFuturo.dart';

class Montofuturo extends StatefulWidget {
  const Montofuturo({super.key});

  @override
  State<Montofuturo> createState() => _MontofuturoState();
}

class _MontofuturoState extends State<Montofuturo> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _capitalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  double? _futureAmount;
  bool _knowsExactDates = true;
  String frecuenciaSeleccionada = 'Anual';
  String _selectedView = 'Normal'; // Agregar esta línea
  final Map<String, int> opcionesFrecuencia = {
    'Anual': 1,
    'Semestral': 2,
    'Cuatrimestral': 3,
    'Trimestral': 4,
    'Bimestral': 6,
    'Mensual': 12,
  };

  final MontofuturoCalcular _calculator = MontofuturoCalcular();

  void _calculateFutureAmount() {
    if (_formKey.currentState!.validate()) {
      final double capital = double.parse(_capitalController.text);
      final double rate = double.parse(_rateController.text);
      DateTime startDate;
      DateTime endDate;
      final int veces = opcionesFrecuencia[frecuenciaSeleccionada]!;

      if (_knowsExactDates) {
        startDate = _calculator.parseDate(_startDateController.text);
        endDate = _calculator.parseDate(_endDateController.text);
      } else {
        final int days = int.tryParse(_daysController.text) ?? 0;
        final int months = int.tryParse(_monthsController.text) ?? 0;
        final int years = int.tryParse(_yearsController.text) ?? 0;
        startDate = DateTime.now();
        endDate = startDate.add(
          Duration(days: days + months * 30 + years * 365),
        );
      }

      setState(() {
        _futureAmount = _calculator.calculateFutureAmount(
          capital: capital,
          rate: rate / 100,
          startDate: startDate,
          endDate: endDate,
          vecesporano: veces,
        );
      });

      // Mostrar el resultado en un diálogo
      _showResultDialog();
    }
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
        controller.text = _calculator.formatDate(picked);
      });
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                    const SizedBox(height: 8),
                    const Text(
                      'Monto Futuro:',
                      style: TextStyle(fontSize: 16, color: Color(0xFF0A4D68)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatAmountResult(_futureAmount!),
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
              const SizedBox(height: 16),
              const Text(
                'El monto futuro calculado se muestra arriba.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cerrar',
                style: TextStyle(color: Color(0xFF088395)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Clear form
                _capitalController.clear();
                _rateController.clear();
                _startDateController.clear();
                _endDateController.clear();
                _daysController.clear();
                _monthsController.clear();
                _yearsController.clear();
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
        );
      },
    );
  }

  // Método para formatear el monto según el formato seleccionado
  String _formatAmountResult(double amount) {
    switch (_selectedView) {
      case 'Entero':
        return _calculator.formatNumber(amount.round().toDouble());
      case 'Un decimal':
        return _calculator.formatNumber(
          double.parse(amount.toStringAsFixed(1)),
        );
      case 'Dos decimales':
        return _calculator.formatNumber(
          double.parse(amount.toStringAsFixed(2)),
        );
      default:
        return _calculator.formatNumber(amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cálculo del Monto Futuro",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0A4D68),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A4D68), Color(0xFF088395)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Campo de Capital Inicial
                _buildTextField(
                  _capitalController,
                  "Capital Inicial",
                  Icons.account_balance_wallet,
                ),
                const SizedBox(height: 20),

                // Selector de Frecuencia
                _buildFrequencyDropdown(),
                const SizedBox(height: 20),

                // Campo de Tasa de Interés
                _buildTextField(
                  _rateController,
                  "Tasa de Interés (%)",
                  Icons.percent,
                ),
                const SizedBox(height: 20),

                // Switch para Fechas Exactas
                _buildDateSwitch(),
                const SizedBox(height: 20),

                // Campos de Fechas o Período
                if (_knowsExactDates) ...[
                  _buildDateField(
                    _startDateController,
                    "Fecha de Inicio",
                    Icons.calendar_today,
                  ),
                  const SizedBox(height: 20),
                  _buildDateField(
                    _endDateController,
                    "Fecha de Finalización",
                    Icons.calendar_today,
                  ),
                ] else ...[
                  _buildSmallTextField(_daysController, "Días", Icons.today),
                  const SizedBox(height: 20),
                  _buildSmallTextField(
                    _monthsController,
                    "Meses",
                    Icons.date_range,
                  ),
                  const SizedBox(height: 20),
                  _buildSmallTextField(
                    _yearsController,
                    "Años",
                    Icons.calendar_view_month,
                  ),
                ],
                const SizedBox(height: 20),

                // Formato del resultado (añadir esta sección)
                const Text(
                  'Formato del resultado',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                _buildDropdown(),
                const SizedBox(height: 30),

                // Botón de Calcular
                _buildCalculateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Agregar este método para el dropdown de formatos
  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withOpacity(0.1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedView,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
          dropdownColor: const Color(0xFF088395),
          onChanged: (String? newValue) {
            setState(() {
              _selectedView = newValue!;
            });
          },
          items: const [
            DropdownMenuItem(
              value: 'Normal',
              child: Text(
                'Formato normal',
                style: TextStyle(color: Colors.white),
              ),
            ),
            DropdownMenuItem(
              value: 'Entero',
              child: Text(
                'Sin decimales',
                style: TextStyle(color: Colors.white),
              ),
            ),
            DropdownMenuItem(
              value: 'Un decimal',
              child: Text('Un decimal', style: TextStyle(color: Colors.white)),
            ),
            DropdownMenuItem(
              value: 'Dos decimales',
              child: Text(
                'Dos decimales',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para construir un campo de texto
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white70),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese $label';
        }
        return null;
      },
    );
  }

  // Widget para construir el selector de frecuencia
  Widget _buildFrequencyDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white70),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: frecuenciaSeleccionada,
          onChanged: (String? nuevoValor) {
            setState(() {
              frecuenciaSeleccionada = nuevoValor!;
            });
          },
          items:
              opcionesFrecuencia.keys.map<DropdownMenuItem<String>>((
                String valor,
              ) {
                return DropdownMenuItem<String>(
                  value: valor,
                  child: Text(
                    valor,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
          dropdownColor: const Color(0xFF088395),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // Widget para construir el switch de fechas exactas
  Widget _buildDateSwitch() {
    return SwitchListTile(
      title: const Text(
        "¿Conoce las fechas exactas del crédito?",
        style: TextStyle(color: Colors.white),
      ),
      value: _knowsExactDates,
      onChanged: (bool value) {
        setState(() {
          _knowsExactDates = value;
        });
      },
      activeColor: const Color(0xFF05BFDB),
      inactiveTrackColor: Colors.white70,
    );
  }

  // Widget para construir un campo de fecha
  Widget _buildDateField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFF088395)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today, color: Color(0xFF088395)),
            onPressed: () => _selectDate(context, controller),
          ),
        ),
      ),
    );
  }

  // Widget para construir un campo de texto pequeño
  Widget _buildSmallTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white70),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  // Widget para construir el botón de calcular
  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _calculateFutureAmount,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20),
          backgroundColor: const Color(0xFF05BFDB),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          "Calcular Monto Futuro",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
