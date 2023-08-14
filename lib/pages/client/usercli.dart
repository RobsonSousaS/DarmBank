import 'package:bank_darm/Imports/imports.dart';
import 'package:bank_darm/routers/routers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  File? _pickedImage;
  int _atualIndex = 1;

  Future<void> _pickAndSaveImage() async {
  
  final status = await Permission.storage.request();

  if (status.isGranted) {
    try {
      

      
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage != null) {
        final pickedImageFile = File(pickedImage.path);

       
        await saveImageToDisk(pickedImageFile);

        
        await saveImageReferenceToFirestore(pickedImageFile);

        setState(() {
          _pickedImage = pickedImageFile;
        });
      }
    } catch (e) {
      print('Erro ao salvar a imagem: $e');
    }
  } else {
    
    print('Permissão de armazenamento negada.');
    
  }
}

Future<void> saveImageToDisk(File image) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = directory.path + '/your_image.png';
    await image.copy(imagePath);
    print('Imagem salva com sucesso em: $imagePath');
  } catch (e) {
    print('Erro ao salvar a imagem: $e');
  }
}

Future<void> saveImageReferenceToFirestore(File image) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid; 

      final userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);

     
      await userDocRef.update({
        'avatar': 'path/para/sua/imagem.png', 
      });
    }
  } catch (e) {
    
    print('Erro ao salvar a referência da imagem: $e');
  }
}


Future<void> _requestStoragePermission() async {
  final status = await Permission.storage.request();

  if (status.isGranted) {
    
  } else {
   
  }
}


  Widget _buildCircleAvatar() {
    if (_pickedImage != null) {
      return CircleAvatar(
        radius: 80,
        backgroundColor: Colors.grey[600],
        backgroundImage: FileImage(_pickedImage!));
    } else {
      return CircleAvatar(
        radius: 80,
        backgroundColor: Colors.grey[600],
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
          user.email ?? ''; 

     
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

     
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
    
    print('Erro ao enviar o e-mail de redefinição de senha: $e');
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
      final uid = user.uid; 
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      
      final userDocSnapshot = await userDocRef.get();
      final cardIds = userDocSnapshot.get('cardIds') as List<dynamic>;

     
      for (final cardId in cardIds) {
        final cardDocRef = userDocRef.collection('cards').doc(cardId);
        await cardDocRef.delete();
      }

      
      await userDocRef.delete();

     
      await user.delete();

      
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

      
      routers.go('/loginorsignup');
    }
  } catch (e) {
    
    print('Erro ao excluir a conta: $e');
    
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
    
    FirebaseAuth.instance.signOut();

    
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

    
    routers.go('/loginorsignup');
  } catch (e) {
    
    print('Erro ao fazer logout: $e');
    
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
