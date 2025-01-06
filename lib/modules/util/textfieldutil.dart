import 'package:matrixclient/modules/base/vwnumbertextinputformatter/vwnumbertextinputformatter.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';

class TextFieldUtil{


  static NumberTextInputFormatter createNumberTextInputFormatter(VwNumberTextInputFormatter numberTextInputFormatter){
    return NumberTextInputFormatter (
      integerDigits: numberTextInputFormatter!.integerDigits,
      decimalDigits: numberTextInputFormatter!.decimalDigits,
      maxValue: numberTextInputFormatter!.maxValue,
      //maxValue:"100000000000000",
      decimalSeparator:numberTextInputFormatter!.decimalSeparator!,
      groupDigits: numberTextInputFormatter!.groupDigits,
      groupSeparator: numberTextInputFormatter!.groupSeparator!,
      allowNegative: numberTextInputFormatter!.allowNegative!,
      overrideDecimalPoint: numberTextInputFormatter!.overrideDecimalPoint!,
      insertDecimalPoint: numberTextInputFormatter!.insertDecimalPoint!,
      insertDecimalDigits: numberTextInputFormatter!.insertDecimalDigits!,
    );
  }
}