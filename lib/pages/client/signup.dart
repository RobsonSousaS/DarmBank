import 'package:bank_darm/Imports/imports.dart';
import 'package:bank_darm/routers/routers.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _cellController = TextEditingController();
  final _endeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passworddnvController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController tipoContaController = TextEditingController();
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
            padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    'Crie sua conta',
                    style: GoogleFonts.karla(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Color.fromARGB(255, 0, 102, 246),
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    'Abra uma conta no DarmBank com alguns detalhes.',
                    style: GoogleFonts.karla(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  TitleTextFieldWidget(
                    title: 'Nome completo',
                    controller: _nomeController,
                    width: maxWidth,
                    obscureText: false,
                  ),
                  TitleTextFieldWidget(
                    title: 'E-mail',
                    controller: _emailController,
                    width: maxWidth,
                    obscureText: false,
                  ),
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
                    title: 'Telefone',
                    controller: _cellController,
                    width: maxWidth,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                  ),
                  Row(
                    children: [
                      TitleTextFieldWidget(
                        title: 'Endereço',
                        controller: _endeController,
                        width: 250,
                        obscureText: false,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      EstadoDropdownWidget(estadoController: estadoController)
                    ],
                  ),
                  TipoContaDropdownWidget(
                    tipoContaController: tipoContaController,
                  ),
                  TitleTextFieldWidget(
                    title: 'Senha',
                    controller: _passwordController,
                    width: maxWidth,
                    obscureText: true,
                  ),
                  TitleTextFieldWidget(
                    title: 'Confirmar senha',
                    controller: _passworddnvController,
                    width: maxWidth,
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        createAccount();
                      },
                      child: Center(
                        child: Text(
                          'CRIAR SUA CONTA',
                          style: GoogleFonts.karla(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                            horizontal: 60.0,
                            vertical: 14.0,
                          ),
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
                        'Você já tem uma conta no DarmBank?',
                        style: GoogleFonts.karla(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          routers.go("/login");
                        },
                        child: Text(
                          'Faça login aqui',
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

  Future<void> createAccount() async {
    try {
      
      String password = _passwordController.text;

   
      String email = _emailController.text;
      String nome = _nomeController.text;
      String cpf = _cpfController.text;
      String telefone = _cellController.text;
      String endereco = _endeController.text;
      String estado = estadoController.text;
      String tipoConta = tipoContaController.text;

      
      if (password != _passworddnvController.text) {
        
        return;
      }

     
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

     
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'nome': nome,
        'email': email,
        'cpf': cpf,
        'telefone': telefone,
        'endereco': endereco,
        'tipoConta': tipoConta,
        'estado': estado,
        'tipo de usuario': 'Cliente',
      });
       routers.go("/createcard");
      
    } 
    catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
         
        } else {
          
        }
      } else {
        
      }
      print('Erro ao criar conta: $e');
    }
  }
}
