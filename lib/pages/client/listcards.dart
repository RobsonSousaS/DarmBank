import 'package:bank_darm/Imports/imports.dart';
import 'package:bank_darm/routers/routers.dart';

class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() => _CardPageState();
}

Future<void> _handleAddCardButton(BuildContext context) async {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> cardSnapshots =
      await fetchCardData();
  if (cardSnapshots.length >= 6) {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Limite de Cartões Atingido'),
        content: Text('Você só pode criar no máximo 6 cartões.'),
      ),
    );
  } else {
    routers.go('/createnewcard');
  }
}

class _CardPageState extends State<CardPage> {
  int _currentIndex = 0;
  String cardNumber = '';
  List<Map<String, dynamic>> cardSnapshots = [];

  @override
  void initState() {
    super.initState();
    _loadCardData();
  }

  Future<void> _loadCardData() async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots =
        await fetchCardData();
    setState(() {
      cardSnapshots = snapshots.map((snapshot) => snapshot.data()).toList();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meus Cartões',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
        future: fetchCardData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar os cartões'),
            );
          } else if (snapshot.hasData) {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> cardSnapshots =
                snapshot.data!;

            print('Número de cartões: ${cardSnapshots.length}');

            return ListView.builder(
              itemCount: cardSnapshots.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> cardData = cardSnapshots[index].data();
                String cardType = cardData['cardType']?.toString() ?? '';
                String cardNumber = cardData['cardNumber']?.toString() ?? '';
                String cardId = cardSnapshots[index]
                    .id;

                return CardsWidget(
                  cardType: cardType,
                  cardNumber: cardNumber,
                  cardId: cardId,
                );
              },
            );
          } else {
            return Center(
              child: Text('Nenhum cartão encontrado'),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.credit_card),
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                  routers.go('/usercli');
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Theme(
        data: ThemeData(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.white,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () => _handleAddCardButton(context),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
    fetchCardData() async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    String userId = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> cardsCollection =
        firestore.collection('users').doc(userId).collection('cards');

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await cardsCollection.get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> cardSnapshots =
        querySnapshot.docs;

    return cardSnapshots;
  } catch (e) {
    print('Erro ao buscar os cartões: $e');
    return []; 
  }
}

class CardDetailsPage extends StatelessWidget {
  final String cardId;

  CardDetailsPage({required this.cardId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Cartão'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            routers.go('/listcards');
          },
        ),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: fetchCardDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar os detalhes do cartão'),
            );
          } else if (snapshot.hasData) {
            Map<String, dynamic>? cardData = snapshot.data?.data();

            if (cardData == null) {
              return Center(
                child: Text('Detalhes do cartão não encontrados'),
              );
            }

            String cardNumber = cardData['cardNumber']?.toString() ?? '';
            String cardHolderName = cardData['cardHolderName']?.toString() ?? '';
            String expiryDate = cardData['expiryDate']?.toString() ?? '';
            String cardType = cardData['cardType']?.toString() ?? '';
            String cvc = cardData['cvc']?.toString() ?? '';
            String cardSelector = cardData['cardSelector']?.toString() ?? '';
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: 400,
                    child: CardWidget(
                      cardNumber: cardNumber,
                      cardHolderName: cardHolderName,
                      expiryDate: expiryDate,
                      nameCard: cardType,
                      cvc: cvc,
                      cardSelector: cardSelector,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Status da Solicitação',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CardStatus(status: 2),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _handleDeleteCardButton(context, cardId);
                    },
                    child: Center(
                      child: Text(
                        'DELETAR CARTÃO',
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
                ),
              ],
            );
          } else {
            return Center(
              child: Text('Nenhum cartão encontrado'),
            );
          }
        },
      ),
    );
  }

Future<void> _handleDeleteCardButton(BuildContext context, String cardId) async {
  try {
    await deleteCard(cardId);
    routers.go('/listcards');
  } catch (e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erro ao Deletar Cartão'),
        content: Text('Ocorreu um erro ao tentar deletar o cartão.'),
      ),
    );
  }
}

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchCardDetails() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String userId = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference<Map<String, dynamic>> cardRef = firestore
          .collection('users')
          .doc(userId)
          .collection('cards')
          .doc(cardId);

      DocumentSnapshot<Map<String, dynamic>> snapshot = await cardRef.get();

      return snapshot;
    } catch (e) {
      print('Erro ao buscar os detalhes do cartão: $e');
      throw e;
    }
  }
}


Future<void> deleteCard(cardId) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentReference<Map<String, dynamic>> cardRef = firestore
        .collection('users')
        .doc(userId)
        .collection('cards')
        .doc(cardId);

    await cardRef.delete();
  } catch (e) {
    print('Erro ao deletar o cartão: $e');
    throw e;
  }
}