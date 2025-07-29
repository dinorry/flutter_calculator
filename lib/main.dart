import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see

        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.dark(),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? bgcolor;
  final Color? color;
  final double fontSize;

  const CustomTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.bgcolor,
    this.color,
    this.fontSize = 36,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsetsGeometry.all(7.0),
        child: TextButton(
          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(bgcolor ?? Colors.grey[800])),
          onPressed: onPressed,
          child: Text(label, style:
            TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              color: color)),
        )
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _input = '0';
  String _operator = '+';
  String _memory = '0';
  int _stage = 0;
  final Color _operandColor = Color(0xFFDC9C63);
  final Color _specialButtonColor = Color(0xFFFFFFFF);


  void _backspace() {
    if (_input.length > 1) {
      _input = _input.substring(0, _input.length - 1);
    } else {
      _input = '0';
    }
  }

  String _operation([bool rev = false]) {
    //Retunr _input - operand - _memory or reverse
    String _convertable_input = _input.replaceAll(',', '.');
    String _convertable_memory = _memory.replaceAll(',', '.');
    double _inputNum = double.tryParse(_convertable_input) ?? 0.0;
    double _memoryNum = double.tryParse(_convertable_memory) ?? 0.0;
    String _result = 'Error';
    if (_operator == '+') {
      _result = (_memoryNum + _inputNum).toString();
    } else if (_operator == '*') {
      _result = (_memoryNum * _inputNum).toString();
    } else if (!rev) {
      if (_operator == '-') {
        _result = (_memoryNum - _inputNum).toString();
      } else {
        if (_inputNum == 0) {
          _result = 'Error: Division by zero';
        } else
          _result = (_memoryNum / _inputNum).toString();
      }
    } else {
      if (_operator == '-') {
        _result = (_inputNum - _memoryNum).toString();
      } else {
        if (_memoryNum == 0) {
          _result = 'Error: Division by zero';
        } else
          _result = (_inputNum / _memoryNum).toString();
      }
    }
    if (_result.substring(_result.length - 2) == '.0') {
      return _result.substring(0, _result.length - 2);
    }
    return _result.replaceAll('.', ',');
  }

  void _onNumberPressed(String number) {
    setState(() {
      if (_input == '0' && _stage == 1) {
        _input = number;
        _stage = 1;
      } else if (_stage == 0) {
        _input = number;
        _stage = 1;
      } else if (_stage == 1 || _stage == 3) {
        if (_input == '0'){
          _input = number;
        }else if (_input.length >= 15) {
          return;
        } else {
          _input += number;
        }
      } else if (_stage == 2) {
        _memory = _input; // Storing current input number to replace it with the new one
        _input = number;
        _stage = 3;
      }
    });
  }

  void _onCommaPressed() {
    setState(() {
      if (_stage == 1 || _stage == 3 || _stage == 0) {
        if (!_input.contains(',')) {
          _input += ',';
          if (_stage == 0) {
            _stage = 1;
          }
        }
      } else if (_stage == 2) {
        _memory = _input;
        _input = '0,';
        _stage = 3;
      }
    });
  }

  void _onEqualPressed() {
    if (_stage == 3) {
      setState(() {
        String num = _operation();
        _memory = _input;
        _input = num;
        _stage = 0;
      });
    } else if (_stage == 1 || _stage == 0) {
      setState(() {
        _input = _operation(true);
      });
    }
  }

  void _onOperatorPressed(String operator) {
    setState(() {
      if (_stage == 0 || _stage == 1) {
        _operator = operator;
        _stage = 2;
      } else if (_stage == 2) {
        _operator = operator;
      } else if (_stage == 3) {
        _input = _operation();
        _operator = operator;
        _stage = 2;
      }
    });
  }

  void _onButtonPressed(String button) {
    if (button == "AC") {
      setState(() {
        _input = '0';
        _operator = '';
        _stage = 0;
        _memory = '0';
      });
    } else if (button == "+/-") {
      setState(() {
        if (_input.isNotEmpty) {
          if (_input.startsWith('-')) {
            _input = _input.substring(1);
          } else {
            _input = '-' + _input;
          }
        }
      });
    } else if (button == "⌫") {
      setState(() {
        if (_stage == 1) {
          _backspace();
        } else if (_stage == 2) {
          _memory = '0';
          _stage = 1;
          _backspace();
        } else if (_stage == 3) {
          _backspace();
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [ Container(
              padding: EdgeInsetsGeometry.fromLTRB(40, 10, 40, 0),
              alignment: Alignment.bottomRight,
              child: Text(_input,
              style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
              GridView.count(
                shrinkWrap: true,
              crossAxisCount: 4,
              physics: NeverScrollableScrollPhysics(),
              children: [
                CustomTextButton(onPressed: () => _onButtonPressed("AC"), label: "AC", color: _specialButtonColor,),
                CustomTextButton(onPressed: () => _onButtonPressed("+/-"), label: "+/-", color: _specialButtonColor,),
                CustomTextButton(onPressed: () => _onButtonPressed("⌫"), label: "⌫", color: _specialButtonColor),
                CustomTextButton(onPressed: () => _onOperatorPressed("*"), label: "×", color: _operandColor, fontSize: 42,) ,
                CustomTextButton(onPressed: () => _onNumberPressed("7"), label: "7"),
                CustomTextButton(onPressed: () => _onNumberPressed("8"), label: "8"),
                CustomTextButton(onPressed: () => _onNumberPressed("9"), label: "9"),
                CustomTextButton(onPressed: () => _onOperatorPressed("/"), label: "÷", color: _operandColor,),
                CustomTextButton(onPressed: () => _onNumberPressed("4"), label: "4"),
                CustomTextButton(onPressed: () => _onNumberPressed("5"), label: "5"),
                CustomTextButton(onPressed: () => _onNumberPressed("6"), label: "6"),
                CustomTextButton(onPressed: () => _onOperatorPressed("-"), label: "-", color: _operandColor,),
                CustomTextButton(onPressed: () => _onNumberPressed("1"), label: "1"),
                CustomTextButton(onPressed: () => _onNumberPressed("2"), label: "2"),
                CustomTextButton(onPressed: () => _onNumberPressed("3"), label: "3"),
                CustomTextButton(onPressed: () => _onOperatorPressed("+"), label: "+", color: _operandColor,),
                Container(),
                CustomTextButton(onPressed: () => _onNumberPressed("0"), label: "0"),
                CustomTextButton(onPressed: () => _onCommaPressed(), label: ","),
                CustomTextButton(onPressed: _onEqualPressed, label: "=", color: _operandColor,),
              ],
                      ),
          ]
          ),
        ),
      ),
    );
  }
}
