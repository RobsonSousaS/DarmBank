import 'package:bank_darm/Imports/imports.dart';
import 'package:bank_darm/routers/routers.dart';

class Forgotpasspage extends StatefulWidget {
  const Forgotpasspage({Key? key}) : super(key: key);

  @override
  State<Forgotpasspage> createState() => _ForgotpasspageState();
}

class _ForgotpasspageState extends State<Forgotpasspage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();

  Future<void> resetPassword() async {
  try {
    String email = _emailController.text;
    String nome = _nomeController.text;
    String cpf = _cpfController.text;

    // Verifique se todos os campos estão preenchidos
    if (email.isEmpty || nome.isEmpty || cpf.isEmpty) {
      // Exiba uma mensagem de erro ou faça o tratamento necessário para campos não preenchidos
      return;
    }

    // Verifique se o usuário existe
    final signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    if (!signInMethods.contains('password')) {
      throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Usuário não encontrado. Verifique as informações fornecidas.');
    }

    // Envie o e-mail de redefinição de senha para o usuário
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    // Exiba uma mensagem de sucesso ou faça o tratamento necessário
    print('E-mail de redefinição de senha enviado com sucesso para $email');
    routers.go('/passwordmessag');
  } catch (e) {
    // Trate o erro de redefinição de senha conforme necessário
    if (e is FirebaseAuthException) {
      print('Erro ao redefinir senha: ${e.code} - ${e.message}');
    } else {
      print('Erro ao redefinir senha: $e');
    }
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
            leading: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                routers.go('/login');
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    'Esqueceu sua senha?',
                    style: GoogleFonts.karla(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: const Color.fromARGB(255, 0, 102, 246),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Insira as informações abaixo para recuperar sua senha.',
                    style: GoogleFonts.karla(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  TitleTextFieldWidget(
                    title: 'E-mail',
                    controller: _emailController,
                    width: 400,
                    obscureText: false,
                  ),
                  const SizedBox(height: 10.0),
                  TitleTextFieldWidget(
                    title: 'Nome Completo',
                    controller: _nomeController,
                    width: 400,
                    obscureText: false,
                  ),
                  const SizedBox(height: 10.0),
                  TitleTextFieldWidget(
                    title: 'CPF',
                    controller: _cpfController,
                    width: 400,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                  ),
                  const SizedBox(
                    height: 260.0,
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        resetPassword();
                      },
                      child: Center(
                        child: Text(
                          'RECUPERE SUA SENHA',
                          style: GoogleFonts.karla(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                              horizontal: 60.0, vertical: 14.0),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF0066F6),
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

class ForgotpassMessage extends StatelessWidget {
  const ForgotpassMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.email,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              const Text(
                'Uma mensagem foi enviada para o seu email, por favor verifique',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  routers.go('/login');
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
                    const EdgeInsets.symmetric(horizontal: 60.0, vertical: 14.0),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xFF0066F6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
