import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practica 2 - Galeria',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const GalleryPage(),
    );
  }
}

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<AssetEntity> _fotos = [];
  String _mensaje = 'Presiona el boton para cargar la galeria';
  bool _cargando = false;

  // Paso 2: Solicitar permiso al usuario
  // Paso 4: Consultar los datos
  // Paso 6: Manejar errores o permisos denegados
  Future<void> _cargarGaleria() async {
    setState(() {
      _cargando = true;
      _mensaje = '';
    });

    // photo_manager maneja su propia solicitud de permisos de medios
    final PermissionState permiso =
        await PhotoManager.requestPermissionExtend();

    if (permiso.isAuth || permiso.hasAccess) {
      // Paso 4: Obtener los albumes y las primeras fotos
      final List<AssetPathEntity> albumes =
          await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      if (albumes.isEmpty) {
        setState(() {
          _cargando = false;
          _mensaje = 'No se encontraron albumes de fotos.';
        });
        return;
      }

      final AssetPathEntity albumPrincipal = albumes.first;
      final List<AssetEntity> fotos = await albumPrincipal.getAssetListRange(
        start: 0,
        end: 10,
      );

      setState(() {
        _fotos = fotos;
        _cargando = false;
        if (_fotos.isEmpty) {
          _mensaje = 'No se encontraron fotos en el dispositivo.';
        }
      });
    } else {
      setState(() {
        _cargando = false;
        _mensaje = 'Permiso denegado. No se puede acceder a la galeria.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leer galeria del dispositivo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text('Cargar galeria'),
              onPressed: _cargando ? null : _cargarGaleria,
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
            // Paso 5: Mostrar la informacion en la interfaz (GridView)
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: _fotos.length,
                itemBuilder: (context, index) {
                  final foto = _fotos[index];
                  return FutureBuilder<Uint8List?>(
                    future: foto.thumbnailDataWithSize(
                      const ThumbnailSize(200, 200),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                              ConnectionState.done &&
                          snapshot.data != null) {
                        return Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        );
                      }
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    },
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