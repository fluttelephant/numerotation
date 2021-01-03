/*
 * @author Neiba Aristide
 */
import 'package:flutter/material.dart';

class PhoneUtils {
  static List<dynamic> operatorsNumber = [
    {
      "operator": "Atlantique Telecom CI",
      "operatorAbrev": "Moov",
      "operator_color": Color(0xFFCCD344),
      "old_initial": [
        "01",
        "02",
        "03",
        "40",
        "41",
        "42",
        "43",
        "50",
        "51",
        "52",
        "53",
        "70",
        "71",
        "72",
        "73"
      ],
      "new_initial": "01",
      "type": "Téléphonie Mobile"
    },
    {
      "operator": "MTN-CI",
      "operatorAbrev": "MTN",
      "operator_color": Color(0xFFF6CA45),
      "old_initial": [
        "04",
        "05",
        "06",
        "44",
        "45",
        "46",
        "54",
        "55",
        "56",
        "64",
        "65",
        "66",
        "74",
        "75",
        "76",
        "84",
        "85",
        "86",
        "94",
        "95",
        "96"
      ],
      "new_initial": "05",
      "type": "Téléphonie Mobile"
    },
    {
      "operator": "ORANGE CI",
      "operatorAbrev": "ORANGE",
      "operator_color": Color(0xFFED6F2E),
      "old_initial": [
        "07",
        "08",
        "09",
        "47",
        "48",
        "49",
        "57",
        "58",
        "59",
        "67",
        "68",
        "69",
        "77",
        "78",
        "79",
        "87",
        "88",
        "89",
        "97",
        "98"
      ],
      "new_initial": "07",
      "type": "Téléphonie Mobile"
    },
    {
      "operator": "Atlantique Telecom",
      "operatorAbrev": "Moov",
      "operator_color": Color(0xFFCCD344),
      "old_initial": ["208", "218", "228", "238"],
      "new_initial": "21",
      "type": "Téléphonie Fixe"
    },
    {
      "operator": "MTN-CI",
      "operatorAbrev": "MTN",
      "operator_color": Color(0xFFF6CA45),
      "old_initial": [
        "200",
        "210",
        "220",
        "230",
        "240",
        "300",
        "310",
        "320",
        "330",
        "340",
        "350",
        "360",
      ],
      "new_initial": "25",
      "type": "Téléphonie Fixe"
    },
    {
      "operator": "ORANGE CI",
      "operatorAbrev": "ORANGE",
      "operator_color": Color(0xFFED6F2E),
      "old_initial": [
        "202",
        "203",
        "212",
        "213",
        "215",
        "217",
        "224",
        "225",
        "234",
        "235",
        "243",
        "244",
        "245",
        "306",
        "316",
        "319",
        "327",
        "337",
        "347",
        "359",
        "368",
      ],
      "new_initial": "27",
      "type": "Téléphonie Fixe"
    }
  ];

  static String normalizeNumber(String number) {
    String value = number.replaceAll(" ", "").trim();
    if (value.contains("+225") && value.indexOf("+225") == 0) {
      // delete +225
      value = value.substring(4);
    }
    if (value.contains("00225") && value.indexOf("00225") == 0) {
      // delete +225
      value = value.substring(5);
    }
    return value;
  }

  static String addIndicatifNumber(String number) {
    String value = number.replaceAll(" ", "").trim();
    if (value.contains("+225") && value.indexOf("+225") == 0) return value;
    if (value.contains("00225") && value.indexOf("00225") == 0) return value;
    return "+225" + value;
  }

  static bool validateNormalizeOldPhoneNumber(String phoneNumber) {
    return phoneNumber.length == 8;
  }

  static bool isIvorianPhone(String phoneNumber) {
    return isIvorianOldPhone(phoneNumber) || isIvorianNewPhone(phoneNumber);
  }

  static bool isIvorianOldPhone(String phoneNumber) {
    return (phoneNumber.length == 8 &&
            !phoneNumber.contains("+") &&
            !(phoneNumber.contains("00225") &&
                phoneNumber.indexOf("00225") == 0)) ||
        (phoneNumber.contains("+225") &&
            phoneNumber.replaceAll(" ", "").trim().length == 11 &&
            phoneNumber.indexOf("+225") == 0) ||
        (phoneNumber.contains("00225") &&
            phoneNumber.replaceAll(" ", "").trim().length == 12 &&
            phoneNumber.indexOf("00225") == 0) ||
        (phoneNumber.contains("+") &&
            phoneNumber.indexOf("+") == 0 &&
            phoneNumber.indexOf("+225") == 0);
  }

  static bool isIvorianNewPhone(String phoneNumber) {
    return (phoneNumber.length == 10 &&
            !phoneNumber.contains("+") &&
            !(phoneNumber.contains("00225") &&
                phoneNumber.indexOf("00225") == 0)) ||
        (phoneNumber.contains("+225") &&
            phoneNumber.replaceAll(" ", "").trim().length == 13 &&
            phoneNumber.indexOf("+225") == 0) ||
        (phoneNumber.contains("00225") &&
            phoneNumber.replaceAll(" ", "").trim().length == 14 &&
            phoneNumber.indexOf("00225") == 0) ;
  }

  static bool isNewPhone(String phoneNumber) {
    return phoneNumber.length == 10;
  }

  static dynamic determinateOperator(String phoneNumber) {
    if (phoneNumber.length < 8) return null;

    //check is mobile

    String initial = phoneNumber.substring(0, 2);

    List<dynamic> ops = operatorsNumber
        .where((element) =>
            element["type"] == "Téléphonie Mobile" &&
            element["old_initial"].any((i) => i == initial))
        .toList();

    dynamic opMobile = ops != null && ops.isNotEmpty ? ops.first : null;

    if (opMobile != null) return opMobile;

    //check is fix

    initial = phoneNumber.substring(0, 3);
    ops = operatorsNumber
        .where((element) =>
            element["type"] == "Téléphonie Fixe" &&
            element["old_initial"].any((i) => i == initial))
        .toList();

    dynamic opFixe = ops != null && ops.isNotEmpty ? ops.first : null;
    return opFixe;
  }

  static String convert(String phone) {
    phone = normalizeNumber(phone);
    if (!validateNormalizeOldPhoneNumber(phone)) return null;
    dynamic operatorFound = determinateOperator(phone);
    return  "+225${(operatorFound != null ? operatorFound["new_initial"] : "") + phone}";
  }
  static String reverse(String phone) {
    phone = normalizeNumber(phone);
    //if (validateNormalizeOldPhoneNumber(phone)) return null;
    //dynamic operatorFound = determinateOperator(phone);
    return  "+225${phone.substring(2)}";
  }
}
