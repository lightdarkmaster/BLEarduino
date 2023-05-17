// ignore_for_file: avoid_print

library send_messagee; //kailangan ada balyuan hahahha

import 'dart:async';
import 'dart:convert';

import 'dart:typed_data';
import 'package:animated_stack/animated_stack.dart';
import 'package:buzzer_arduino/buzzer_page.dart';
import 'package:buzzer_arduino/led_page.dart';
import 'package:buzzer_arduino/led_page2.dart';

// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice? server;
  const ChatPage({
    Key? key,
    this.server,
    this.lcdMessage,
  }) : super(key: key);
  final String? lcdMessage;

  @override
  _ChatPageState createState() => _ChatPageState();
}

//var to;

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  TabController? _controller;

  BluetoothConnection? connection;

  final ScrollController listScrollController = ScrollController();

  bool isConnecting = true;

  bool get isConnected => connection != null && connection!.isConnected;

  bool isDisconnecting = false;
  List<Color> _colorlist = [];
  List<Color> genrateColorslist() {
    List<Color> _colorslist = [];
    for (int i = 0; i < (8 * 8); i++) {
      _colorslist.add(Colors.black);
    }
    return _colorslist;
  }

  @override
  void initState() {
    super.initState();

    _colorlist = genrateColorslist();
    _controller = TabController(length: 6, vsync: this, initialIndex: 0);

    BluetoothConnection.toAddress(widget.server!.address).then((_connection) {
      print('Connected to Device');
      connection = _connection;

      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
    });
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
      mineController.close();
    }
    super.dispose();
  }

  bool btnColor = false;

  StreamController<String> mineController =
      StreamController<String>.broadcast();
  Stream<String> myStream() async* {
    connection?.input?.listen((Uint8List data) {
      print(ascii.decode(data));

      mineController.add(ascii.decode(data));
    });
  }

  @override
  Widget build(BuildContext context) {
    String denemee = "No Data";
    TextEditingController lcdController = TextEditingController();
    mineController.addStream(myStream());

    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          isScrollable: true,
          indicatorColor: Colors.white,
          controller: _controller,
          tabs: const [
            Tab(
              text: "Buzzer",
            ),
            Tab(
              text: "Led",
            ),
            Tab(
              text: "Led 2",
            ),
            Tab(
              text: "LCD",
            ),
            Tab(text: "Matrix"),
            Tab(text: "Distance"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 95),
              child: buzzerPage(
                sendMessage1: () => _sendMessage('1'),
                sendMessage2: () => _sendMessage('2'),
                sendMessage3: () => _sendMessage('3'),
                sendMessage4: () => _sendMessage('4'),
                sendMessage5: () => _sendMessage('5'),
                sendMessage6: () => _sendMessage('6'),
                sendMessage7: () => _sendMessage('7'),
                sendMessage8: () => _sendMessage('8'),
                sendMessage9: () => _sendMessage('9'),
              )),
          Align(
            alignment: Alignment.center,
            child: ledPage(
              sendMessageA: () => _sendMessage('a'),
              sendMessageK: () => _sendMessage('k'),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ledPage2(
              sendMessageA: () => _sendMessage('a'),
              sendMessageK: () => _sendMessage('k'),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 10),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: lcdController,
                        decoration: const InputDecoration(
                          hintText:
                              "Enter the text to be displayed on the LCD screen.",
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            _sendMessage('x' + lcdController.text);
                          },
                          icon: const Icon(Icons.send)),
                      IconButton(
                          onPressed: () {
                            _sendMessage('t');
                          },
                          icon: const Icon(Icons.clear))
                    ]),
              ),
            ),
          ),
          AnimatedStack(
            backgroundColor: Colors.black,
            fabBackgroundColor: Colors.white,
            foregroundWidget: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2d2d2d),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 55),
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                    ),
                    itemCount: 8 * 8,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          btnColorChange();
                          if (_colorlist[index] == Colors.red) {
                            setState(() {
                              _colorlist[index] = Colors.black;
                            });
                            _sendMessage(index.toString() + "+0");
                          } else {
                            setState(() {
                              _colorlist[index] = Colors.red;
                            });
                            _sendMessage(index.toString() + "+1");
                          }

                          print(index.toString());
                          print(index.toString());
                        },
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: _colorlist[index],
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }),
              ),
            ),
            columnWidget: Column(
              children: [
                IconButton(
                    onPressed: () {
                      _sendMessage('c');
                    },
                    icon: const Icon(Icons.face)),
                const SizedBox(
                  height: 15,
                ),
                IconButton(
                    onPressed: () {
                      _sendMessage('d');
                    },
                    icon: const Icon(Icons.car_repair)),
                const SizedBox(
                  height: 15,
                ),
                IconButton(
                    onPressed: () {
                      _sendMessage('e');
                    },
                    icon: const Icon(Icons.arrow_upward_outlined)),
                const SizedBox(
                  height: 15,
                ),
                IconButton(
                    onPressed: () {
                      _sendMessage('f');
                    },
                    icon: const Icon(Icons.arrow_downward_outlined)),
                const SizedBox(
                  height: 15,
                ),
                IconButton(
                    onPressed: () {
                      _sendMessage('g');
                    },
                    icon: const Icon(Icons.arrow_back_outlined)),
                const SizedBox(
                  height: 15,
                ),
                IconButton(
                    onPressed: () {
                      _sendMessage('h');
                    },
                    icon: const Icon(Icons.arrow_forward_outlined)),
              ],
            ),
            bottomWidget: Align(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 55),
                child: GestureDetector(
                  onTap: () {
                    int i;
                    _sendMessage('j');
                    setState(() {
                      for (i = 0; i < 64; i++) {
                        _colorlist[i] = Colors.black;
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Text("Matrix Clear",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(Icons.clear)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          StreamBuilder<String>(
            stream: mineController.stream.asBroadcastStream(),
            builder: (context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 150),
                  child: CircularProgressIndicator(),
                );
              }
              return Center(
                child: Text(
                  snapshot.data ?? denemee,
                  style: const TextStyle(fontSize: 50, color: Colors.black),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  btnColorChange() {
    setState(() {
      btnColor = !btnColor;
    });
  }

  _sendMessage(String text) async {
    text = text.trim();

    if (text.isNotEmpty) {
      //text.length > 0
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text)));
        await connection!.output.allSent;
      } catch (e) {
        // Ignore error, but notify state
      }
    }
  }

  // ignore: unused_element
  _receiveMessage() {
    connection!.input!.listen((Uint8List data) {
      print('Data incoming: ${ascii.decode(data)}');
      void deneme = ascii.decode(data);

      return deneme;
    });
  }
}
