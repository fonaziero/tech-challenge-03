import 'package:bytebank/components/abrir_conta_dialog.dart';
import 'package:bytebank/components/login.dart';
import 'package:bytebank/firebase_options.dart';
import 'package:bytebank/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(BytebankApp());
}

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.interTextTheme()),
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(), 
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return BytebankHomePage();
        }
      },
    );
  }
}

const Color kBlack = Color(0xFF000000);
const Color kGreen = Color(0xFF47A138);
const Color kTeal = Color(0xFF004D61);
const Color kWhite = Color(0xFFFFFFFF);
const Color kGraw = Color(0xFF767676);

const double titleSize = 25;

class BytebankHomePage extends StatefulWidget {
  const BytebankHomePage({Key? key}) : super(key: key);

  @override
  State<BytebankHomePage> createState() => _BytebankHomePageState();
}

class _BytebankHomePageState extends State<BytebankHomePage> {
  bool _termosAceitos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: kGreen),
              child: Text(
                'Menu Bytebank',
                style: TextStyle(color: kWhite, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Sobre'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.miscellaneous_services),
              title: Text('Serviço'),
              onTap: () {
                Navigator.pop(context); 
              },
            ),
          ],
        ),
      ),
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kBlack,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: kGreen),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [Image.asset('../assets/images/Logo.png')],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_buildHeroSection(), _buildFooter()],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        Container(
          height: 700,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [kTeal, kWhite],
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
                Text(
                  'Experimente mais liberdade no controle da sua vida financeira. Crie sua conta com a gente!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kBlack,
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Image.asset('../assets/images/ilustracao_banner.png'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _abrirModalCadastro(context);
                      },
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
                      onPressed: () {
                        _abrirModalLogin(context);
                      },
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
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Vantagens do nosso banco:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kBlack,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildFeature(
                        '../assets/images/icone_presente.png',
                        'Conta e cartão gratuitos',
                        'Isso mesmo, nossa conta é digital, sem custo fixo e mais: o saque é sem tarifa de manutenção.',
                      ),
                      _buildFeature(
                        '../assets/images/icone_saque.png',
                        'Saques sem custo',
                        'Você pode sacar gratuitamente 4x por mês de qualquer Banco 24h.',
                      ),
                      _buildFeature(
                        '../assets/images/icone_pontos.png',
                        'Programa de pontos',
                        'Você pode acumular pontos com suas compras no crédito sem pagar mensalidade!',
                      ),
                      _buildFeature(
                        '../assets/images/icone_dispositivos.png',
                        'Seguro Dispositivos',
                        'Seus dispositivos móveis protegidos por uma mensalidade simbólica.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _abrirModalCadastro(BuildContext context) {
    showDialog(context: context, builder: (context) => AbrirContaDialog());
  }

  void _abrirModalLogin(BuildContext context) {
    showDialog(context: context, builder: (context) => LoginDialog());
  }

  Widget _buildFeature(String imagePath, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 80, height: 80),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kBlack,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: kGraw),
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
            style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text('Conta corrente', style: TextStyle(color: kWhite)),
          Text('Conta PJ', style: TextStyle(color: kWhite)),
          Text('Cartão de crédito', style: TextStyle(color: kWhite)),
          const SizedBox(height: 20),
          Text(
            'Contato',
            style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
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
