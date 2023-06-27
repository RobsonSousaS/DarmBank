import 'package:bank_darm/pages/carddemonst.dart';
import 'package:bank_darm/pages/imports.dart';

class CreatenewcardPage extends StatefulWidget {
  const CreatenewcardPage({super.key});

  @override
  State<CreatenewcardPage> createState() => _CreatenewcardPageState();
}

class _CreatenewcardPageState extends State<CreatenewcardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    'Deseja cadastrar um novo cartão?',
                    style: GoogleFonts.karla(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Color.fromARGB(255, 0, 102, 246)),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Selecione o tipo de cartão que deseja cadastrar.',
                    style: GoogleFonts.karla(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  RadioButtonsWidget(),
                  SizedBox(height: 220.0),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CardnewdemonstPage(),
                          ),
                        );
                      },
                      child: Center(
                        child: Text(
                          'CADASTRAR NOVO CARTÃO',
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


class CardnewdemonstPage extends StatefulWidget {
  const CardnewdemonstPage({super.key});

  @override
  State<CardnewdemonstPage> createState() => _CardnewdemonstPageState();
}

class _CardnewdemonstPageState extends State<CardnewdemonstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    'Seu novo cartão está aqui!',
                    style: GoogleFonts.karla(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Color.fromARGB(255, 0, 102, 246)),
                  ),
                  SizedBox(height: 20.0),
                  CardWidget(
                    cardNumber: '1234 5678 9012 3456',
                    cardHolderName: 'JOHN DOE',
                    expiryDate: '12/24',
                    cardType: 'Cartão de XXXX',
                    cvc: '123',
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    'Insira as informações abaixo.',
                    style: GoogleFonts.karla(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TitleTextFieldWidget(
                    title: 'Número do Cartão',
                    controller: TextEditingController(),
                    width: 400,  obscureText: false,
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    children: [
                      TitleTextFieldWidget(
                        title: 'CVC',
                        controller: TextEditingController(),
                        width: 160,  obscureText: false,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(width: 40,),
                      DropAnos(),
                    ],
                  ),
                  TitleTextFieldWidget(
                    title: 'CPF',
                    controller: TextEditingController(),
                    width: 400,  obscureText: false,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 80.0),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CardPage(),
                          ),
                        );
                      },
                      child: Center(
                        child: Text(
                          'SOLICITAR CARTÃO',
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
