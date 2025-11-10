import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/midia_page.dart';
import 'viewmodel/midia_viewmodel.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MidiaViewModel()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MidiaPage(),
      ),
    );
  }
}
