import 'package:bank_darm/Imports/imports.dart';
import 'package:bank_darm/routers/routers.dart';
import 'package:intl/intl.dart';

class CardNewDemonstPage extends StatefulWidget {
  final String newCard; // Renomeamos de volta para newCard
  final String selectedCardType;

  const CardNewDemonstPage(
      {Key? key, required this.newCard, required this.selectedCardType})
      : super(key: key);

  @override
  State<CardNewDemonstPage> createState() => _CardNewDemonstPageState();
}

class _CardNewDemonstPageState extends State<CardNewDemonstPage> {
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _cardHolderNameController = TextEditingController();
  TextEditingController _cvcController = TextEditingController();
  String expiryDate = '';
  String cardType = '';
  String cvc = '';
  String newCard = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _updateExpiryDate();
  }

  Future<void> _fetchUserData() async {
    // Obtenha a instância do Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Obtenha o ID do usuário atualmente autenticado
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      // Busque os dados do usuário no Firestore
      DocumentSnapshot userSnapshot =
          await firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        // Se o documento do usuário existe, atualize o estado do campo cardHolderName
        setState(() {
          _cardHolderNameController.text =
              (userSnapshot.data() as Map<String, dynamic>)['nome']
                      ?.toString() ??
                  'Nome não encontrado';
        });
      } else {
        // Documento do usuário não encontrado
        setState(() {
          _cardHolderNameController.text = 'Nome não encontrado';
        });
      }
    } catch (e) {
      // Trate o erro ao buscar os dados do usuário, se necessário
      print('Erro ao buscar os dados do usuário: $e');
    }
  }

  void _createUserCard() async {
    // Obtenha a instância do Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Obtenha o ID do usuário atualmente autenticado
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      // Crie um novo documento na coleção "cards" dentro do documento do usuário
      DocumentReference<Map<String, dynamic>> newCardRef = await firestore
          .collection('users')
          .doc(userId)
          .collection('cards')
          .add({
        'tipo': widget.selectedCardType,
        'cardNumber': _cardNumberController.text,
        'cardHolderName': _cardHolderNameController.text,
        'expiryDate': expiryDate,
        'cardType': 'Cartão de ${widget.selectedCardType}',
        'cvc': cvc,
        'marca': cardType,
        'Status': 'Em Analise',
      });

      String newCardId = newCardRef.id;

      // Renomeamos a variável local 'newCard' para 'createdCardType' para evitar conflito
      String createdCardType = await _fetchCardType(newCardId);

      setState(() {
        cardType = createdCardType;
      });

      print('Novo cartão criado com sucesso!');
    } catch (e) {
      print('Erro ao criar novo cartão: $e');
    }
  }

  void _updateExpiryDate([String selectedValue = '2 Anos']) {
    DateTime now = DateTime.now();
    int selectedYears = int.parse(selectedValue.split(' ')[0]);
    DateTime expiryDateTime =
        DateTime(now.year + selectedYears, now.month, now.day);
    String formattedExpiryDate = DateFormat('MM/yy').format(expiryDateTime);
    setState(() {
      expiryDate = formattedExpiryDate;
    });
  }

  String detectCardType(String cardNumber) {
    String cleanedCardNumber = cardNumber.replaceAll(RegExp(r'\s+|-'), '');

    if (RegExp(r'^4[0-9]{12}(?:[0-9]{3})?$').hasMatch(cleanedCardNumber)) {
      return 'Visa';
    } else if (RegExp(r'^5[1-5][0-9]{14}$').hasMatch(cleanedCardNumber)) {
      return 'MasterCard';
    } else if (RegExp(r'^(?:6011|65\d{2}|64[4-9]\d)\d{12}|62\d{14}$')
        .hasMatch(cleanedCardNumber)) {
      return 'Discover';
    } else if (RegExp(r'^3[47][0-9]{13}$').hasMatch(cleanedCardNumber)) {
      return 'American Express';
    } else if (RegExp(r'^(5018|5020|5038|6304|6759|6761|6763)[0-9]{8,15}$')
        .hasMatch(cleanedCardNumber)) {
      return 'Maestro';
    } else if (RegExp(r'^(606282\d{10}(\d{3})?)|(3841\d{15})$')
        .hasMatch(cleanedCardNumber)) {
      return 'Hipercard';
    } else {
      return 'Desconhecido';
    }
  }

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
                      color: Color.fromARGB(255, 0, 102, 246),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  CardWidget(
                    cardNumber: _cardNumberController.text,
                    cardHolderName: _cardHolderNameController.text,
                    expiryDate: expiryDate,
                    nameCard: 'Cartão de ${widget.selectedCardType}',
                    cvc: cvc,
                    cardSelector: cardType,
                  ),
                  const SizedBox(height: 30.0),
                  Text(
                    'Insira as informações abaixo.',
                    style: GoogleFonts.karla(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TitleTextFieldWidget(
                    title: 'Número do Cartão',
                    controller: _cardNumberController,
                    width: 400,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CartaoBancarioInputFormatter(),
                    ],
                    onChanged: (value) {
                      setState(() {
                        cardType = detectCardType(value);
                      });
                    },
                  ),
                  Row(
                    children: [
                      TitleTextFieldWidget(
                        title: 'CVC',
                        controller: _cvcController,
                        width: 160,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        onChanged: (value) {
                          setState(() {
                            cvc = value;
                          });
                        },
                      ),
                      const SizedBox(width: 40),
                      DropAnos(onChanged: _updateExpiryDate),
                    ],
                  ),
                  const SizedBox(height: 190.0),
                  ElevatedButton(
                    onPressed: () {
                      _createUserCard();
                      setState(() {
                        _cardNumberController.text = _cardNumberController.text;
                        _cvcController.text = _cvcController.text;
                        routers.go('/listcards');
                      });
                    },
                    child: Center(
                      child: Text(
                        'VAMOS CONTINUAR!',
                        style: GoogleFonts.karla(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 60.0, vertical: 14.0),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xFF0066F6),
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

Future<String> _fetchCardType(String cardId) async {
  // Obtenha a instância do Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Obtenha o ID do usuário atualmente autenticado
  String userId = FirebaseAuth.instance.currentUser!.uid;

  try {
    // Obtenha a referência para o documento do cartão específico
    DocumentSnapshot cardSnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('cards')
        .doc(cardId) // Use o cardId aqui para obter o documento específico
        .get();

    if (cardSnapshot.exists) {
      // Obtenha o valor do campo "tipo"
      String newCard = cardSnapshot.get('tipo')?.toString() ?? 'Desconhecido';
      print('Tipo de cartão: $newCard');
      return newCard;
    } else {
      // Documento de cartão não encontrado
      return 'Desconhecido';
    }
  } catch (e) {
    // Trate o erro ao buscar os dados do cartão, se necessário
    print('Erro ao buscar os dados do cartão: $e');
    return 'Desconhecido';
  }
}

class CreateNewcardPage extends StatefulWidget {
  const CreateNewcardPage({super.key});

  @override
  State<CreateNewcardPage> createState() => _CreateNewcardPageState();
}

class _CreateNewcardPageState extends State<CreateNewcardPage> {
  String selectedCardType = '';
  int totalCards = 0;
  String newCard = '';

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
                    'Deseja criar um novo cartão?',
                    style: GoogleFonts.karla(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Color.fromARGB(255, 0, 102, 246)),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Selecione o tipo de cartão que deseja criar.',
                    style: GoogleFonts.karla(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  RadioButtonsWidget(
                    onChanged: (value) {
                      setState(() {
                        selectedCardType = value;
                      });
                    },
                  ),
                  SizedBox(height: 220.0),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        // Atualiza o newCard com o tipo de cartão selecionado
                        setState(() {
                          newCard = selectedCardType;
                        });
                        routers.go('/demonstnewcard/$newCard/$selectedCardType');
                      },
                      child: Center(
                        child: Text(
                          'CRIAR CARTÃO',
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
