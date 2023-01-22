import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/injector.dart';
import 'package:wehere_client/presentation/provider/member_provider.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initializeDependencies();
  FlutterNativeSplash.remove();
  runApp(ChangeNotifierProvider(
    create: (context) => injector<MemberProvider>(),
    child: MaterialApp(
      home: Home(),
    ),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Provider.of<MemberProvider>(context, listen: false).getMember();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('member'),
        ),
        body: Consumer<MemberProvider>(
          builder: (context, value, child) {
            if (value.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            final member = value.member;
            return Center(
              child: Text(member == null ? 'null' : member.nickname),
            );
          },
        ));
  }
}
