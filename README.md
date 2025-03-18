# 📌 Bytebank - Aplicação Flutter 🚀🔥📱

Este é um projeto Flutter chamado **Bytebank**, que utiliza **Firebase** para autenticação, armazenamento de dados no **Firestore** e **Realtime Database**, além de funcionalidades como upload de arquivos e visualização de PDFs. 📂🔑💾

🔗 **Repositório do Projeto:** [GitHub - tech-challenge-03](https://github.com/fonaziero/tech-challenge-03) 🌍🔧📌
📽 **Demonstração em Vídeo:** [YouTube - Demo](https://youtu.be/f5U3JQ-G3nk) 🎥👀📢

---

## 📋 Pré-requisitos ✅⚙️📌
Antes de instalar o projeto, certifique-se de ter os seguintes requisitos configurados: 🖥️🔧📥

- [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado
- Dart instalado junto com o Flutter SDK
- [Android Studio](https://developer.android.com/studio) ou [Visual Studio Code](https://code.visualstudio.com/) com as extensões do Flutter
- [Firebase CLI](https://firebase.google.com/docs/cli) instalado
- Conta no [Firebase](https://firebase.google.com/) com um projeto configurado

---

## 🚀 Instalação do Projeto 💻📦🔧

### 1️⃣ Clone o repositório 🔄🖥️📂
```sh
git clone https://github.com/fonaziero/tech-challenge-03.git
cd tech-challenge-03
```

### 2️⃣ Instale as dependências 📦🔄📌
```sh
flutter pub get
```

---

## 🔥 Configuração do Firebase 🔧💾⚡
Para conectar o projeto ao Firebase, siga os passos abaixo: 📜✅🔗

### 1️⃣ Crie um projeto no Firebase 🔥📁✅
1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Clique em **Adicionar Projeto** e siga as instruções.
3. Após a criação, vá para **Configurações do Projeto** e clique em **Adicionar um App** (selecione Flutter).

### 2️⃣ Adicione Firebase ao Flutter 📂🔥🔗

#### 📌 Para Android 🤖⚙️📁
1. No Firebase, baixe o arquivo **google-services.json** e coloque dentro da pasta:
    ```bash
    android/app/
    ```
2. No arquivo **android/build.gradle**, adicione:
    ```gradle
    dependencies {
        classpath 'com.google.gms:google-services:4.3.10'
    }
    ```
3. No arquivo **android/app/build.gradle**, adicione:
    ```gradle
    apply plugin: 'com.google.gms.google-services'
    ```

#### 📌 Para iOS 🍏📁⚙️
1. No Firebase, baixe o arquivo **GoogleService-Info.plist** e coloque dentro da pasta:
    ```swift
    ios/Runner/
    ```
2. No terminal, execute:
    ```sh
    cd ios
    pod install
    cd ..
    ```

### 3️⃣ Configure Firebase no código 📜🔥🔧
No arquivo **main.dart**, inicialize o Firebase:
```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

---

## 📂 Funcionalidades Utilizadas 🔥💾🔑
O projeto faz uso dos seguintes serviços do Firebase: ✅📌⚡

| Serviço                   | Descrição                                  |
|---------------------------|--------------------------------------------|
| 🔑 **Firebase Authentication** | Gerenciamento de usuários e login       |
| 💾 **Firestore Database**    | Armazenamento de dados em tempo real     |
| 📂 **Firebase Storage**     | Upload e download de arquivos            |
| 🔥 **Realtime Database**    | Sincronização de dados em tempo real     |

---

## ▶️ Executando o Projeto 💻🚀📌
Após a instalação e configuração do Firebase, execute o projeto com: 🎯📦💨
```sh
flutter run
```
Caso esteja rodando no emulador iOS, utilize: 🍏⚡📂
```sh
flutter run --no-sound-null-safety
```

---

## 🛠 Principais Dependências 📦🔗📌
O projeto utiliza as seguintes dependências: 📂⚙️✅
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^4.0.3
  firebase_core: ^2.31.1
  cloud_firestore: ^4.17.3
  firebase_auth: ^4.19.6
  firebase_database: ^10.4.9
  file_picker: ^8.0.7
  firebase_storage: ^11.7.7
  url_launcher: ^6.3.1
  flutter_pdfview: ^1.4.0
```

---

## 🏆 Contribuindo 🤝📌🌍
Se quiser contribuir com o projeto, siga os passos: ✅🔄📥

1. Faça um **fork** do projeto 📂🔄🔗
2. Crie uma nova **branch** para sua feature: 🌱🔧📜
    ```sh
    git checkout -b minha-feature
    ```
3. Faça suas alterações e **commit**: 📝✅📌
    ```sh
    git commit -m 'Minha nova feature'
    ```
4. Envie para o repositório remoto: 🚀📡💻
    ```sh
    git push origin minha-feature
    ```
5. Abra um **Pull Request** 🔄✅📌

---

## 📜 Licença 📜🔓✅
Este projeto é distribuído sob a licença **MIT**. Consulte o arquivo `LICENSE` para mais detalhes. 📂⚖️🔗

---

Se precisar de mais informações ou ajustes, só avisar! 🚀🔥✅