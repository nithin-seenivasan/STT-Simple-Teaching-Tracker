//Small extension to restrict the precision of double to a set number
extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

bool isNumeric(String str) {
  if (str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}
