import 'package:intl/intl.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwfielddisplayformat/vwfielddisplayformat.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class DisplayFormatUtil {
  static String? renderDisplayFormat(
      VwFieldDisplayFormat fieldDisplayFormat, VwFieldValue fieldValue, String locale) {
    String? returnValue;

    try {
      /*
      if (fieldDisplayFormat.fieldFormat == VwFieldDisplayFormat.vsfDateOnly) {
        try {
          if (fieldValue.valueDateTime == null) {
            fieldValue.valueDateTime = DateTime.parse(fieldValue.valueString!);
            fieldValue.valueTypeId == VwFieldValue.vatDateTime;
          }
        } catch (error) {}
      }*/

      if (fieldValue.valueTypeId == VwFieldValue.vatString) {
        returnValue = fieldValue.valueString;
      }

      if (fieldValue.valueTypeId == VwFieldValue.vatNumber) {
        returnValue = fieldValue.valueNumber.toString();
      } else if (fieldValue.valueTypeId == VwFieldValue.vatDateTime) {
        if (fieldValue.valueDateTime != null) {
          returnValue = DateFormat("dd-MMM-yyyy Hm", locale)
              .format(fieldValue.valueDateTime!);
        }
      } else if (fieldValue.valueTypeId == VwFieldValue.vatDateOnly) {
        if (fieldValue.valueDateTime != null) {
          returnValue = DateFormat("dd-MMM-yyyy", locale)
              .format(fieldValue.valueDateTime!);
        }
      } else if (fieldValue.valueTypeId == VwFieldValue.vatTimeOnly) {
        if (fieldValue.valueDateTime != null) {
          returnValue = DateFormat("Hm", locale)
              .format(fieldValue.valueDateTime!);
        }
      }

      if (fieldDisplayFormat.fieldFormat == VwFieldDisplayFormat.vsfNumeric ||
          fieldDisplayFormat.fieldFormat ==
              VwFieldDisplayFormat.vsfAccounting ||
          fieldDisplayFormat.fieldFormat == VwFieldDisplayFormat.vsfCurrency) {
        if (fieldValue.valueTypeId == VwFieldValue.vatString &&
            fieldValue.valueString != null) {
          try {
            fieldValue.valueNumber = double.parse(fieldValue.valueString!);
          } catch (error) {}
        }

        if (fieldDisplayFormat.fieldFormat == VwFieldDisplayFormat.vsfNumeric) {
          if (fieldValue.valueNumber != null) {
            returnValue = NumberFormat.decimalPatternDigits(
                    locale: fieldDisplayFormat.locale,
                    decimalDigits: fieldDisplayFormat
                        .numberTextInputFormatter!.decimalDigits)
                .format(fieldValue.valueNumber);
          }
        } else if (fieldDisplayFormat.fieldFormat ==
            VwFieldDisplayFormat.vsfCurrency) {
          if (fieldValue.valueNumber != null) {
            if (fieldDisplayFormat.locale == "id_ID") {
              returnValue = NumberFormat.currency(
                locale: fieldDisplayFormat.locale,
                symbol: 'Rp',
              ).format(fieldValue.valueNumber);
            } else {
              returnValue =
                  NumberFormat.currency(locale: fieldDisplayFormat.locale)
                      .format(fieldValue.valueNumber);
            }
          }
        }
      } else if (fieldValue.valueDateTime != null &&
          (fieldDisplayFormat.fieldFormat == VwFieldDisplayFormat.vsfDateOnly ||
              fieldDisplayFormat.fieldFormat ==
                  VwFieldDisplayFormat.vsfTimeOnly ||
              fieldDisplayFormat.fieldFormat ==
                  VwFieldDisplayFormat.vsfDateTime) &&
          fieldDisplayFormat.useCustomDateFormat == true) {
        returnValue = DateFormat(
                fieldDisplayFormat.customDateFormat, fieldDisplayFormat.locale)
            .format(fieldValue.valueDateTime!);
      } else if (fieldValue.valueDateTime != null &&
          fieldDisplayFormat.fieldFormat == VwFieldDisplayFormat.vsfDateOnly) {
        returnValue = DateFormat("dd-MMM-yyyy", locale)
            .format(fieldValue.valueDateTime!);
      } else if (fieldValue.valueDateTime != null &&
          fieldDisplayFormat.fieldFormat == VwFieldDisplayFormat.vsfTimeOnly) {
        returnValue = DateFormat("HH:mm", locale)
            .format(fieldValue.valueDateTime!);
      } else if (fieldValue.valueDateTime != null &&
          fieldDisplayFormat.fieldFormat == VwFieldDisplayFormat.vsfDateTime) {
        returnValue =
            VwDateUtil.indonesianFormatLocalTimeZone(fieldValue.valueDateTime!);
      } else if (fieldValue.valueDateTime != null &&
          fieldDisplayFormat.fieldFormat ==
              VwFieldDisplayFormat.vsfShortDateTime) {
        returnValue = VwDateUtil.indonesianShortFormatLocalTimeZone(
            fieldValue.valueDateTime!);
      }
    } catch (error) {}

    return returnValue;
  }
}
