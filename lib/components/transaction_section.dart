import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

const Color kTeal = Color(0xFF004D61);
const Color kGrayLight = Color(0xFFCBCBCB);

class TransactionSection extends StatefulWidget {
  final VoidCallback refreshTransactions;

  const TransactionSection({super.key, required this.refreshTransactions});

  @override
  _TransactionSectionState createState() => _TransactionSectionState();
}

class _TransactionSectionState extends State<TransactionSection> {
  final TextEditingController _valueController = TextEditingController();
  String? _selectedTransactionType;
  final List<String> _transactionTypes = [
    "Depósito",
    "Doações",
    "Pix",
    "Crédito",
  ];

  Future<void> _saveTransaction() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint("Erro: Usuário não está autenticado.");
      return;
    }

    double? transactionValue = double.tryParse(_valueController.text);
    if (_selectedTransactionType == null || transactionValue == null) {
      debugPrint("Erro: Preencha todos os campos.");
      return;
    }

    final userRef = FirebaseDatabase.instance.ref('users/${user.uid}');
    final transactionRef = FirebaseDatabase.instance.ref("transactionalHistory");

    try {
      final snapshot = await userRef.child('balance').get();
      double currentBalance =
          (snapshot.exists && snapshot.value != null)
              ? double.parse(snapshot.value.toString())
              : 0.0;

      double newBalance = currentBalance + transactionValue;

      final newTransaction = {
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "userId": user.uid,
        "type": _selectedTransactionType,
        "method": "DOC/TED",
        "value": transactionValue,
        "date": DateTime.now().toIso8601String(),
      };

      await transactionRef.push().set(newTransaction);

      await userRef.update({"balance": newBalance});

      debugPrint("Transação salva e saldo atualizado!");

      _valueController.clear();

      widget.refreshTransactions();
    } catch (e) {
      debugPrint("Erro ao salvar transação ou atualizar saldo: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kGrayLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                'assets/images/transactionCardTop.png',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                'assets/images/transactionCardBottom.png',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              bottom: -10,
              left: 0,
              child: Image.asset(
                'assets/images/cartao.png',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nova transação',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 50),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black45),
                    color: Colors.white,
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    underline: const SizedBox(),
                    hint: const Text("Selecione o tipo de transação"),
                    value: _selectedTransactionType,
                    items: _transactionTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTransactionType = value;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 50),

                const Text(
                  'Valor',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black45),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: _valueController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "00,00",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),

                const SizedBox(height: 50),

                // Botão de concluir transação
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kTeal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    onPressed: _saveTransaction,
                    child: const Text(
                      'Concluir transação',
                      style: TextStyle(color: Colors.white),
                    ),
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
