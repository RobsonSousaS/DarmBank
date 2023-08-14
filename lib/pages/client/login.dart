import 'package:bank_darm/Imports/imports.dart';
import 'package:bank_darm/routers/routers.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final double maxWidth = 700;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                routers.go('/loginorsignup');
              },
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    'Entre na sua',
                    style: GoogleFonts.karla(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Color.fromARGB(255, 0, 102, 246)),
                  ),
                  Text(
                    'conta',
                    style: GoogleFonts.karla(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Color.fromARGB(255, 0, 102, 246)),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Faça login na sua conta DarmBank',
                    style: GoogleFonts.karla(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 60.0),
                  TitleTextFieldWidget(
                    title: 'CPF',
                    controller: _cpfController,
                    width: maxWidth,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                  ),
                  TitleTextFieldWidget(
                    title: 'Senha',
                    controller: _passwordController,
                    width: maxWidth,
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Esqueceu sua senha?',
                        style: GoogleFonts.karla(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          routers.go('/resetpassword');
                        },
                        child: Text(
                          'clique aqui para recuperá-la',
                          style: GoogleFonts.karla(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 170,
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        loginWithCPF();
                      },
                      child: Center(
                        child: Text(
                          'LOGAR',
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
                  Row(
                    children: [
                      Text(
                        'Você não tem uma conta no DarmBank?',
                        style: GoogleFonts.karla(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          routers.go('/signup');
                        },
                        child: Text(
                          'Se cadastre aqui',
                          style: GoogleFonts.karla(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loginWithCPF() async {
  String cpf = _cpfController.text;
  String password = _passwordController.text;

  try {
    String email = await getEmailFromCPF(cpf);

    
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

  
    if (userCredential.user != null) {
      
      String userId = userCredential.user!.uid;
      bool isAdmin = await checkIfUserIsAdmin(userId);

      if (isAdmin) {
       
        routers.go('/listcli');
      } else {
        
        bool hasCards = await checkIfUserHasCards(userId);

        if (hasCards) {
          
          routers.go('/listcards');
        } else {
          
          routers.go('/createcard');
        }
      }
    } else {
      
      print('Login falhou');
    }
  } catch (e) {
    
    print('Erro de login: $e');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Erro de login'),
          content: Text(
            'Senha ou CPF estão incorretos. Verifique suas credenciais.',
          ),
        );
      },
    );
    if (e is Exception) {
      print(e.toString());
    } else {
      print('Erro desconhecido: $e');
    }
  }
}

  Future<String> getEmailFromCPF(String cpf) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot =
        await firestore.collection('users').where('cpf', isEqualTo: cpf).get();

    if (querySnapshot.docs.isNotEmpty) {
      var data = querySnapshot.docs[0].data();
      if (data != null &&
          data is Map<String, dynamic> &&
          data['email'] != null) {
        return data['email'] as String; 
      } else {
        throw Exception('Email not found');
      }
    } else {
      throw Exception('CPF not found');
    }
  }
}

Future<bool> checkIfUserHasCards(String userId) async {
  try {
    
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    
    CollectionReference cardsCollection =
        firestore.collection('users').doc(userId).collection('cards');

    
    QuerySnapshot querySnapshot = await cardsCollection.limit(1).get();

    
    return querySnapshot.size > 0;
  } catch (e) {
    
    print('Erro ao verificar se o usuário possui cartões: $e');
    return false;
  }
}

Future<bool> checkIfUserIsAdmin(String userId) async {
  try {
    
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(userId).get();

    
    if (userDoc.exists && userDoc['tipo de usuario'] == 'Administrador') {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    
    print('Erro ao verificar o tipo de usuário: $e');
    return false;
  }
}