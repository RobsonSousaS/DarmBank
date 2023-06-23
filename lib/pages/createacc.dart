import 'package:flutter/material.dart';
import 'package:bank_darm/pages/login_signup.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
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
                    builder: (context) => Loginsignuppage(),
                  ),
                );
              },
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
                16.0, 0, 16.0, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    'Crie sua conta',
                    style: GoogleFonts.karla(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Abra uma conta no BankMe com alguns detalhes.',
                    style: GoogleFonts.karla(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  TitleTextFieldWidget(
                    title: 'Nome completo',
                    controller: TextEditingController(),
                  ),
                  TitleTextFieldWidget(
                    title: 'E-mail',
                    controller: TextEditingController(),
                  ),
                  TitleTextFieldWidget(
                    title: 'CPF',
                    controller: TextEditingController(),
                  ),
                  TitleTextFieldWidget(
                    title: 'Telefone',
                    controller: TextEditingController(),
                  ),
                  TitleTextFieldWidget(
                    title: 'Endereço',
                    controller: TextEditingController(),
                  ),
                  RadioConta(),
                  TitleTextFieldWidget(
                    title: 'Senha',
                    controller: TextEditingController(),
                  ),
                  TitleTextFieldWidget(
                    title: 'Confirmar senha',
                    controller: TextEditingController(),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateAccountPage(),
                          ),
                        );
                      },
                      child: Center(
                        child: Text(
                          'CRIAR SUA CONTA',
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
                  Row(
                    children: [
                      Text(
                        'Você já tem uma conta no DarmBank?',
                        style: GoogleFonts.karla(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          
                        },
                        child: Text(
                          'Faça login aqui',
                          style: GoogleFonts.karla(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
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

class TitleTextFieldWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;

  TitleTextFieldWidget({required this.title, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 5,
        ),
        Text(
          title,
          style: GoogleFonts.karla(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
        SizedBox(height: 5.0),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          ),
        )
      ],
    );
  }
}
class RadioConta extends StatefulWidget {
  const RadioConta({Key? key}) : super(key: key);

  @override
  _RadioContaState createState() => _RadioContaState();
}

class _RadioContaState extends State<RadioConta> {
  int _selectedAccountType = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Text(
          'Selecione o tipo de conta:',
          style: GoogleFonts.karla(
            fontWeight: FontWeight.bold,
            fontSize: 13.0,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedAccountType = 0;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: _selectedAccountType == 0
                      ? Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                        )
                      : Container(),
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Conta Corrente',
              style: GoogleFonts.karla(
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedAccountType = 1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: _selectedAccountType == 1
                      ? Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                        )
                      : Container(),
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Conta Poupança',
              style: GoogleFonts.karla(
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
