import 'package:bank_darm/Imports/imports.dart';
import 'package:intl/intl.dart';

class CarddemonstPage extends StatefulWidget {
  const CarddemonstPage({super.key});

  @override
  State<CarddemonstPage> createState() => _CarddemonstPageState();
}

class _CarddemonstPageState extends State<CarddemonstPage> {
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _cardHolderNameController = TextEditingController();
  TextEditingController _cvcController = TextEditingController();
  String expiryDate = '';
  String cardType = '';
  String cvc = '';
  String typeCard = '';

  @override
void initState() {
  super.initState();
  _fetchUserData();
  _updateExpiryDate();

  // Vamos buscar o primeiro documento da coleção "cards"
  fetchCardData().then((cardSnapshots) {
    if (cardSnapshots.isNotEmpty) {
      String firstCardId = cardSnapshots[0].id; // Obtemos o ID do primeiro cartão
      _fetchCardType(firstCardId).then((value) {
        setState(() {
          typeCard = value;
        });
      });
    }
  });
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


Future<void> _updateCardDocument() async {
  // Obtenha a instância do Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Obtenha o ID do usuário atualmente autenticado
  String userId = FirebaseAuth.instance.currentUser!.uid;

  try {
    // Obtenha a referência para a coleção "cards" do usuário
    CollectionReference cardsCollection =
        firestore.collection('users').doc(userId).collection('cards');

    // Obtenha o primeiro documento da coleção "cards"
    QuerySnapshot querySnapshot = await cardsCollection.limit(1).get();

    if (querySnapshot.size > 0) {
      // Obtenha o primeiro documento retornado
      QueryDocumentSnapshot cardSnapshot = querySnapshot.docs[0];

      // Obtenha os dados do documento como um Map<String, dynamic>
      Map<String, dynamic> cardData = cardSnapshot.data() as Map<String, dynamic>;

      // Verifique se o campo "tipo" está presente nos dados do documento
      if (cardData.containsKey('tipo')) {
        // Obtenha o ID do documento
        String docId = cardSnapshot.id;

        // Atualize os campos do documento com os valores do CardWidget
        await cardsCollection.doc(docId).update({
          'cardNumber': _cardNumberController.text,
          'cardHolderName': _cardHolderNameController.text,
          'expiryDate': expiryDate,
          'cardType': 'Cartão de $typeCard',
          'cvc': cvc,
          'cardSelector': cardType,
          'Status': 'Em Analise',
        });

        print('Documento de cartão atualizado com sucesso!');
      } else {
        print('O campo "tipo" não existe no documento de cartão.');
      }
    } else {
      print('Nenhum documento de cartão encontrado para atualizar.');
    }
  } catch (e) {
    print('Erro ao atualizar o documento de cartão: $e');
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
                    cardType: 'Cartão de $typeCard',
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
                      _updateCardDocument();
                      setState(() {
                        _cardNumberController.text = _cardNumberController.text;
                        _cvcController.text = _cvcController.text;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CardPage(),
                            ),
                          );
                      });
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
      String typeCard =
          cardSnapshot.get('tipo')?.toString() ?? 'Desconhecido';
      print('Tipo de cartão: $typeCard');
      return typeCard;
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


class CreatecardPage extends StatefulWidget {
  const CreatecardPage({super.key});

  @override
  State<CreatecardPage> createState() => _CreatecardPageState();
}

class _CreatecardPageState extends State<CreatecardPage> {
  String selectedCardType = '';
  int totalCards = 0;
   String typeCard = '';

  void _createUserCard() async {
  // Obtenha a instância do Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Obtenha o ID do usuário atualmente autenticado
  String userId = FirebaseAuth.instance.currentUser!.uid;

  try {
    // Crie um novo documento na coleção "cards" dentro do documento do usuário
    DocumentReference<Map<String, dynamic>> newCardRef =
        await firestore.collection('users').doc(userId).collection('cards').add({
      'tipo': selectedCardType,
    });

    String newCardId = newCardRef.id; // Obtemos o ID do novo cartão criado

    print('Novo cartão criado com sucesso! ID: $newCardId');

    // Agora, vamos passar o cardId para a função _fetchCardType
    String cardType = await _fetchCardType(newCardId);
    setState(() {
      typeCard = cardType;
    });

      print('Novo cartão criado com sucesso!');
    } catch (e) {
      print('Erro ao criar novo cartão: $e');
    }
  }

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
                    'Vamos criar seu primeiro cartão?',
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
                        _createUserCard();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarddemonstPage(),
                          ),
                        );
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
