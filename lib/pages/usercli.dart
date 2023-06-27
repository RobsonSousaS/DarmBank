import 'package:bank_darm/pages/imports.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Usuário',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              // Lógica para adicionar foto do usuário
            },
            child: Container(
              height: 200,
              width: double.infinity,
              child: Center(
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey[600],
                  child: Icon(
                    Icons.photo,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                // Lógica para mudar o avatar
              },
              child: Text('Mudar Avatar'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Alterar Senha'),
            onTap: () {
              // Lógica para alterar senha
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Apagar Conta'),
            onTap: () {
              // Lógica para apagar conta
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sair Conta'),
            onTap: () {
              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Loginsignuppage()),
                  );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.credit_card),
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CardPage()),
                  );
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
