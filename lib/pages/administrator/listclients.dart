import 'package:bank_darm/Imports/imports.dart';

class ListCliPage extends StatefulWidget {
  @override
  _ListCliPageState createState() => _ListCliPageState();
}

class _ListCliPageState extends State<ListCliPage> {
  List<DocumentSnapshot> _filteredClients = [];
  bool _isFiltering = false;

  @override
  void initState() {
    super.initState();
    // Inicialmente, carregue todos os clientes
    _loadClients();
  }

  Future<void> _loadClients() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      print('Total de documentos encontrados: ${querySnapshot.size}');

      List<DocumentSnapshot> filteredClients = [];

      for (DocumentSnapshot doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        print('Data in document: $data');

        if (data.containsKey('tipo de usuario') &&
            data['tipo de usuario'] == 'Cliente') {
          filteredClients.add(doc);
        }
      }

      setState(() {
        _filteredClients = filteredClients;
        _isFiltering = false;
      });

      print('Clientes filtrados: ${_filteredClients.length}');
    } catch (e) {
      print('Erro ao buscar os clientes: $e');
    }
  }

  void _filterClients(String state, int minCards, bool alphabeticalOrder) {
    setState(() {
      _isFiltering = true;
    });

    // Construa a query de filtro baseada nos parâmetros
    Query query = FirebaseFirestore.instance.collection('users');

    if (state.isNotEmpty) {
      query = query.where('state', isEqualTo: state);
    }

    if (minCards > 0) {
      query = query.where('cardCount', isGreaterThanOrEqualTo: minCards);
    }

    if (alphabeticalOrder) {
      query = query.orderBy('name');
    }

    query.get().then((querySnapshot) {
      setState(() {
        _filteredClients = querySnapshot.docs;
        _isFiltering = false;
      });
    }).catchError((error) {
      print('Erro ao aplicar filtro: $error');
      setState(() {
        _isFiltering = false;
      });
    });
  }

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
      body: _isFiltering
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
  itemCount: _filteredClients.length,
  itemBuilder: (context, index) {
    final client = _filteredClients[index];
    print('Cliente: $client');
    
    if (client != null) {
      final clientData = client.data() as Map<String, dynamic>?;

      if (clientData != null && clientData.containsKey('name') && clientData.containsKey('state')) {
        final name = clientData['name'];
        final state = clientData['state'];

        return ListTile(
          title: Text(name),
          subtitle: Text(state),
          onTap: () {
            // Navegar para a página de detalhes do cliente quando clicado
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClientDetailsPage(client: client),
              ),
            );
          },
        );
      } else {
        print('Cliente não tem os campos "name" e "state".');
        return SizedBox(); // Retornar um widget vazio se os campos não estiverem presentes
      }
    } else {
      print('Cliente é nulo.');
      return SizedBox(); // Retornar um widget vazio se o cliente for nulo
    }
  },
),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Abrir o filtro de pesquisa
          _showFilterDialog();
        },
        child: Icon(Icons.filter_list),
      ),
    );
  }

  // Diálogo de filtro
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(
          onFilter: _filterClients,
        );
      },
    );
  }
}

class ClientDetailsPage extends StatelessWidget {
  final DocumentSnapshot client;

  ClientDetailsPage({required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Cliente'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Nome: ${client['name']}'),
            Text('Estado: ${client['state']}'),
            // Adicione mais detalhes do cliente aqui...
          ],
        ),
      ),
    );
  }
}

class FilterDialog extends StatefulWidget {
  final Function(String, int, bool) onFilter;

  FilterDialog({required this.onFilter});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String _selectedState = '';
  int _minCards = 0;
  bool _alphabeticalOrder = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filtrar Clientes'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: _selectedState,
            hint: Text('Selecione um estado'),
            onChanged: (String? newValue) {
              setState(() {
                _selectedState = newValue!;
              });
            },
            items: ['SP', 'RJ', 'MG', 'RS'] // Adicione mais estados aqui...
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _minCards = int.tryParse(value) ?? 0;
              });
            },
            decoration: InputDecoration(
              labelText: 'Mínimo de Cartões',
            ),
          ),
          SizedBox(height: 16),
          CheckboxListTile(
            value: _alphabeticalOrder,
            onChanged: (value) {
              setState(() {
                _alphabeticalOrder = value!;
              });
            },
            title: Text('Ordenar em Ordem Alfabética'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            widget.onFilter(_selectedState, _minCards, _alphabeticalOrder);
            Navigator.of(context).pop();
          },
          child: Text('Filtrar'),
        ),
      ],
    );
  }
}
