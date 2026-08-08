#!/bin/bash

# Vercel no tiene Flutter instalado por defecto (por eso el error 127: comando no encontrado).
# Este script descarga Flutter, lo configura y compila la aplicación web.

echo "Descargando Flutter SDK..."
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable
fi

export PATH="$PATH:`pwd`/flutter/bin"

echo "Instalando dependencias y compilando..."
flutter doctor
flutter clean
flutter pub get
flutter build web --release
