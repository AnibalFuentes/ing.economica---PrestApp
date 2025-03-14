import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:prestapp/screens/i_compuesto/services/calcularTasaInteres.dart';

class TasaInteres extends StatefulWidget {
  const TasaInteres({super.key});

  @override
  State<TasaInteres> createState() => _TasaInteresState();
}

class _TasaInteresState extends State<TasaInteres> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _montoFuturoController = TextEditingController();
  final TextEditingController _capitalController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  double? _futureAmount;
  bool _knowsExactDates = true;
  String frecuenciaSeleccionada = 'Anual';
  final Map<String, int> opcionesFrecuencia = {
    'Anual': 1,
    'Semestral': 2,
    'Cuatrimestral': 3,
    'Trimestral': 4,
    'Bimestral': 6,
    'Mensual': 12,
  };

  final InterestCalculator _calculator = InterestCalculator();
  bool _isCalculating = false;

  void _calculateFutureAmount() {
    // First check if form is valid
    if (_formKey.currentState!.validate()) {
      try {
        final double capital = double.parse(_capitalController.text);
        final double montofuturo = double.parse(_montoFuturoController.text);
        DateTime startDate;
        DateTime endDate;
        final int veces = opcionesFrecuencia[frecuenciaSeleccionada]!;

        setState(() {
          _isCalculating = true;
        });

        Future.delayed(const Duration(milliseconds: 500), () {
          try {
            // Calculate dates
            if (_knowsExactDates) {
              // Make sure dates are provided
              if (_startDateController.text.isEmpty ||
                  _endDateController.text.isEmpty) {
                _showSnackBar("Por favor, ingresa ambas fechas.");
                setState(() {
                  _isCalculating = false;
                });
                return;
              }
              startDate = _calculator.parseDate(_startDateController.text);
              endDate = _calculator.parseDate(_endDateController.text);
            } else {
              // Check if at least one time field is provided
              if ((_daysController.text.isEmpty ||
                      int.tryParse(_daysController.text) == 0) &&
                  (_monthsController.text.isEmpty ||
                      int.tryParse(_monthsController.text) == 0) &&
                  (_yearsController.text.isEmpty ||
                      int.tryParse(_yearsController.text) == 0)) {
                _showSnackBar(
                  "Por favor, ingresa al menos un valor de tiempo.",
                );
                setState(() {
                  _isCalculating = false;
                });
                return;
              }

              final int days = int.tryParse(_daysController.text) ?? 0;
              final int months = int.tryParse(_monthsController.text) ?? 0;
              final int years = int.tryParse(_yearsController.text) ?? 0;
              startDate = DateTime.now();
              endDate = startDate.add(
                Duration(days: days + months * 30 + years * 365),
              );
            }

            // Verify endDate is after startDate
            if (endDate.isBefore(startDate)) {
              _showSnackBar(
                "La fecha final debe ser posterior a la fecha inicial.",
              );
              setState(() {
                _isCalculating = false;
              });
              return;
            }

            final double tasa = _calculator.calculateTasaInteres(
              capital: capital,
              startDate: startDate,
              endDate: endDate,
              vecesporano: veces,
              montofuturo: montofuturo,
            );

            setState(() {
              _futureAmount = tasa;
              _isCalculating = false;
            });

            // Explicitly check for valid calculation result
            if (_futureAmount != null &&
                !_futureAmount!.isNaN &&
                !_futureAmount!.isInfinite) {
              // Debug print
              print("Mostrando diálogo con valor: $_futureAmount");
              _showResultDialog(_futureAmount!);
            } else {
              print("Error: _futureAmount es nulo o no válido: $_futureAmount");
              _showSnackBar(
                "Error en el cálculo. Verifica los datos ingresados.",
              );
            }
          } catch (e) {
            print("Error en el cálculo: $e");
            setState(() {
              _isCalculating = false;
            });
            _showSnackBar("Error: $e");
          }
        });
      } catch (e) {
        print("Error parseando valores: $e");
        setState(() {
          _isCalculating = false;
        });
        _showSnackBar("Error en los datos ingresados: $e");
      }
    } else {
      print("Validación del formulario falló");
      _showSnackBar("Por favor, completa todos los campos correctamente.");
    }
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
        controller.text = "${picked.toLocal()}".split(' ')[0];
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
          child: Form(
            key: _formKey,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                            _capitalController,
                            'Capital Inicial (P)',
                            Icons.account_balance_wallet,
                          ),
                        ),

                        SizedBox(height: 16),

                        FadeInUp(
                          delay: Duration(milliseconds: 300),
                          child: _buildTextField(
                            _montoFuturoController,
                            'Monto Futuro (S)',
                            Icons.monetization_on,
                          ),
                        ),

                        SizedBox(height: 24),

                        // Selector de frecuencia
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
                                      Icons.calendar_today,
                                      color: Color(0xFF0A4D68),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Frecuencia de capitalización",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0A4D68),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 12),
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
                                          opcionesFrecuencia.keys
                                              .map<DropdownMenuItem<String>>((
                                                String valor,
                                              ) {
                                                return DropdownMenuItem<String>(
                                                  value: valor,
                                                  child: Text(valor),
                                                );
                                              })
                                              .toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 24),

                        // Selector de método de tiempo
                        FadeInUp(
                          delay: Duration(milliseconds: 500),
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
                                            _knowsExactDates = false;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                !_knowsExactDates
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
                                                    !_knowsExactDates
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
                                            _knowsExactDates = true;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                _knowsExactDates
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
                                                    _knowsExactDates
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
                                if (_knowsExactDates)
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
                                              _daysController,
                                              'Días',
                                              Icons.today,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: _buildSmallTextField(
                                              _monthsController,
                                              'Meses',
                                              Icons.date_range,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: _buildSmallTextField(
                                              _yearsController,
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
                          delay: Duration(milliseconds: 600),
                          child: ElevatedButton(
                            onPressed:
                                _isCalculating ? null : _calculateFutureAmount,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                          delay: Duration(milliseconds: 700),
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
                                    "r = (S / P - 1) / t",
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
                                  "Donde r = tasa de interés, S = monto futuro, P = capital inicial, t = tiempo en años",
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
