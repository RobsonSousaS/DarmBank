import 'package:bank_darm/Imports/imports.dart';

class ListCliPage extends StatefulWidget {
  @override
  _ListCliPageState createState() => _ListCliPageState();
}

class _ListCliPageState extends State<ListCliPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Clientes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return ClientsWidget();
        },
      ),
    );
  }
}
