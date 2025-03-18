import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

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
  File? _selectedFile;
  String? _selectedFileName;
  Uint8List? _selectedFileBytes;

  final List<String> _transactionTypes = [
    "Depósito",
    "Doações",
    "Pix",
    "Crédito",
  ];

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _selectedFileName = result.files.single.name;
        });

        if (kIsWeb) {
          _selectedFileBytes = result.files.single.bytes;
        } else {
          _selectedFile = File(result.files.single.path!);
        }

        debugPrint("Arquivo selecionado: $_selectedFileName");
      } else {
        debugPrint("Nenhum arquivo foi selecionado.");
      }
    } catch (e) {
      debugPrint("Erro ao selecionar arquivo: $e");
    }
  }

  Future<String?> _uploadFileToStorage() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || (_selectedFile == null && _selectedFileBytes == null))
        return null;

      final storageRef = FirebaseStorage.instance.ref().child(
        "attachments/${user.uid}/${DateTime.now().millisecondsSinceEpoch}_${_selectedFileName}",
      );

      UploadTask uploadTask;

      if (kIsWeb && _selectedFileBytes != null) {
        uploadTask = storageRef.putData(_selectedFileBytes!);
      } else if (_selectedFile != null) {
        uploadTask = storageRef.putFile(_selectedFile!);
      } else {
        debugPrint("Erro: Nenhum arquivo válido para upload.");
        return null;
      }

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      debugPrint("Upload concluído! URL: $downloadURL");
      return downloadURL;
    } catch (e) {
      debugPrint("Erro ao fazer upload do arquivo: $e");
      return null;
    }
  }

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
    final transactionRef = FirebaseDatabase.instance.ref(
      "transactionalHistory",
    );

    try {
      // 🔹 Obtém o saldo atual do usuário
      final snapshot = await userRef.child('balance').get();
      double currentBalance =
          (snapshot.exists && snapshot.value != null)
              ? double.parse(snapshot.value.toString())
              : 0.0;

      double newBalance = currentBalance + transactionValue;

      // 🔹 Upload do arquivo PDF, se houver um selecionado
      String? fileUrl;
      fileUrl = await _uploadFileToStorage();
      if (fileUrl == null) {
        debugPrint("Erro: Não foi possível fazer upload do arquivo.");
        return;
      }

      // 🔹 Criando o objeto da transação
      final newTransaction = {
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "userId": user.uid,
        "type": _selectedTransactionType,
        "method": "DOC/TED",
        "value": transactionValue,
        "date": DateTime.now().toIso8601String(),
        "attachment": fileUrl ?? "",
      };

      await transactionRef.push().set(newTransaction);
      await userRef.update({"balance": newBalance});

      debugPrint("Transação salva e saldo atualizado!");

      _valueController.clear();
      setState(() {
        _selectedTransactionType = null;
        _selectedFile = null;
        _selectedFileName = null;
      });

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
                const SizedBox(height: 40),

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
                    items:
                        _transactionTypes.map((String value) {
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

                const SizedBox(height: 40),

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

                const SizedBox(height: 40),

                const Text(
                  'Anexos',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.attach_file),
                      label: const Text("Selecionar arquivo"),
                      onPressed: _pickFile,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedFileName ?? "Nenhum arquivo selecionado",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: kTeal),
                    onPressed: _saveTransaction,
                    child: const Text(
                      'Concluir transação',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
