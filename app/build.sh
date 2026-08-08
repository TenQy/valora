#!/bin/bash

# Vercel no tiene Flutter instalado por defecto (por eso el error 127: comando no encontrado).
# Este script descarga Flutter, lo configura y compila la aplicación web.

echo "Descargando Flutter SDK..."
if [ ! -d "flutter" ]; then
  git clone --depth 1 https://github.com/flutter/flutter.git -b stable
fi

export PATH="$PATH:`pwd`/flutter/bin"

echo "Instalando dependencias y compilando..."
flutter doctor
flutter clean
flutter pub get

echo "Generando .env desde variables de entorno de Vercel..."
echo "SUPABASE_URL=$SUPABASE_URL" > .env
echo "SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY" >> .env

flutter build web --release
