import 'package:bank_darm/Imports/imports.dart';
class ForgotPasscodePage extends StatefulWidget {
  @override
  _ForgotPasscodePageState createState() => _ForgotPasscodePageState();
}

class _ForgotPasscodePageState extends State<ForgotPasscodePage> {
  List<String> passcode = List.filled(4, '');
  List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  List<TextEditingController> controllers =
      List.generate(4, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 4; i++) {
      controllers[i].addListener(() {
        if (controllers[i].text.isNotEmpty && i < 3) {
          FocusScope.of(context).requestFocus(focusNodes[i + 1]);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Loginpage(),
                  ),
                );
              },
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    'Verifique sua conta',
                    style: GoogleFonts.karla(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Color.fromARGB(255, 0, 102, 246)),
                  ),
                  SizedBox(height: 10.0),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: 'Por favor, digite o',
                        ),
                        TextSpan(
                          text: ' CÓDIGO ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'enviado para o seu email nas caixas abaixo.',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PasscodeDigitTextField(
                        focusNode: focusNodes[0],
                        controller: controllers[0],
                        nextFocusNode: focusNodes[1],
                      ),
                      SizedBox(width: 16.0),
                      PasscodeDigitTextField(
                        focusNode: focusNodes[1],
                        controller: controllers[1],
                        nextFocusNode: focusNodes[2],
                      ),
                      SizedBox(width: 16.0),
                      PasscodeDigitTextField(
                        focusNode: focusNodes[2],
                        controller: controllers[2],
                        nextFocusNode: focusNodes[3],
                      ),
                      SizedBox(width: 16.0),
                      PasscodeDigitTextField(
                        focusNode: focusNodes[3],
                        controller: controllers[3],
                        nextFocusNode: null,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 420.0,
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Recoverpage(),
                          ),
                        );
                      },
                      child: Center(
                        child: Text(
                          'VERIFIQUE SEU EMAIL',
                          style: GoogleFonts.karla(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                              horizontal: 60.0, vertical: 14.0),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFF0066F6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
