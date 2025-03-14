import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class InteresSimpleView extends StatelessWidget {
  const InteresSimpleView({super.key});

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
                          'Interés Simple',
                          style: TextStyle(
                            fontSize: 24,
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

              // Tarjeta de información
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FadeInDown(
                  delay: Duration(milliseconds: 300),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¿Qué deseas calcular?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A4D68),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Selecciona una opción para iniciar tu cálculo de interés simple',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Grid de opciones
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                    children: [
                      FadeInUp(
                        delay: Duration(milliseconds: 400),
                        child: _buildGridCard(
                          context,
                          icon: Icons.monetization_on,
                          label: "Monto Final",
                          description: "Calcula el capital más intereses",
                          route: "/is/form",
                          color: Color(0xFF05BFDB),
                        ),
                      ),
                      FadeInUp(
                        delay: Duration(milliseconds: 500),
                        child: _buildGridCard(
                          context,
                          icon: Icons.percent,
                          label: "Tasa de Interés",
                          description: "Calcula el porcentaje de interés",
                          route: "/is/interes",
                          color: Color(0xFF0E86D4),
                        ),
                      ),
                      FadeInUp(
                        delay: Duration(milliseconds: 600),
                        child: _buildGridCard(
                          context,
                          icon: Icons.access_time,
                          label: "Tiempo",
                          description: "Calcula el plazo necesario",
                          route: "/is/tiempo",
                          color: Color(0xFF0A4D68),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Fórmula del interés simple
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FadeInUp(
                  delay: Duration(milliseconds: 800),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Fórmula de Interés Simple',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A4D68),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'S = P(1 + rt)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'monospace',
                            color: Color(0xFF088395),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'S = Monto final, P = Capital inicial, r = Tasa de interés, t = Tiempo',
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required String route,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, route);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 32, color: color),
                ),
                SizedBox(height: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A4D68),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
