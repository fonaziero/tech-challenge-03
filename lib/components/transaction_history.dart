import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bytebank/components/transaction_manager.dart';

class TransactionHistory extends StatefulWidget {
  final VoidCallback refreshUI;

  const TransactionHistory({Key? key, required this.refreshUI})
      : super(key: key);

  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 0;
  final int itemsPerPage = 5;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchTransactionHistory();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading &&
        hasMore) {
      _fetchTransactionHistory();
    }
  }

  Future<void> _fetchTransactionHistory() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      debugPrint('UID do usuário é nulo.');
      setState(() => isLoading = false);
      return;
    }

    try {
      final ref = FirebaseDatabase.instance.ref('transactionalHistory');
      final snapshot = await ref.get();

      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        List<Map<String, dynamic>> fetchedTransactions = data.entries
            .map((entry) => Map<String, dynamic>.from(entry.value))
            .where((transaction) => transaction["userId"] == uid)
            .map((transaction) {
          return {
            "id": transaction["id"] ?? "",
            "date": _formatDate(transaction["date"] ?? ""),
            "method": transaction["method"] ?? "Desconhecido",
            "type": transaction["type"] ?? "Transação",
            "value": transaction["value"] ?? 0,
            "isDeposit": (transaction["value"] ?? 0) >= 0,
          };
        }).toList();

        fetchedTransactions.sort((a, b) => b["date"].compareTo(a["date"]));

        int startIndex = currentPage * itemsPerPage;
        int endIndex = startIndex + itemsPerPage;
        List<Map<String, dynamic>> newTransactions =
            fetchedTransactions.sublist(
                startIndex, endIndex > fetchedTransactions.length ? fetchedTransactions.length : endIndex);

        setState(() {
          transactions.addAll(newTransactions);
          currentPage++;
          hasMore = newTransactions.length == itemsPerPage;
          isLoading = false;
        });
      } else {
        debugPrint('Nenhuma transação encontrada no Firebase.');
        setState(() {
          hasMore = false;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Erro ao buscar transações: $e');
      setState(() => isLoading = false);
    }
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return "Data inválida";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        height: 480, 
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Extrato',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    if (transactions.isNotEmpty) {
                      openTransactionModal(
                        context,
                        transactions,
                        widget.refreshUI,
                      );
                    }
                  },
                  icon: const Icon(Icons.edit, color: Colors.teal),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: transactions.isEmpty && isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : transactions.isEmpty
                      ? Center(
                          child: Text(
                            "Nenhuma transação encontrada.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: transactions.length + 1,
                          itemBuilder: (context, index) {
                            if (index == transactions.length) {
                              return hasMore
                                  ? const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    )
                                  : const SizedBox.shrink();
                            }

                            final transaction = transactions[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction["type"],
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      transaction["method"],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      transaction["date"],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "R\$ ${transaction["value"]}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: transaction["type"] == "Depósito"
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                const Divider(
                                  color: Colors.green,
                                  thickness: 1,
                                ),
                              ],
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
