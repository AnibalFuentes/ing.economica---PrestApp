import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';

class SimpleInteres extends StatefulWidget {
  const SimpleInteres({super.key});

  @override
  _SimpleInteresState createState() => _SimpleInteresState();
}

class _SimpleInteresState extends State<SimpleInteres> {
  final _futureAmountController = TextEditingController();
  final _initialCapitalController = TextEditingController();
  final _interesGeneradoController = TextEditingController();
  final _timeController = TextEditingController();

  // Controllers para las fechas exactas
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  // Controllers para día, mes, y año
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  double? _interestRate;
  bool _useExactDates = false; // Para alternar entre fechas exactas o manual
  bool _isCalculating = false;

  // Update this in your _calculateInterestRate() method
  void _calculateInterestRate() {
    // Parse input values
    final initialCapital = double.tryParse(_initialCapitalController.text);
    final interesGenerado = double.tryParse(_interesGeneradoController.text);

    setState(() {
      _isCalculating = true;
    });

    // Simulate calculation time
    Future.delayed(const Duration(milliseconds: 500), () {
      if (initialCapital == null || initialCapital <= 0) {
        setState(() {
          _interestRate = null;
          _isCalculating = false;
        });
        _showSnackBar('Error: El capital inicial debe ser mayor a 0');
        return;
      }

      if (interesGenerado == null || interesGenerado < 0) {
        setState(() {
          _interestRate = null;
          _isCalculating = false;
        });
        _showSnackBar('Error: El interés generado debe ser un valor válido');
        return;
      }

      double? timeInYears;

      if (_useExactDates) {
        final startDate = DateTime.tryParse(_startDateController.text);
        final endDate = DateTime.tryParse(_endDateController.text);

        if (startDate == null || endDate == null) {
          setState(() {
            _interestRate = null;
            _isCalculating = false;
          });
          _showSnackBar('Error: Por favor ingrese fechas válidas');
          return;
        }

        if (endDate.isBefore(startDate)) {
          setState(() {
            _interestRate = null;
            _isCalculating = false;
          });
          _showSnackBar(
            'Error: La fecha final debe ser posterior a la inicial',
          );
          return;
        }

        final difference = endDate.difference(startDate).inDays;
        timeInYears = difference / 365.0;
      } else {
        final days = int.tryParse(_dayController.text) ?? 0;
        final months = int.tryParse(_monthController.text) ?? 0;
        final years = int.tryParse(_yearController.text) ?? 0;

        if (days == 0 && months == 0 && years == 0) {
          setState(() {
            _interestRate = null;
            _isCalculating = false;
          });
          _showSnackBar('Error: Por favor ingrese un período de tiempo válido');
          return;
        }

        timeInYears =
            years +
            (months / 12) +
            (days / 365); // Changed from 360 to 365 for consistency
      }

      // Final calculation
      if (timeInYears > 0) {
        final rate = (interesGenerado / (initialCapital * timeInYears)) * 100;
        setState(() {
          _interestRate = rate;
          _isCalculating = false;
        });
        _showResultDialog(rate);
      } else {
        setState(() {
          _interestRate = null;
          _isCalculating = false;
        });
        _showSnackBar('Error: El período de tiempo debe ser mayor a 0');
      }
    });
  }

  void _showResultDialog(double rate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
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
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF05BFDB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Tasa de Interés Anual',
                      style: TextStyle(fontSize: 16, color: Color(0xFF088395)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${rate.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A4D68),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'La tasa de interés anual calculada para los valores proporcionados es ${rate.toStringAsFixed(2)}%',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar', style: TextStyle(color: Color(0xFF088395))),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: Color(0xFF0A4D68),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            colorScheme: ColorScheme.light(
              primary: Color(0xFF0A4D68),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFF0A4D68)),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text =
            "${picked.toLocal()}".split(' ')[0]; // Formatear la fecha
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A4D68), Color(0xFF088395)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header con título y botón de retorno
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: FadeIn(
                        duration: Duration(milliseconds: 600),
                        child: Text(
                          'Calculadora de Tasa de Interés',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(width: 48), // Para equilibrar el diseño
                  ],
                ),
              ),

              // Contenido principal
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    children: [
                      // Tarjeta de instrucciones
                      FadeInDown(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xFF05BFDB).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.info_outline,
                                  color: Color(0xFF05BFDB),
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Cálculo de la Tasa de Interés",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0A4D68),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Completa los campos para calcular la tasa de interés anual",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Campos de entrada
                      FadeInUp(
                        delay: Duration(milliseconds: 200),
                        child: _buildTextField(
                          _initialCapitalController,
                          'Capital Inicial (P)',
                          Icons.account_balance_wallet,
                        ),
                      ),

                      SizedBox(height: 16),

                      FadeInUp(
                        delay: Duration(milliseconds: 300),
                        child: _buildTextField(
                          _interesGeneradoController,
                          'Interés Generado (I)',
                          Icons.monetization_on,
                        ),
                      ),

                      SizedBox(height: 24),

                      // Selector de método de tiempo
                      FadeInUp(
                        delay: Duration(milliseconds: 400),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: Color(0xFF0A4D68),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Método de cálculo del tiempo",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0A4D68),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _useExactDates = false;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              !_useExactDates
                                                  ? Color(0xFF05BFDB)
                                                  : Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Período",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  !_useExactDates
                                                      ? Colors.white
                                                      : Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _useExactDates = true;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              _useExactDates
                                                  ? Color(0xFF05BFDB)
                                                  : Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Fechas Exactas",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  _useExactDates
                                                      ? Colors.white
                                                      : Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              if (_useExactDates)
                                Column(
                                  children: [
                                    _buildDateField(
                                      _startDateController,
                                      "Fecha de Inicio",
                                      Icons.calendar_today,
                                    ),
                                    SizedBox(height: 16),
                                    _buildDateField(
                                      _endDateController,
                                      "Fecha de Fin",
                                      Icons.calendar_today,
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildSmallTextField(
                                            _dayController,
                                            'Días',
                                            Icons.today,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: _buildSmallTextField(
                                            _monthController,
                                            'Meses',
                                            Icons.date_range,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: _buildSmallTextField(
                                            _yearController,
                                            'Años',
                                            Icons.calendar_view_month,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      // Botón de calcular
                      FadeInUp(
                        delay: Duration(milliseconds: 500),
                        child: ElevatedButton(
                          onPressed:
                              _isCalculating ? null : _calculateInterestRate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF05BFDB),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child:
                              _isCalculating
                                  ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        "Calculando...",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                  : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.calculate, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        "CALCULAR TASA DE INTERÉS",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Fórmula
                      FadeInUp(
                        delay: Duration(milliseconds: 600),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.functions,
                                    color: Color(0xFF0A4D68),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Fórmula utilizada",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0A4D68),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFF0A4D68).withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "r = I / (P × t) × 100",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'monospace',
                                    color: Color(0xFF088395),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Donde r = tasa de interés, I = interés generado, P = capital inicial, t = tiempo en años",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
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
    );
  }

  Widget _buildTextField(
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
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFF088395)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
      ),
    );
  }

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

  Widget _buildSmallTextField(
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
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFF088395)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }
}
