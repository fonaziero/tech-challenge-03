import 'package:bytebank/components/transaction_history.dart';
import 'package:bytebank/components/transaction_section.dart';
import 'package:bytebank/components/user_balance_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

const Color kTeal = Color(0xFF004D61);
const Color kWhite = Color(0xFFFFFFFF);
const Color kGrayLight = Color(0xFFCBCBCB);
const Color kGreen = Color(0xFF47A138);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kTeal,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: kWhite),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle, color: kWhite),
            onSelected: (value) {
              if (value == 'perfil') {
                _navigateToProfile();
              } else if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'perfil',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Perfil"),
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text("Logout"),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.green.shade50,
          child: Column(
            children: [
              const SizedBox(height: 20),
              ListTile(
                title: const Text(
                  'Início',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Divider(color: kGreen, thickness: 1),
              ListTile(
                title: const Text('Transferências'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Investimentos'),
                onTap: () {},
              ),
              const Divider(color: kGreen, thickness: 1),
              ListTile(
                title: const Text('Outros serviços'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data == null) {
              return const Center(child: Text("Erro ao carregar os dados."));
            }

            final userData = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                UserBalanceCard(userData: userData),
                TransactionSection(refreshTransactions: _refreshTransactions),
                TransactionHistory(refreshUI: _refreshTransactions),
              ],
            );
          },
        ),
      ),
    );
  }

  void _refreshTransactions() {
    setState(() {});
  }

  void _navigateToProfile() {
    debugPrint("Navegar para a página de perfil.");
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    debugPrint("Usuário deslogado.");
  }

  Future<Map<String, dynamic>?> _fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      debugPrint('UID do usuário é nulo.');
      return null;
    }

    try {
      final ref = FirebaseDatabase.instance.ref('users/$uid');
      final snapshot = await ref.get();

      if (snapshot.exists && snapshot.value != null) {
        debugPrint('Dados recebidos: ${snapshot.value}');
        return Map<String, dynamic>.from(snapshot.value as Map);
      } else {
        debugPrint('Dados não encontrados no Firebase.');
        return null;
      }
    } catch (e) {
      debugPrint('Erro ao buscar usuário: $e');
      return null;
    }
  }
}
