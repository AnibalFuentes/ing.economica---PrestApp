import 'package:flutter/material.dart';
import 'package:prestapp/screens/i_simple/services/interes_calculator.dart';
import 'package:animate_do/animate_do.dart';

class SimpleTiempo extends StatefulWidget {
  const SimpleTiempo({super.key});

  @override
  _SimpleTiempoState createState() => _SimpleTiempoState();
}

class _SimpleTiempoState extends State<SimpleTiempo> {
  final _interesPagadoController = TextEditingController();
  final _initialCapitalController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _finalCapitalController = TextEditingController();
  double? _time;
  String _selectedView = 'Todos';

  final InterestCalculator _calculator = InterestCalculator();

  void _calculateTime() {
    final interesPagado = double.tryParse(_interesPagadoController.text);
    final initialCapital = double.tryParse(_initialCapitalController.text);
    final finalCapital = double.tryParse(_finalCapitalController.text);
    final interestRate = double.tryParse(_interestRateController.text);

    double? calculatedInterest;

    if (interesPagado == null &&
        finalCapital != null &&
        initialCapital != null) {
      calculatedInterest = finalCapital - initialCapital;
    } else {
      calculatedInterest = interesPagado;
    }

    if (calculatedInterest != null &&
        initialCapital != null &&
        interestRate != null &&
        interestRate != 0) {
      final time = _calculator.calculateTime(
        calculatedInterest,
        initialCapital,
        interestRate,
      );
      setState(() {
        _time = time;
      });
      _showResultDialog(_buildTimeMessage(time));
    } else {
      setState(() {
        _time = null;
      });
      _showSnackBar('Error: Verifica los datos ingresados');
    }
  }

  Map<String, int> _convertTime(double timeInYears) {
    int years = timeInYears.floor();
    double remainingYears = timeInYears - years;

    int totalMonths = (timeInYears * 12).floor();
    int months = (remainingYears * 12).floor();
    double remainingMonths = (remainingYears * 12) - months;

    int totalDays = (timeInYears * 365).floor();
    int days = (remainingMonths * 30).floor();

    return {
      'years': years,
      'months': months,
      'totalMonths': totalMonths,
      'days': days,
      'totalDays': totalDays,
    };
  }

  String _buildTimeMessage(double timeInYears) {
    final timeComponents = _convertTime(timeInYears);

    switch (_selectedView) {
      case 'Años':
        return '${timeComponents['years']} años';
      case 'Meses':
        return '${timeComponents['totalMonths']} meses';
      case 'Días':
        return '${timeComponents['totalDays']} días';
      default:
        return '${timeComponents['years']} años, ${timeComponents['months']} meses, ${timeComponents['days']} días';
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xFF088395),
      ),
    );
  }

  void _showResultDialog(String message) {
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
                  'El tiempo calculado es:',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF05BFDB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A4D68),
                    ),
                    textAlign: TextAlign.center,
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
                  // Clear form
                  _interesPagadoController.clear();
                  _initialCapitalController.clear();
                  _interestRateController.clear();
                  _finalCapitalController.clear();
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
                      'Calcular Tiempo',
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ingresa los datos',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A4D68),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Completa al menos tres campos para calcular',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 24),
                          _buildInputField(
                            controller: _interesPagadoController,
                            label: "Interés Pagado",
                            icon: Icons.money_off,
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            controller: _initialCapitalController,
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
                            controller: _interestRateController,
                            label: "Tasa de Interés (%)",
                            icon: Icons.percent,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Formato del resultado',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A4D68),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildDropdown(),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _calculateTime,
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
                        ],
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
          value: _selectedView,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF05BFDB)),
          onChanged: (String? newValue) {
            setState(() {
              _selectedView = newValue!;
            });
          },
          items: const [
            DropdownMenuItem(value: 'Todos', child: Text('Todos los formatos')),
            DropdownMenuItem(value: 'Años', child: Text('Solo años')),
            DropdownMenuItem(value: 'Meses', child: Text('Solo meses')),
            DropdownMenuItem(value: 'Días', child: Text('Solo días')),
          ],
        ),
      ),
    );
  }
}
