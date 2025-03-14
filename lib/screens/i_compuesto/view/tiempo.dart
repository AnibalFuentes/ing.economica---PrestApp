import 'package:flutter/material.dart';
import 'package:prestapp/screens/i_compuesto/services/calcularTiempo.dart';
import 'package:animate_do/animate_do.dart';

class Tiempo extends StatefulWidget {
  const Tiempo({super.key});

  @override
  State<Tiempo> createState() => _Tiempo();
}

class _Tiempo extends State<Tiempo> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _montoFuturoController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _capitalController = TextEditingController();
  double? _futureAmount;
  String frecuenciaSeleccionada = 'Anual';
  final Map<String, int> opcionesFrecuencia = {
    'Anual': 1,
    'Semestral': 2,
    'Cuatrimestral': 3,
    'Trimestral': 4,
    'Bimestral': 6,
    'Mensual': 12,
  };

  final TiempoCalculator _calculator = TiempoCalculator();

  void _calculateFutureAmount() {
    if (_formKey.currentState!.validate()) {
      final double capital = double.parse(_capitalController.text);
      final double montofuturo = double.parse(_montoFuturoController.text);
      final double rate = double.parse(_rateController.text);
      final int veces = opcionesFrecuencia[frecuenciaSeleccionada]!;

      setState(() {
        _futureAmount = _calculator.calculateTiempo(
          capital: capital,
          interes: rate / 100,
          vecesporano: veces,
          montofuturo: montofuturo,
        );
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
                      'Calcular Tiempo Compuesto',
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
                            Text(
                              'Ingresa los datos',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A4D68),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Completa todos los campos para calcular',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildInputField(
                              controller: _capitalController,
                              label: "Capital Inicial",
                              icon: Icons.attach_money,
                            ),
                            const SizedBox(height: 16),
                            _buildInputField(
                              controller: _montoFuturoController,
                              label: "Monto Futuro",
                              icon: Icons.money,
                            ),
                            const SizedBox(height: 16),
                            _buildInputField(
                              controller: _rateController,
                              label: "Tasa de Interés (%)",
                              icon: Icons.percent,
                            ),
                            const SizedBox(height: 16),
                            _buildDropdown(),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _calculateFutureAmount,
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
                                  children: const [
                                    Icon(Icons.calculate_outlined),
                                    SizedBox(width: 8),
                                    Text(
                                      "Calcular Tiempo",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (_futureAmount != null)
                              FadeInUp(
                                duration: const Duration(milliseconds: 500),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF05BFDB,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "Tiempo necesario: ${_calculator.formatNumber(_futureAmount!)} años",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0A4D68),
                                    ),
                                    textAlign: TextAlign.center,
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
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
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese este campo';
          }
          return null;
        },
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
          value: frecuenciaSeleccionada,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF05BFDB)),
          onChanged: (String? newValue) {
            setState(() {
              frecuenciaSeleccionada = newValue!;
            });
          },
          items:
              opcionesFrecuencia.keys.map<DropdownMenuItem<String>>((
                String valor,
              ) {
                return DropdownMenuItem<String>(
                  value: valor,
                  child: Text(valor),
                );
              }).toList(),
        ),
      ),
    );
  }
}
