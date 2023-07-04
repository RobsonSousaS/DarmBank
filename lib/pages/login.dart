import 'package:bank_darm/Imports/imports.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
            padding: EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    'Entre na sua',
                    style: GoogleFonts.karla(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Color.fromARGB(255, 0, 102, 246)),
                  ),
                  Text(
                    'conta',
                    style: GoogleFonts.karla(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Color.fromARGB(255, 0, 102, 246)),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Faça login na sua conta DarmBank',
                    style: GoogleFonts.karla(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 60.0),
                  TitleTextFieldWidget(
                    title: 'CPF',
                    controller: _cpfController,
                    width: 400,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                  ),
                  TitleTextFieldWidget(
                    title: 'Senha',
                    controller: _passwordController,
                    width: 400,
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Esqueceu sua senha?,',
                        style: GoogleFonts.karla(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Forgotpasspage(),
                            ),
                          );
                        },
                        child: Text(
                          'clique aqui para recuperá-la',
                          style: GoogleFonts.karla(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 170,
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        loginWithCPF();
                      },
                      child: Center(
                        child: Text(
                          'LOGAR',
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
                        'Você não tem uma conta no DarmBank?',
                        style: GoogleFonts.karla(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateAccountPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Se cadastre aqui',
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

  Future<void> loginWithCPF() async {
  String cpf = _cpfController.text;
  String password = _passwordController.text;
  
  try {
    String email = '$cpf@dominio.com';
    
    // Autentique o usuário usando o Firebase Authentication
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Verifique se o login foi bem-sucedido
    if (userCredential.user != null) {
      // O login foi bem-sucedido, faça o que for necessário, como navegar para a próxima tela
      print('Login bem-sucedido: ${userCredential.user!.uid}');
    } else {
      // O login falhou, trate conforme necessário
      print('Login falhou');
    }
  } catch (e) {
    // Trate o erro de login conforme necessário
    print('Erro de login: $e');
  }
}
}
