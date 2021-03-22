import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Authentication'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _canCheckBiometric = false ;
  String _authorizedOrNot = "Not Authorized";
  // ignore: deprecated_member_use
  List<BiometricType> _avaliableBiomertricTypes = List<BiometricType>();
   Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;
    try {
      canCheckBiometric = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listofBiometrics;
    try {
      listofBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _avaliableBiomertricTypes = listofBiometrics;
    });
  }

  Future<void> _authorizeNow() async {
    bool isAuthorized = false;
    try {
      isAuthorized = await _localAuthentication.authenticate(
        localizedReason: "Please authenticate to complete your transaction",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      if (isAuthorized) {
        _authorizedOrNot = "Authorized";
      } else {
        _authorizedOrNot = "Not Authorized";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text("Can check biometic : $_canCheckBiometric"),
            // ElevatedButton(
            // onPressed: _checkBiometric,
            // child: Text("Check Biometric"),
            // style: ElevatedButton.styleFrom(
            //   primary: Colors.red,),
            // ),
            // Text("List of Biometric: ${_avaliableBiomertricTypes.toString()}"),
            // ElevatedButton(
            // onPressed: _getListOfBiometricTypes,
            // child: Text("Check Biometric"),
            // style: ElevatedButton.styleFrom(
            // primary: Colors.red, 
            //   ),
            // ),
            Text("Authorized or Not: $_authorizedOrNot"),
            ElevatedButton(
            onPressed: _authorizeNow,
            child: Text("Authorize Now"),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,),
            ),
          ],
        ),
      ),
    );
  }
}
