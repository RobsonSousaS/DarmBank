import 'package:bank_darm/Imports/imports.dart';
import 'package:bank_darm/pages/createnewcard.dart';

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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateNewcardPage(),
      ),
    );
  }
}

class _CardPageState extends State<CardPage> {
  int _currentIndex = 0;
  String cardNumber = '';

  @override
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

                print('Cartão $index - Tipo: $cardType, Número: $cardNumber');

                return CardsWidget(
                  cardType: cardType,
                  cardNumber: cardNumber,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserPage()),
                  );
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

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchCardData() async {
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
