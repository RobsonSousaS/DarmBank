import 'package:bank_darm/pages/imports.dart';

class TitleTextFieldWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final double width;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLength;

  TitleTextFieldWidget({
    required this.title,
    required this.controller,
    required this.width,
    required this.obscureText,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength = 50,
  });
  @override
  Widget build(BuildContext context) {
    EdgeInsets contentPadding =
        EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0);

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
        Container(
          width: width,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              contentPadding: contentPadding,
              counterText: '',
            ),
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
  void initState() {
    super.initState();
    _selectedAccountType = 0;
  }

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
            fontSize: 12.0,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Row(
              children: [
                Radio<int>(
                  value: 0,
                  groupValue: _selectedAccountType,
                  onChanged: (value) {
                    setState(() {
                      _selectedAccountType = value!;
                    });
                  },
                ),
                Text(
                  'Conta Corrente',
                  style: GoogleFonts.karla(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16),
            Row(
              children: [
                Radio<int>(
                  value: 1,
                  groupValue: _selectedAccountType,
                  onChanged: (value) {
                    setState(() {
                      _selectedAccountType = value!;
                    });
                  },
                ),
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
        ),
      ],
    );
  }
}

class DropWidget extends StatefulWidget {
  const DropWidget({Key? key});

  @override
  State<DropWidget> createState() => _DropWidgetState();
}

class _DropWidgetState extends State<DropWidget> {
  String estadoSelecionado = 'AC';
  List<String> estados = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO'
  ];

  @override
  Widget build(BuildContext context) {
    EdgeInsets contentPadding =
        EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 7,
        ),
        Text(
          'Estado',
          style: GoogleFonts.karla(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
        SizedBox(height: 6),
        Container(
          width: 100,
          height: 50,
          child: DropdownButtonFormField<String>(
            value: estadoSelecionado,
            onChanged: (String? newValue) {
              setState(() {
                estadoSelecionado = newValue!;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              contentPadding: contentPadding,
            ),
            items: estados.map((String estado) {
              return DropdownMenuItem<String>(
                value: estado,
                child: Text(estado, style: TextStyle(fontSize: 12.0)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class PasscodeDigitTextField extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final FocusNode? nextFocusNode;

  const PasscodeDigitTextField({
    required this.focusNode,
    required this.controller,
    this.nextFocusNode,
  });

  @override
  _PasscodeDigitTextFieldState createState() => _PasscodeDigitTextFieldState();
}

class _PasscodeDigitTextFieldState extends State<PasscodeDigitTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      child: TextField(
        focusNode: widget.focusNode,
        controller: widget.controller,
        keyboardType: TextInputType.number,
        maxLength: 1,
        obscureText: true,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && widget.nextFocusNode != null) {
            widget.focusNode.unfocus();
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          }
        },
      ),
    );
  }
}

class RadioButtonsWidget extends StatefulWidget {
  @override
  _RadioButtonsWidgetState createState() => _RadioButtonsWidgetState();
}

class _RadioButtonsWidgetState extends State<RadioButtonsWidget> {
  int selectedPair = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Radio<int>(
                value: 0,
                groupValue: selectedPair,
                onChanged: (value) {
                  setState(() {
                    selectedPair = value!;
                  });
                },
              ),
              Text(
                'Débito',
                style: GoogleFonts.karla(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Radio<int>(
                value: 1,
                groupValue: selectedPair,
                onChanged: (value) {
                  setState(() {
                    selectedPair = value!;
                  });
                },
              ),
              Text(
                'Crédito',
                style: GoogleFonts.karla(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Radio<int>(
                value: 2,
                groupValue: selectedPair,
                onChanged: (value) {
                  setState(() {
                    selectedPair = value!;
                  });
                },
              ),
              Text(
                'Poupança',
                style: GoogleFonts.karla(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Você também tem opção de selecionar cartões multifuncionais',
            style: GoogleFonts.karla(
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              Radio<int>(
                value: 3,
                groupValue: selectedPair,
                onChanged: (value) {
                  setState(() {
                    selectedPair = value!;
                  });
                },
              ),
              Text(
                'Crédito e Débito',
                style: GoogleFonts.karla(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Radio<int>(
                value: 4,
                groupValue: selectedPair,
                onChanged: (value) {
                  setState(() {
                    selectedPair = value!;
                  });
                },
              ),
              Text(
                'Poupança e Débito',
                style: GoogleFonts.karla(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cardType;
  final String cvc;

  CardWidget({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cardType,
    required this.cvc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              cardType,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              cardNumber,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              cardHolderName,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  expiryDate,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 250),
                child: Text(
                  cvc,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DropAnos extends StatefulWidget {
  const DropAnos({Key? key});

  @override
  State<DropAnos> createState() => _DropAnosState();
}

class _DropAnosState extends State<DropAnos> {
  String anoSelecionado = '2 Anos';
  List<String> ano = [
    '2 Anos',
    '4 Anos',
    '5 Anos',
    '6 Anos',
  ];

  @override
  Widget build(BuildContext context) {
    EdgeInsets contentPadding =
        EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 7,
        ),
        Text(
          'Data de Validade',
          style: GoogleFonts.karla(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
        SizedBox(height: 6),
        Container(
          width: 160,
          height: 50,
          child: DropdownButtonFormField<String>(
            value: anoSelecionado,
            onChanged: (String? newValue) {
              setState(() {
                anoSelecionado = newValue!;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              contentPadding: contentPadding,
            ),
            items: ano.map((String ano) {
              return DropdownMenuItem<String>(
                value: ano,
                child: Text(ano, style: TextStyle(fontSize: 12.0)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class DropCardtype extends StatefulWidget {
  const DropCardtype({Key? key});

  @override
  State<DropCardtype> createState() => _DropCardtypeState();
}

class _DropCardtypeState extends State<DropCardtype> {
  String cardSelecionado = 'Visa';
  List<String> card = [
    'Visa',
    'MasterCard',
    'Elo',
    'Hibercard',
    'American Express'
  ];

  @override
  Widget build(BuildContext context) {
    EdgeInsets contentPadding =
        EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 7,
        ),
        Text(
          'Tipo de cartão',
          style: GoogleFonts.karla(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
        SizedBox(height: 6),
        Container(
          width: 160,
          height: 50,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              contentPadding: contentPadding,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: cardSelecionado,
                onChanged: null,
                items: card.map((String card) {
                  return DropdownMenuItem<String>(
                    value: card,
                    child: Text(card, style: TextStyle(fontSize: 12.0)),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CardsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: ListTile(
        leading: Icon(Icons.credit_card),
        title: Text('Cartão de Crédito'),
        subtitle: Text('**** **** **** 1234'),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CardDetailsPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CardStatus extends StatelessWidget {
  const CardStatus({required this.status});

  final int status;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      if (status == 1)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Aprovado', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      if (status == 2)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(Icons.watch_later, color: Colors.orange),
              SizedBox(width: 8),
              Text('Esperando avaliação', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      if (status == 3)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(Icons.cancel, color: Colors.red),
              SizedBox(width: 8),
              Text('Reprovado', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
    ]);
  }
}
