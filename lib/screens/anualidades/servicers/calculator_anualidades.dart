import 'dart:math';

class AnualidadCalculator {
  // Valor Futuro de una Anualidad (FVA)
  double calcularValorFuturo(
    double pagoPeriodico,
    double tasaInteres,
    int periodos,
  ) {
    if (tasaInteres <= 0)
      throw ArgumentError('La tasa de interés debe ser mayor que cero.');
    final tasa = tasaInteres / 100; // Convierte tasa del formato % a decimal
    return pagoPeriodico * ((pow(1 + tasa, periodos) - 1) / tasa);
  }

  // Valor Presente de una Anualidad (PVA)
  double calcularValorPresente(
    double pagoPeriodico,
    double tasaInteres,
    int periodos,
  ) {
    if (tasaInteres <= 0)
      throw ArgumentError('La tasa de interés debe ser mayor que cero.');
    final tasa = tasaInteres / 100;
    return pagoPeriodico * (1 - pow(1 + tasa, -periodos)) / tasa;
  }

  // Pago Periódico basado en el Valor Futuro
  double calcularPagoDesdeValorFuturo(
    double valorFuturo,
    double tasaInteres,
    int periodos,
  ) {
    if (tasaInteres <= 0)
      throw ArgumentError('La tasa de interés debe ser mayor que cero.');
    final tasa = tasaInteres / 100;
    return valorFuturo * (tasa / (pow(1 + tasa, periodos) - 1));
  }

  // Pago Periódico basado en el Valor Presente
  double calcularPagoDesdeValorPresente(
    double valorPresente,
    double tasaInteres,
    int periodos,
  ) {
    if (tasaInteres <= 0)
      throw ArgumentError('La tasa de interés debe ser mayor que cero.');
    final tasa = tasaInteres / 100;
    return valorPresente * (tasa / (1 - pow(1 + tasa, -periodos)));
  }
}

void main() {
  final calculator = AnualidadCalculator();

  // Ejemplo: Calcular el valor futuro de una anualidad
  double valorFuturo = calculator.calcularValorFuturo(100, 1, 12);
  print(
    'Valor Futuro de la Anualidad (12 pagos mensuales de \$100 al 1% mensual): \$${valorFuturo.toStringAsFixed(2)}',
  );

  // Ejemplo: Calcular el valor presente de una anualidad
  double valorPresente = calculator.calcularValorPresente(100, 1, 12);
  print(
    'Valor Presente de la Anualidad (12 pagos mensuales de \$100 al 1% mensual): \$${valorPresente.toStringAsFixed(2)}',
  );

  // Ejemplo: Calcular el pago periódico basado en el valor futuro
  double pagoFuturo = calculator.calcularPagoDesdeValorFuturo(
    valorFuturo,
    1,
    12,
  );
  print(
    'Pago Periódico (Valor Futuro de \$${valorFuturo.toStringAsFixed(2)}): \$${pagoFuturo.toStringAsFixed(2)}',
  );

  // Ejemplo: Calcular el pago periódico basado en el valor presente
  double pagoPresente = calculator.calcularPagoDesdeValorPresente(
    valorPresente,
    1,
    12,
  );
  print(
    'Pago Periódico (Valor Presente de \$${valorPresente.toStringAsFixed(2)}): \$${pagoPresente.toStringAsFixed(2)}',
  );
}
