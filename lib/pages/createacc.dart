import 'package:bank_darm/pages/createcard.dart';
import 'package:bank_darm/pages/imports.dart';

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
            padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    'Crie sua conta',
                    style: GoogleFonts.karla(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Color.fromARGB(255, 0, 102, 246),
                    ),
                  ),
                  SizedBox(height: 2.0),
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
                    width: 400,
                    obscureText: false,
                  ),
                  TitleTextFieldWidget(
                    title: 'E-mail',
                    controller: TextEditingController(),
                    width: 400,
                    obscureText: false,
                  ),
                  TitleTextFieldWidget(
                    title: 'CPF',
                    controller: TextEditingController(),
                    width: 400,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                  ),
                  TitleTextFieldWidget(
                    title: 'Telefone',
                    controller: TextEditingController(),
                    width: 400,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                  ),
                  Row(
                    children: [
                      TitleTextFieldWidget(
                        title: 'Endereço',
                        controller: TextEditingController(),
                        width: 250,
                        obscureText: false,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      DropWidget()
                    ],
                  ),
                  RadioConta(),
                  TitleTextFieldWidget(
                    title: 'Senha',
                    controller: TextEditingController(),
                    width: 400,
                    obscureText: true,
                  ),
                  TitleTextFieldWidget(
                    title: 'Confirmar senha',
                    controller: TextEditingController(),
                    width: 400,
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreatecardPage(),
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
                            horizontal: 60.0,
                            vertical: 14.0,
                          ),
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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Loginpage(),
                            ),
                          );
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
