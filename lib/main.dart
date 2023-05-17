import 'package:buzzer_arduino/send_message.dart';
import 'package:buzzer_arduino/connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); //added

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bluetooth Buzzer',
      theme: ThemeData(
          colorScheme: const ColorScheme.dark(
              secondary: Color(0x000a2c2a), primary: Color(0xFF075E54))),
      home: FutureBuilder(
        future: FlutterBluetoothSerial.instance.requestEnable(),
        builder: (BuildContext context, future) {
          if (future.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: SizedBox(
                height: double.infinity,
                child: Center(
                  child: Icon(
                    Icons.bluetooth_disabled,
                    size: 200,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          } else {
            return const Home();
          }
        },
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Device That Can Connect"),
      ),
      body: SelectBondedDevicePage(
        onCahtPage: (device1) {
          BluetoothDevice device = device1;
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChatPage(
              server: device,
            );
          }));
        },
      ),
    ));
  }
}
