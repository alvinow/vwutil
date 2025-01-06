class DoubleUtil{
  static double convertToDecimalDigit({required double inputValue,required int decimalDigit}){
    return  double.parse((inputValue).toStringAsFixed(2));
  }
}