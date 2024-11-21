import 'package:flutter/material.dart';

class PriceEstimatorPage extends StatefulWidget {
  @override
  _PriceEstimatorPageState createState() => _PriceEstimatorPageState();
}

class _PriceEstimatorPageState extends State<PriceEstimatorPage> {
  String? selectedProductType;
  String? selectedPackageSubtype;
  String? originCity;
  String? destinationCity;
  double? weight;
  double? length;
  double? height;
  double? width;
  int? quantity = 1;
  double? quotationInBolivianos;

  final List<String> boliviaDepartments = [
    'La Paz',
    'Cochabamba',
    'Santa Cruz',
    'Oruro',
    'Potosí',
    'Chuquisaca',
    'Tarija',
    'Beni',
    'Pando',
  ];

  final List<String> packageSubtypes = [
    'Frágil',
    'Electrodomésticos',
    'Ropa',
    'Alimentos',
    'Artículos de oficina',
    'Herramientas',
    'Tecnología',
    'Muebles',
    'Otros',
  ];

  double calculateQuotationInBolivianos() {
    double baseRate = selectedProductType == 'documentos' ? 20.0 : 40.0;
    double weightRate = weight != null ? weight! * 2.5 : 0;
    double volumeRate = 0;

    if (selectedProductType == 'paquete' &&
        length != null &&
        height != null &&
        width != null) {
      double volume = (length! * height! * width!) / 5000;
      volumeRate = volume * 4.0;
    }

    double quantityRate = (quantity ?? 1) * 3.0;

    return baseRate + weightRate + volumeRate + quantityRate;
  }

  void calculateQuotation() {
    if (_validateFields()) {
      setState(() {
        quotationInBolivianos = calculateQuotationInBolivianos();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Por favor, complete todos los campos requeridos.'),
      ));
    }
  }

  bool _validateFields() {
    if (selectedProductType == null ||
        originCity == null ||
        destinationCity == null ||
        weight == null ||
        quantity == null ||
        (selectedProductType == 'paquete' &&
            (length == null || height == null || width == null)) ||
        (selectedProductType == 'paquete' && selectedPackageSubtype == null)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF3E3),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E3B4E),
        title: Text(
          'Cotización de Envío',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 6.0,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tipo de Producto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D405B),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        _buildOptionButton('Paquete', selectedProductType),
                        SizedBox(width: 8.0),
                        _buildOptionButton('Documentos', selectedProductType),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (selectedProductType == 'paquete')
              _buildDropdownCard('Tipo de Paquete', packageSubtypes,
                  selectedPackageSubtype, (value) {
                setState(() {
                  selectedPackageSubtype = value;
                });
              }),
            _buildDropdownCard('Ciudad de Origen', boliviaDepartments,
                originCity, (value) {
              if (value != destinationCity) {
                setState(() {
                  originCity = value;
                });
              } else {
                _showErrorMessage('La ciudad de origen y destino deben ser diferentes.');
              }
            }),
            _buildDropdownCard('Ciudad de Destino', boliviaDepartments,
                destinationCity, (value) {
              if (value != originCity) {
                setState(() {
                  destinationCity = value;
                });
              } else {
                _showErrorMessage('La ciudad de origen y destino deben ser diferentes.');
              }
            }),
            if (selectedProductType == 'paquete') _buildDimensionsInputs(),
            _buildWeightInput(),
            _buildQuantityInput(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: calculateQuotation,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                  backgroundColor: Color(0xFF3D405B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  'Cotizar envío',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (quotationInBolivianos != null) _buildQuotationResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String label, String? currentSelection) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedProductType = label.toLowerCase();
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: currentSelection == label.toLowerCase()
                ? Color(0xFF3D405B)
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.all(12.0),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: currentSelection == label.toLowerCase()
                    ? Colors.white
                    : Color(0xFF3D405B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownCard(String label, List<String> items, String? value,
      ValueChanged<String?> onChanged) {
    return Card(
      elevation: 6.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: label),
          value: value,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDimensionsInputs() {
    return Card(
      elevation: 6.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Largo (cm)'),
              keyboardType: TextInputType.number,
              onChanged: (value) => length = double.tryParse(value),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Alto (cm)'),
              keyboardType: TextInputType.number,
              onChanged: (value) => height = double.tryParse(value),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Ancho (cm)'),
              keyboardType: TextInputType.number,
              onChanged: (value) => width = double.tryParse(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightInput() {
    return TextField(
      decoration: InputDecoration(labelText: 'Peso (kg)'),
      keyboardType: TextInputType.number,
      onChanged: (value) => weight = double.tryParse(value),
    );
  }

  Widget _buildQuantityInput() {
    return TextField(
      decoration: InputDecoration(labelText: 'Cantidad'),
      keyboardType: TextInputType.number,
      onChanged: (value) => quantity = int.tryParse(value),
    );
  }

  Widget _buildQuotationResult() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Cotización Estimada',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3D405B),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '${quotationInBolivianos!.toStringAsFixed(2)} Bs',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3D405B),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
