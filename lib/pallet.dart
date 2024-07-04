import 'package:apps/product.dart';

class Pallet {
  late double _weight;
  late double _profit;
  late double _volume;
  String name;
  List<Product> products;

  Pallet({
    required List<Product> products,
    required this.name
  }) : products = products {
    _calculateAttributes();
  }

  void _calculateAttributes() {
    _weight = _calculateWeight();
    _profit = _calculateProfit();
    _volume = _calculateVolume();
  }

  double get weight => _calculateWeight();

  double get profit => _calculateProfit();

  double get volume => _calculateVolume();

  double _calculateWeight() {
    double totalWeight = 0.0;
    for (Product product in products) {
      totalWeight += product.weight;
    }
    return totalWeight;
  }

  double _calculateProfit() {
    double totalProfit = 0.0;
    for (Product product in products) {
      totalProfit += product.profit;
    }
    return totalProfit;
  }

  double _calculateVolume() {
    double totalVolume = 0.0;
    for (Product product in products) {
      totalVolume += product.volume;
    }
    return totalVolume;
  }
}