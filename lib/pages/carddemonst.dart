import 'package:bank_darm/Imports/imports.dart';

class CarddemonstPage extends StatefulWidget {
  const CarddemonstPage({super.key});

  @override
  State<CarddemonstPage> createState() => _CarddemonstPageState();
}

class _CarddemonstPageState extends State<CarddemonstPage> {
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
                    'Primeira visualização do seu cartão!',
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
                    width: 400,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CartaoBancarioInputFormatter(),
                    ],
                  ),
                  Row(
                    children: [
                      TitleTextFieldWidget(
                        title: 'CVC',
                        controller: TextEditingController(),
                        width: 160,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      DropAnos(),
                    ],
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
                  DropCardtype(),
                  SizedBox(height: 5.0),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
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
