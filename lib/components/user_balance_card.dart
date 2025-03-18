import 'package:flutter/material.dart';

const Color kTeal = Color(0xFF004D61);
const Color kWhite = Color(0xFFFFFFFF);

class UserBalanceCard extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserBalanceCard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        decoration: BoxDecoration(
          color: kTeal,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          clipBehavior:
              Clip.none, 
          children: [
            Positioned(
              top: -20,
              left: -20,
              child: Image.asset(
                'assets/images/balanceCardTop.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              bottom: -20,
              right: -20,
              child: Image.asset(
                'assets/images/balanceCardBottom.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: -20,
              left: 10,
              child: Image.asset(
                'assets/images/balanceCardTop.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: Image.asset(
                'assets/images/porco.png',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, ${userData["email"] ?? "Usuário"}',
                  style: const TextStyle(
                    color: kWhite,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'Quinta-feira, 08/09/2022',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Saldo',
                      style: TextStyle(color: kWhite, fontSize: 16),
                    ),
                    Icon(Icons.visibility, color: kWhite, size: 20),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.white.withOpacity(0.5),
                ),

                const SizedBox(height: 12),
                const Text(
                  'Conta Corrente',
                  style: TextStyle(color: kWhite, fontSize: 14),
                ),
                const SizedBox(height: 4),

                Text(
                  'R\$ ${userData["balance"] ?? "0,00"}',
                  style: const TextStyle(
                    color: kWhite,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 200),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
