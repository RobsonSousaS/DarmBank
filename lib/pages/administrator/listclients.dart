import 'package:bank_darm/Imports/imports.dart';
import 'package:bank_darm/routers/routers.dart';

class ListCliPage extends StatefulWidget {
  @override
  _ListCliPageState createState() => _ListCliPageState();
}

class _ListCliPageState extends State<ListCliPage> {
  List<DocumentSnapshot> _filteredClients = [];
  bool _isFiltering = false;
  String _selectedState = '';
  int _selectedCardCount = 1;
  bool _alphabeticalOrder = false;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    try {
      
      Query query = FirebaseFirestore.instance.collection('users');

      
      query = query.where('tipo de usuario', isEqualTo: 'Cliente');

     
      if (_selectedState.isNotEmpty) {
        query = query.where('estado', isEqualTo: _selectedState);
      }

       
    if (_selectedCardCount > 1) {
      query = query.where('numero de cartoes', isEqualTo: _selectedCardCount);
    }

    if (_alphabeticalOrder) {
      query = query.orderBy('nome');
    }
      
      QuerySnapshot querySnapshot = await query.get();

      setState(() {
        _filteredClients = querySnapshot.docs;
        _isFiltering = false;
      });

      print('Clientes filtrados: ${_filteredClients.length}');
    } catch (e) {
      print('Erro ao buscar os clientes: $e');
    }
  }

  void _filterClients(String state, int selectedCardCount, bool alphabeticalOrder) {
    setState(() {
      _isFiltering = true;
    });

    
    Query query = FirebaseFirestore.instance.collection('users');

    if (state.isNotEmpty) {
      query = query.where('state', isEqualTo: state);
    }

    if (_selectedCardCount > 1) {
      query = query.where('cardCount', isGreaterThanOrEqualTo: _selectedCardCount);
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
    _selectedState = state;
    _selectedCardCount = selectedCardCount;
    _alphabeticalOrder = alphabeticalOrder;

    _loadClients();
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

                  if (clientData != null &&
                      clientData.containsKey('nome') &&
                      clientData.containsKey('estado')) {
                    final name = clientData['nome'];
                    final state = clientData['estado'];

                    return Container(
                      height: 90,
                      padding: EdgeInsets.all(16.0),
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Icon(Icons
                            .account_circle), 
                        title: Text(name),
                        subtitle: Text(state),
                        onTap: () {
                          
                        },
                      ),
                    );
                  } else {
                    print('Cliente não tem os campos "nome" e "estado".');
                    return SizedBox(); 
                  }
                } else {
                  print('Cliente é nulo.');
                  return SizedBox(); 
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          _showFilterDialog();
        },
        child: Icon(Icons.filter_list),
      ),
    );
  }

  
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

class FilterDialog extends StatefulWidget {
  final Function(String, int, bool) onFilter;

  FilterDialog({required this.onFilter});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String _selectedState = '';
  int _selectedCardCount = 1; 
  bool _alphabeticalOrder = false;

  
  final List<int> cardCountOptions = List.generate(6, (index) => index + 1);

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
            items: [
              '',
              'AC',
              'AL',
              'AP',
              'AM',
              'BA',
              'CE',
              'DF',
              'ES',
              'GO',
              'MA',
              'MT',
              'MS',
              'MG',
              'PA',
              'PB',
              'PR',
              'PE',
              'PI',
              'RJ',
              'RN',
              'RS',
              'RO',
              'RR',
              'SC',
              'SP',
              'SE',
              'TO',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          DropdownButton<int>(
            value: _selectedCardCount,
            hint: Text('Número de Cartões'),
            onChanged: (int? newValue) {
              setState(() {
                _selectedCardCount = newValue!;
              });
            },
            items: cardCountOptions.map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
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
          SizedBox(height: 16),
          Row(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _selectedState = ''; 
                  _selectedCardCount = 1; 
                  _alphabeticalOrder = false; 
                  widget.onFilter(
                      _selectedState, _selectedCardCount, _alphabeticalOrder);
                  Navigator.of(context).pop();
                },
                child: Text('Remover Filtro'),
              ),
            ],
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
        ElevatedButton(
          onPressed: () {
            widget.onFilter(
                _selectedState, _selectedCardCount, _alphabeticalOrder);
            Navigator.of(context).pop();
          },
          child: Text('Filtrar'),
        ),
      ],
    );
  }
}
