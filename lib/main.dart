import 'package:flutter/material.dart';

void main() => runApp(BytebankApp());

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BytebankHomePage(),
    );
  }
}

// Definindo as cores base
const Color kBlack = Color(0xFF000000);
const Color kGreen = Color(0xFF47A138);
const Color kTeal  = Color(0xFF004D61);
const Color kWhite = Color(0xFFFFFFFF);

class BytebankHomePage extends StatelessWidget {
  const BytebankHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kBlack,
        title: Row(
          children: [
            Icon(Icons.account_balance, color: kGreen),
            const SizedBox(width: 8),
            Text(
              'Bytebank',
              style: TextStyle(color: kGreen),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: kWhite),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Seção HERO (topo) com gradiente e wave
            _buildHeroSection(),

            // Vantagens do banco
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vantagens do nosso banco:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kBlack,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFeature(
                    Icons.card_giftcard,
                    'Conta e cartão gratuitos',
                    'Isso mesmo, nossa conta é digital, sem custo fixo e mais: o saque é sem tarifa de manutenção.',
                  ),
                  _buildFeature(
                    Icons.money_off,
                    'Saques sem custo',
                    'Você pode sacar gratuitamente 4x por mês de qualquer Banco 24h.',
                  ),
                  _buildFeature(
                    Icons.star,
                    'Programa de pontos',
                    'Você pode acumular pontos com suas compras no crédito sem pagar mensalidade!',
                  ),
                  _buildFeature(
                    Icons.security,
                    'Seguro Dispositivos',
                    'Seus dispositivos móveis protegidos por uma mensalidade simbólica.',
                  ),
                ],
              ),
            ),

            // Rodapé preto
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        // Fundo em gradiente
        Container(
          height: 340,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                kTeal,
                kGreen,
              ],
            ),
          ),
        ),
        // Onda branca na parte de baixo
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 50,
              color: kWhite,
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                // Texto principal
                Text(
                  'Experimente mais liberdade no controle da sua vida financeira.\nCrie sua conta com a gente!',
                  style: TextStyle(
                    color: kWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // Botões de ação
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kBlack,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Abrir conta',
                        style: TextStyle(color: kWhite),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: kBlack),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Já tenho conta',
                        style: TextStyle(color: kBlack),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeature(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kGreen, size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kBlack,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: kBlack,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Serviços',
            style: TextStyle(
              color: kWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text('Conta corrente', style: TextStyle(color: kWhite)),
          Text('Conta PJ', style: TextStyle(color: kWhite)),
          Text('Cartão de crédito', style: TextStyle(color: kWhite)),
          const SizedBox(height: 20),
          Text(
            'Contato',
            style: TextStyle(
              color: kWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text('0800 004 256 08', style: TextStyle(color: kWhite)),
          Text('meajuda@bytebank.com.br', style: TextStyle(color: kWhite)),
          Text('ouvidoria@bytebank.com.br', style: TextStyle(color: kWhite)),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.facebook, color: kWhite),
              const SizedBox(width: 10),
              Icon(Icons.camera_alt, color: kWhite),
              const SizedBox(width: 10),
              Icon(Icons.youtube_searched_for, color: kWhite),
            ],
          ),
          const SizedBox(height: 20),
          Text('Desenvolvido por Alura', style: TextStyle(color: kWhite)),
        ],
      ),
    );
  }
}

// Clipper para criar a onda branca no final do topo
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 30);

    // Primeira curva
    var firstControlPoint = Offset(size.width * 0.25, size.height);
    var firstEndPoint = Offset(size.width * 0.5, size.height - 20);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Segunda curva
    var secondControlPoint = Offset(size.width * 0.75, size.height - 40);
    var secondEndPoint = Offset(size.width, size.height - 10);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
