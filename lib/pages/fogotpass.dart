import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bank_darm/pages/login.dart';

class Forgotpasspage extends StatefulWidget {
  const Forgotpasspage({super.key});

  @override
  State<Forgotpasspage> createState() => _ForgotpasspageState();
}

class _ForgotpasspageState extends State<Forgotpasspage> {
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
                    'Esqueceu sua senha?',
                    style: GoogleFonts.karla(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Color.fromARGB(255, 0, 102, 246)),
                  ),

                  SizedBox(height: 10.0),
                  Text(
                    'Informe seu CPF para recuperar sua senha.',
                    style: GoogleFonts.karla(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 50.0),
                  TitleTextFieldWidget(
                    title: 'E-mail',
                    controller: TextEditingController(),
                  ),
                  SizedBox(height: 10.0),
                  TitleTextFieldWidget(
                    title: 'Nome Comleto',
                    controller: TextEditingController(),
                  ),
                  SizedBox(height: 10.0),
                  TitleTextFieldWidget(
                    title: 'CPF',
                    controller: TextEditingController(),
                  ),
                  SizedBox(
                    height: 190.0,
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Center(
                        child: Text(
                          'RECUPERE SUA SENHA',
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
          height: 15,
        ),
        Text(
          title,
          style: GoogleFonts.karla(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
        SizedBox(height: 15.0),
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