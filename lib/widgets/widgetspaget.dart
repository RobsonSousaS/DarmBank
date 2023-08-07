import 'package:bank_darm/Imports/imports.dart';

class TitleTextFieldWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final double width;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLength;
  final void Function(String)? onChanged;

  TitleTextFieldWidget(
      {required this.title,
      required this.controller,
      required this.width,
      required this.obscureText,
      this.keyboardType,
      this.inputFormatters,
      this.maxLength = 50,
      this.onChanged});
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
            onChanged: onChanged,
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
  final ValueChanged<String>? onChanged;

  const RadioButtonsWidget({Key? key, this.onChanged}) : super(key: key);

  @override
  _RadioButtonsWidgetState createState() => _RadioButtonsWidgetState();
}

class _RadioButtonsWidgetState extends State<RadioButtonsWidget> {
  int? selectedPair;

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
                    widget.onChanged?.call('Débito');
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
                    widget.onChanged?.call('Crédito');
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
                    widget.onChanged?.call('Poupança');
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
            'Você também tem a opção de selecionar cartões multifuncionais',
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
                    widget.onChanged?.call('Crédito e Débito');
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
                    widget.onChanged?.call('Poupança e Débito');
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
  final String cardSelector;

  CardWidget({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cardType,
    required this.cvc,
    required this.cardSelector,
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
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    cardType,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      cardSelector,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
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
  final void Function(String)? onChanged;

  const DropAnos({this.onChanged});

  @override
  State<DropAnos> createState() => _DropAnosState();
}

class _DropAnosState extends State<DropAnos> {
  String anoSelecionado = '2 Anos';
  List<String> anos = [
    '2 Anos',
    '4 Anos',
    '5 Anos',
    '6 Anos',
  ];

  void _updateExpiryDate(String selectedValue) {
    if (widget.onChanged != null) {
      widget.onChanged!(selectedValue);
    }
  }

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
              _updateExpiryDate(anoSelecionado);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              contentPadding: contentPadding,
            ),
            items: anos.map((String ano) {
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

class CardsWidget extends StatelessWidget {
  final String cardType;
  final String cardNumber;

  CardsWidget({required this.cardType, required this.cardNumber});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: ListTile(
        leading: Icon(Icons.credit_card),
        title: Text(cardType),
        subtitle: Text(cardNumber),
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

class CardsCliWidget extends StatelessWidget {
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
                builder: (context) => CardsCliPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ClientsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: ListTile(
        leading: Icon(Icons.account_circle),
        title: Text('NOME DO CLIENTE'),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CardsCliPage(),
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

class TipoContaDropdownWidget extends StatefulWidget {
  final TextEditingController tipoContaController;

  TipoContaDropdownWidget({required this.tipoContaController});

  @override
  _TipoContaDropdownWidgetState createState() =>
      _TipoContaDropdownWidgetState();
}

class _TipoContaDropdownWidgetState extends State<TipoContaDropdownWidget> {
  String tipoContaSelecionado = 'Conta Poupança';
  List<String> tiposConta = ['Conta Poupança', 'Conta Corrente'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 7),
        Text(
          'Tipo de Conta',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
        SizedBox(height: 6),
        Container(
          width: 150,
          height: 50,
          child: DropdownButtonFormField<String>(
            value: tipoContaSelecionado,
            onChanged: (value) {
              setState(() {
                tipoContaSelecionado = value!;
              });
              widget.tipoContaController.text = value!;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
            ),
            items: tiposConta.map((String tipoConta) {
              return DropdownMenuItem<String>(
                value: tipoConta,
                child: Text(tipoConta, style: TextStyle(fontSize: 12.0)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class EstadoDropdownWidget extends StatefulWidget {
  final TextEditingController estadoController;

  EstadoDropdownWidget({required this.estadoController});

  @override
  _EstadoDropdownWidgetState createState() => _EstadoDropdownWidgetState();
}

class _EstadoDropdownWidgetState extends State<EstadoDropdownWidget> {
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
    'TO',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 7),
        Text(
          'Estado',
          style: TextStyle(
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
            onChanged: (value) {
              setState(() {
                estadoSelecionado = value!;
              });
              widget.estadoController.text = value!;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
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
