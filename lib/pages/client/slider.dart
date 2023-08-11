import 'package:bank_darm/Imports/imports.dart';
import 'package:bank_darm/routers/routers.dart';

class SliderPage extends StatefulWidget {
  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  final List<String> imageList = [
    'assets/card.png',
    'assets/money.png',
    'assets/sprinkle.png',
  ];

  final List<String> titles = [
    'Economizar',
    'Retire seu dinheiro',
    'Invista seu dinheiro',
  ];

  final List<String> descriptions = [
    'Ajudamos você a atingir sua meta de economia mensalmente e nossos planos de emergência permitem que você economize para várias finalidades',
    'Com apenas o seu CPF, você pode retirar seus fundos a qualquer momento de qualquer agente do DarmBank perto de você.',
    'Tenha acesso a investimentos sem risco que irão multiplicar sua renda e pagar altos retornos em poucos meses',
  ];

  int currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 254, 254, 254),
      body: SafeArea(
        child: Stack(children: [
          PageView.builder(
            controller: _pageController,
            itemCount: imageList.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Alinhar ao centro
                    children: [
                      Image.asset(
                        imageList[index],
                        fit: index == 0 ? BoxFit.contain : BoxFit.cover,
                        height: index == 0 ? 345.0 : null,
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.start, // Alinhar ao centro
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              '',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            titles[index],
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.0),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.0),
                          child: Text(
                            descriptions[index],
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 16.0,
            right: 16.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: InkWell(
                onTap: () {
                routers.go('/loginorsignup');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Pular',
                    style: GoogleFonts.karla(
                      fontWeight: FontWeight.w300,
                      fontSize: 18.0,
                      textStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: imageList.length,
              effect: ExpandingDotsEffect(
                dotHeight: 10.0,
                dotWidth: 10.0,
                activeDotColor: Color(0xFF0066F6),
                dotColor: Colors.grey,
              ),
            ),
          ),
          Positioned(
            right: 16.0,
            bottom: 16.0,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  currentIndex = (currentIndex + 1) % imageList.length;
                  _pageController.animateToPage(
                    currentIndex,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );

                  if (currentIndex == imageList.length - 3) {
                    routers.go('/loginorsignup');
                  }
                });
              },
              child: Text('Próximo'),
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color(0xFF0066F6),
                ),
                textStyle: MaterialStateProperty.all<TextStyle>(
                  TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
