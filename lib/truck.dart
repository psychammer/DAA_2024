import 'package:apps/pallet.dart';

class Truck {
  late double _weight;
  late double _profit;
  String name;
  List<Pallet> boxes;

  Truck({
    required List<Pallet> boxes,
    required this.name
  }): boxes = boxes {
  _calculateAttributes();
}

void _calculateAttributes() {
  _weight = _calculateWeight();
  _profit = _calculateProfit();
}

double get weight => _calculateWeight();

double get profit => _calculateProfit();

double _calculateWeight() {
  double totalWeight = 0.0;
  for (Pallet box in boxes) {
    totalWeight += box.weight;
  }
  return totalWeight;
}

double _calculateProfit() {
  double totalProfit = 0.0;
  for (Pallet box in boxes) {
    totalProfit += box.profit;
  }
  return totalProfit;
}


}