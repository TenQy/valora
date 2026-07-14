import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

// Paso 1: Instalar flutter_local_notifications (ya en pubspec.yaml)

// Plugin global de notificaciones
final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Paso 2: Inicializar el canal para Android y iOS
Future<void> initNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings();

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await notificationsPlugin.initialize(initSettings);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practica 3 - Notificaciones',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const NotificationsPage(),
    );
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String _mensaje = 'Presiona el boton para disparar una notificacion';

  // Paso 3: Disparar la alerta
  Future<void> _dispararNotificacion() async {
    // En Android 13+ se debe pedir el permiso de notificaciones
    final PermissionStatus status = await Permission.notification.request();

    if (status.isGranted) {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'upap_channel', // id del canal
        'UPAP Notificaciones', // nombre del canal
        channelDescription: 'Canal para alertas de la app UPAP',
        importance: Importance.max,
        priority: Priority.high,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
      );

      await notificationsPlugin.show(
        0,
        'UPAP Alerta',
        'Tarea completada',
        details,
      );

      setState(() {
        _mensaje = 'Notificacion enviada correctamente.';
      });
    } else {
      setState(() {
        _mensaje =
            'Permiso de notificaciones denegado. No se puede enviar la alerta.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones Locales'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.notifications_active,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('Disparar notificacion'),
                onPressed: _dispararNotificacion,
              ),
              const SizedBox(height: 20),
              Text(
                _mensaje,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}