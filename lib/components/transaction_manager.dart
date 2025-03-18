import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:url_launcher/url_launcher.dart';

const Color kTeal = Color(0xFF004D61);
const Color kGreen = Color(0xFF47A138);

void openTransactionModal(
  BuildContext context,
  List<Map<String, dynamic>> transactions,
  VoidCallback refreshUI,
) {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredTransactions = List.from(transactions);

  showDialog(
    context: context,
    builder: (BuildContext context) {

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(16),
            contentPadding: EdgeInsets.zero,
            title: Column(
              children: [
                const Text("Gerenciar Transações"),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: "Buscar transações...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (query) {
                      setState(() {
                        filteredTransactions =
                            transactions
                                .where(
                                  (transaction) =>
                                      transaction["type"]
                                          .toLowerCase()
                                          .contains(query.toLowerCase()) ||
                                      transaction["date"]
                                          .toLowerCase()
                                          .contains(query.toLowerCase()),
                                )
                                .toList();
                      });
                    },
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 400,
              height: 400,
              child: SingleChildScrollView(
                child: Column(
                  children:
                      filteredTransactions.isEmpty
                          ? [
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text("Nenhuma transação encontrada."),
                            ),
                          ]
                          : filteredTransactions.map((transaction) {
                            return ListTile(
                              title: Text(
                                "${transaction["type"]} - R\$ ${transaction["value"]}",
                              ),
                              subtitle: Text(transaction["date"]),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: kTeal),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      editTransactionDialog(
                                        context,
                                        transaction,
                                        refreshUI,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      deleteTransaction(transaction, refreshUI);
                                    },
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

void editTransactionDialog(
  BuildContext context,
  Map<String, dynamic> transaction,
  VoidCallback refreshUI,
) {
  TextEditingController valueController = TextEditingController(
    text: transaction["value"].toString(),
  );
  String selectedType = transaction["type"];
  String? attachmentUrl = transaction["attachment"];

  print('transaction');
  print(transaction);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Editar Transação"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: selectedType,
              items:
                  [
                    "Empréstimo",
                    "Meus cartões",
                    "Doações",
                    "Pix",
                    "Seguros",
                    "Crédito celular",
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (value) {
                selectedType = value!;
              },
            ),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(labelText: "Valor"),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            if (attachmentUrl != null && attachmentUrl.isNotEmpty)
              kIsWeb
                  ? _openPdfWeb(attachmentUrl)
                  : _openPdfMobile(attachmentUrl), 
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              updateTransaction(
                transaction,
                selectedType,
                double.parse(valueController.text),
                refreshUI,
              );
              Navigator.pop(context);
            },
            child: const Text("Salvar"),
          ),
        ],
      );
    },
  );
}

Widget _openPdfWeb(String url) {
  return TextButton.icon(
    icon: const Icon(Icons.open_in_new, color: Colors.blue),
    label: const Text("Abrir Anexo"),
    onPressed: () async {
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Erro ao abrir o anexo.");
      }
    },
  );
}

Widget _openPdfMobile(String url) {
  return SizedBox(height: 400, child: PDFView(filePath: url));
}

void updateTransaction(
  Map<String, dynamic> transaction,
  String newType,
  double newValue,
  VoidCallback refreshUI,
) async {
  final ref = FirebaseDatabase.instance.ref("transactionalHistory");

  try {
    final snapshot = await ref.get();
    if (!snapshot.exists || snapshot.value == null) {
      debugPrint("Erro: Nenhuma transação encontrada no Firebase.");
      return;
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    String? transactionKey;

    data.forEach((key, value) {
      if (value is Map && value["id"] == transaction["id"]) {
        transactionKey = key;
      }
    });

    if (transactionKey == null) {
      debugPrint("Erro: Transação não encontrada.");
      return;
    }

    double oldValue = double.tryParse(transaction["value"].toString()) ?? 0.0;
    double diff = newValue - oldValue;

    await ref.child(transactionKey!).update({
      "type": newType,
      "value": newValue,
    });

    if (transaction["userId"] != null) {
      await _updateUserBalance(transaction["userId"], diff);
    }

    debugPrint("Transação atualizada com sucesso!");
    refreshUI();
  } catch (e) {
    debugPrint("Erro ao atualizar transação: $e");
  }
}

void deleteTransaction(
  Map<String, dynamic> transaction,
  VoidCallback refreshUI,
) async {
  final ref = FirebaseDatabase.instance.ref("transactionalHistory");

  try {
    final snapshot = await ref.get();
    if (!snapshot.exists || snapshot.value == null) {
      debugPrint("Erro: Nenhuma transação encontrada no Firebase.");
      return;
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    String? transactionKey;

    data.forEach((key, value) {
      if (value is Map && value["id"] == transaction["id"]) {
        transactionKey = key;
      }
    });

    if (transactionKey == null) {
      debugPrint("Erro: Transação não encontrada.");
      return;
    }

    await ref.child(transactionKey!).remove();

    if (transaction["userId"] != null && transaction["value"] != null) {
      await _updateUserBalance(
        transaction["userId"],
        -double.parse(transaction["value"].toString()),
      );
    }

    debugPrint("Transação excluída com sucesso!");
    refreshUI();
  } catch (e) {
    debugPrint("Erro ao excluir transação: $e");
  }
}

Future<void> _updateUserBalance(String userId, double amount) async {
  final userRef = FirebaseDatabase.instance.ref("users/$userId");

  try {
    final snapshot = await userRef.get();
    if (!snapshot.exists || snapshot.value == null) {
      debugPrint("Erro: Usuário não encontrado no Firebase.");
      return;
    }

    final userData = Map<String, dynamic>.from(snapshot.value as Map);
    double currentBalance =
        double.tryParse(userData["balance"]?.toString() ?? "0") ?? 0.0;
    double newBalance = currentBalance + amount;

    await userRef.update({"balance": newBalance});
    debugPrint("Saldo atualizado para: R\$ $newBalance");
  } catch (e) {
    debugPrint("Erro ao atualizar saldo do usuário: $e");
  }
}
