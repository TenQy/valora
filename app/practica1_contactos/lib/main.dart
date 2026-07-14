import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practica 1 - Contactos',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const ContactsPage(),
    );
  }
}

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> _contacts = [];
  String _mensaje = 'Presiona el boton para cargar contactos';
  bool _cargando = false;

  // Paso 2: Solicitar permiso al usuario
  // Paso 4: Consultar los datos
  // Paso 6: Manejar errores o permisos denegados
  Future<void> _cargarContactos() async {
    setState(() {
      _cargando = true;
      _mensaje = '';
    });

    final PermissionStatus status = await Permission.contacts.request();

    if (status.isGranted) {
      // Se obtiene el contenido mediante el plugin flutter_contacts
      final List<Contact> contactos = await FlutterContacts.getContacts(
        withProperties: true,
      );

      setState(() {
        // Mostramos hasta 10 contactos como pide la practica
        _contacts = contactos.take(10).toList();
        _cargando = false;
        if (_contacts.isEmpty) {
          _mensaje = 'No se encontraron contactos en el dispositivo.';
        }
      });
    } else {
      setState(() {
        _cargando = false;
        _mensaje = 'Permiso denegado. No se puede acceder a los contactos.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leer contactos del dispositivo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.contacts),
              label: const Text('Cargar contactos'),
              onPressed: _cargando ? null : _cargarContactos,
            ),
            const SizedBox(height: 16),
            if (_cargando) const CircularProgressIndicator(),
            if (!_cargando && _mensaje.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _mensaje,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            // Paso 5: Mostrar la informacion en la interfaz (ListView)
            Expanded(
              child: ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contacto = _contacts[index];
                  final telefono = contacto.phones.isNotEmpty
                      ? contacto.phones.first.number
                      : 'Sin numero';
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(contacto.displayName),
                      subtitle: Text(telefono),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}