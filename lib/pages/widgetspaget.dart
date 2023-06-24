import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TitleTextFieldWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;

  TitleTextFieldWidget({required this.title, required this.controller,});

  @override
  Widget build(BuildContext context) {
    EdgeInsets contentPadding = EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0);

    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 5,
        ),
        Text(
          title,
          style: GoogleFonts.karla(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
        SizedBox(height: 5.0),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            contentPadding: contentPadding,
          ),
        )
      ],
    );
  }
}

class RadioConta extends StatefulWidget {
  const RadioConta({Key? key}) : super(key: key);

  @override
  _RadioContaState createState() => _RadioContaState();
}
class _RadioContaState extends State<RadioConta> {
  int _selectedAccountType = 0;

  @override
  void initState() {
    super.initState();
    _selectedAccountType = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Text(
          'Selecione o tipo de conta:',
          style: GoogleFonts.karla(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Row(
              children: [
                Radio<int>(
                  value: 0,
                  groupValue: _selectedAccountType,
                  onChanged: (value) {
                    setState(() {
                      _selectedAccountType = value!;
                    });
                  },
                ),
                Text(
                  'Conta Corrente',
                  style: GoogleFonts.karla(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16),
            Row(
              children: [
                Radio<int>(
                  value: 1,
                  groupValue: _selectedAccountType,
                  onChanged: (value) {
                    setState(() {
                      _selectedAccountType = value!;
                    });
                  },
                ),
                Text(
                  'Conta Poupança',
                  style: GoogleFonts.karla(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}



class DropWidget extends StatefulWidget {
  const DropWidget({Key? key});

  @override
  State<DropWidget> createState() => _DropWidgetState();
}

class _DropWidgetState extends State<DropWidget> {
  String estadoSelecionado = 'AC';
  List<String> estados = [
    'AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT',
    'MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 8),
        Text(
          'Estado',
          style: GoogleFonts.karla(
            fontWeight: FontWeight.bold,
            fontSize: 13.0,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          height: 53.0,
          child: DropdownButtonFormField<String>(
            value: estadoSelecionado,
            onChanged: (String? newValue) {
              setState(() {
                estadoSelecionado = newValue!;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: estados.map((String estado) {
              return DropdownMenuItem<String>(
                value: estado,
                child: Text(estado, style: TextStyle(fontSize: 12.0),),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
