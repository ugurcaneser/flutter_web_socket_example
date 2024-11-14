import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('WebSocket Data Display')),
        body: const WebSocketDataScreen(),
      ),
    );
  }
}

class WebSocketDataScreen extends StatefulWidget {
  const WebSocketDataScreen({super.key});

  @override
  State createState() => _WebSocketDataScreenState();
}

class _WebSocketDataScreenState extends State<WebSocketDataScreen> {
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080'), // Your WebSocket URL
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return const Text('No data received');
          } else {
            return Text('Data: ${snapshot.data}');
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
