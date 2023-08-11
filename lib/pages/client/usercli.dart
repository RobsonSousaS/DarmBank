import 'package:bank_darm/Imports/imports.dart';
import 'package:bank_darm/routers/routers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; // Importe o pacote path_provider
import 'dart:io'; // Importe o pacote dart:io


class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  File? _pickedImage;
  int _atualIndex = 1;

  Future<void> _pickAndSaveImage() async {
    final pickedImage = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      final pickedImageFile = File(pickedImage.path);

      try {
        await _saveImageToDevice(pickedImageFile);

        setState(() {
          _pickedImage = pickedImageFile;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Imagem Salva'),
              content: Text('A imagem foi salva no dispositivo.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Erro ao salvar a imagem: $e');
      }
    }
  }

  Future<void> _saveImageToDevice(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/user_avatar.jpg';
      await imageFile.copy(imagePath);
    } catch (e) {
      throw Exception('Erro ao salvar a imagem: $e');
    }
  }

  Widget _buildCircleAvatar() {
    if (_pickedImage != null) {
      return CircleAvatar(
        radius: 80,
        backgroundColor: Colors.grey[600],
        backgroundImage: FileImage(_pickedImage!),
        child: Icon(
          Icons.photo,
          size: 80,
          color: Colors.white,
        ),
      );
    } else {
      return CircleAvatar(
        radius: 80,
        backgroundColor: Colors.grey[600],
        backgroundImage: NetworkImage(
          // Substitua pelo URL da imagem atual do usuário ou por uma imagem padrão
          'https://example.com/your-default-image.jpg',
        ),
        child: Icon(
          Icons.photo,
          size: 80,
          color: Colors.white,
        ),
      );
    }
  }

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
            onTap: () {},
            child: Container(
              height: 200,
              width: double.infinity,
              child: Center(
                child: _buildCircleAvatar(),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              onPressed: _pickAndSaveImage,
              child: Text('Mudar Avatar'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Alterar Senha'),
            onTap: () {
              _sendPasswordResetEmail(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Apagar Conta'),
            onTap: () {
              _deleteAccount(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sair Conta'),
            onTap: () {
              _signOut(context);
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
                  _atualIndex = 0;
                  routers.go('/listcards');
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                setState(() {
                  _atualIndex = 1;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

void _sendPasswordResetEmail(BuildContext context) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final email =
          user.email ?? ''; // Use um valor padrão vazio se o email for nulo

      // Solicita ao Firebase para enviar um e-mail de redefinição de senha para o e-mail do usuário
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Exibe um diálogo informando que o e-mail foi enviado
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('E-mail Enviado'),
            content: Text(
                'Um e-mail de redefinição de senha foi enviado para o seu endereço de e-mail. Siga as instruções no e-mail para redefinir sua senha.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    // Trata qualquer erro que possa ocorrer ao enviar o e-mail
    print('Erro ao enviar o e-mail de redefinição de senha: $e');
    // Exibe um diálogo de erro
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro'),
          content: Text(
              'Ocorreu um erro ao enviar o e-mail de redefinição de senha. Tente novamente mais tarde.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

void _deleteAccount(BuildContext context) async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid; // Obtém o ID do usuário
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      // Obtém a lista de IDs dos cartões associados a esse usuário
      final userDocSnapshot = await userDocRef.get();
      final cardIds = userDocSnapshot.get('cardIds') as List<dynamic>;

      // Exclui cada cartão da subcoleção 'cards'
      for (final cardId in cardIds) {
        final cardDocRef = userDocRef.collection('cards').doc(cardId);
        await cardDocRef.delete();
      }

      // Exclui os dados do usuário do Firestore
      await userDocRef.delete();

      // Solicita ao Firebase para deletar a conta do usuário
      await user.delete();

      // Exibe um diálogo informando que a conta foi excluída
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Conta Excluída'),
            content: Text(
                'Sua conta e os cartões associados foram excluídos com sucesso.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      // Redireciona o usuário para a tela de login ou signup
      routers.go('/loginorsignup');
    }
  } catch (e) {
    // Trata qualquer erro que possa ocorrer ao deletar a conta
    print('Erro ao excluir a conta: $e');
    // Exibe um diálogo de erro
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro'),
          content: Text(
              'Ocorreu um erro ao excluir a conta. Tente novamente mais tarde.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

void _signOut(BuildContext context) {
  try {
    // Faz logout do usuário usando o FirebaseAuth
    FirebaseAuth.instance.signOut();

    // Exibe um diálogo informando que o logout foi realizado
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Realizado'),
          content: Text('Você foi desconectado da sua conta.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    // Redireciona o usuário para a tela de login ou signup
    routers.go('/loginorsignup');
  } catch (e) {
    // Trata qualquer erro que possa ocorrer ao fazer logout
    print('Erro ao fazer logout: $e');
    // Exibe um diálogo de erro
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro'),
          content: Text(
              'Ocorreu um erro ao fazer logout. Tente novamente mais tarde.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
