import 'package:bank_darm/Imports/imports.dart';

class CardsCliPage extends StatefulWidget {
  @override
  _CardsCliPageState createState() => _CardsCliPageState();
}

class _CardsCliPageState extends State<CardsCliPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cartões',
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
          return CardsCliWidget();
        },
      ),
    );
  }
}