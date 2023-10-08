import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}



class Button {
  static const String del = "DEL";
  static const String clr = "AC";
  static const String per = "%";
  static const String multiply = "×";
  static const String divide = "÷";
  static const String add = "+";
  static const String subtract = "-";
  static const String calculate = "=";
  static const String dot = ".";
  static const String n0 = "0";
  static const String n1 = "1";
  static const String n2 = "2";
  static const String n3 = "3";
  static const String n4 = "4";
  static const String n5 = "5";
  static const String n6 = "6";
  static const String n7 = "7";
  static const String n8 = "8";
  static const String n9 = "9";

  static const List<String> buttonValues = [
    clr,
    del,
    per,
    multiply,
    n7,
    n8,
    n9,
    divide,
    n4,
    n5,
    n6,
    subtract,
    n1,
    n2,
    n3,
    add,
    dot,
    n0,
    calculate,
  ];
}




class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String operand = "";
  String number2 = "";


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:Colors.black,
      body:


      SafeArea(
        bottom: false,
        child: Column(
          children: [
            // output


            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  height: 250,
                  width: 400,
                  decoration: BoxDecoration(
                    color:Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 3,
                      color: Colors.white,
                    ),
                  ),

                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                    style:TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade900,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            Divider(
              color: Colors.black,
              thickness: 1.0,
              indent: 20,
              endIndent: 20,
            ),

            // buttons
            Wrap(
              children: Button.buttonValues
                  .map(
                    (value) => SizedBox(
                  width: value == Button.calculate
                      ? screenSize.width / 2
                      : (screenSize.width / 4),
                  height: screenSize.width / 5,
                  child: buildButton(value),
                ),
              )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getButtonColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }


  void onBtnTap(String value) {
    if (value == Button.del) {
      delete();
      return;
    }

    if (value == Button.clr) {
      clearAll();
      return;
    }

    if (value == Button.per) {
      convertToPercentage();
      return;
    }

    if (value == Button.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  void calculate() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;
    switch (operand) {
      case Button.add:
        result = num1 + num2;
        break;
      case Button.subtract:
        result = num1 - num2;
        break;
      case Button.multiply:
        result = num1 * num2;
        break;
      case Button.divide:
        result = num1 / num2;
        break;
      default:
    }

    setState(() {
      number1 = result.toStringAsPrecision(3);

      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }

      operand = "";
      number2 = "";
    });
  }

  void convertToPercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate();
    }

    if (operand.isNotEmpty) {
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }


  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }

    setState(() {});
  }


  void appendValue(String value) {

    if (value != Button.dot && int.tryParse(value) == null) {

      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operand = value;
    }

    else if (number1.isEmpty || operand.isEmpty) {
      if (value == Button.dot && number1.contains(Button.dot)) return;
      if (value == Button.dot && (number1.isEmpty || number1 == Button.n0)) {
        value = "0.";
      }
      number1 += value;
    }
    else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == Button.dot && number2.contains(Button.dot)) return;
      if (value == Button.dot && (number2.isEmpty || number2 == Button.n0)) {
        value = "0.";
      }
      number2 += value;
    }

    setState(() {});
  }
  Color getButtonColor(value) {
    return [Button.del, Button.clr].contains(value)
        ? Colors.indigo.shade600
        : [
      Button.per,
      Button.multiply,
      Button.add,
      Button.subtract,
      Button.divide,
      Button.calculate,
    ].contains(value)
        ? Colors.indigo.shade300
        : Colors.indigo.shade900;
  }
}