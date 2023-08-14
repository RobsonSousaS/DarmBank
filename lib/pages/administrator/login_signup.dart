import 'package:bank_darm/Imports/imports.dart';
import 'package:bank_darm/routers/routers.dart';

class Loginsignuppageadm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 200.0,
                        width: 200.0, 
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Bem vindo ao DarmBank',
                        style: GoogleFonts.karla(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'O banco para todos',
                        style: GoogleFonts.karla(
                          fontWeight: FontWeight.w300,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 150.0),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    routers.go('/signup');
                  },
                  child: Text(
                    'CRIAR SUA CONTA GRATUITAMENTE',
                    style: GoogleFonts.karla(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 60.0, vertical: 14.0),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFF0066F6),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                InkWell(
                  onTap: () {
                     routers.go('/login');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 105.0,
                      vertical: 14.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        'LOGAR EM SUA CONTA',
                        style: GoogleFonts.karla(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
