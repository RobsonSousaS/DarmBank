import 'package:bank_darm/Imports/imports.dart';
import 'package:bank_darm/pages/client/createnewcard.dart';
import 'package:bank_darm/routers/routers.dart';

class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() => _CardPageState();
}

Future<void> _handleAddCardButton(BuildContext context) async {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> cardSnapshots =
      await fetchCardData();
  if (cardSnapshots.length >= 6) {
    // If the user has already reached the maximum limit of six cards, show the message popup
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Limite de Cartões Atingido'),
        content: Text('Você só pode criar no máximo 6 cartões.'),
      ),
    );
  } else {
    // If the user has not reached the limit yet, navigate to the CreatenewcardPage
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
                    .id; // Get the cardId from the QueryDocumentSnapshot

                return CardsWidget(
                  cardType: cardType,
                  cardNumber: cardNumber,
                  cardId: cardId, // Pass the cardId here
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
    // Obtenha a instância do Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Obtenha o ID do usuário atualmente autenticado
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Obtenha a referência para a coleção "cards" do usuário
    CollectionReference<Map<String, dynamic>> cardsCollection =
        firestore.collection('users').doc(userId).collection('cards');

    // Faça uma consulta para obter os documentos de cartão
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await cardsCollection.get();

    // Obtenha os documentos de cartão como uma lista de QueryDocumentSnapshot
    List<QueryDocumentSnapshot<Map<String, dynamic>>> cardSnapshots =
        querySnapshot.docs;

    return cardSnapshots;
  } catch (e) {
    // Trate o erro, se necessário
    print('Erro ao buscar os cartões: $e');
    return []; // Retorne uma lista vazia em caso de erro
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
        future: fetchCardDetails(), // Fetch the card details using the cardId
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
                      // Implement the delete card functionality here
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
