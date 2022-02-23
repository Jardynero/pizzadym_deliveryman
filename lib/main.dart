import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pizzadym_deliveryman/functions/functions.dart';
import 'package:pizzadym_deliveryman/theme/themes.dart';
import 'package:pizzadym_deliveryman/screens/screens.dart';
import 'package:pizzadym_deliveryman/db/db.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  debugPrint('new message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await StockLocalData.init();
  runApp(const DeliveryMan());
}

class DeliveryMan extends StatelessWidget {
  const DeliveryMan({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StockLocalData(),
      builder: (BuildContext context, _) {
        return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: GlobalData.appName,
        themeMode: Provider.of<StockLocalData>(context, listen: true).currentThemeMode,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const AuthScreen(),
      );
      },
    );
  }
}
