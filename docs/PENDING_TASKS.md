# Pendientes técnicos - Valora

Este documento reúne tareas identificadas durante el desarrollo que **no son urgentes ahora**, pero deben resolverse antes de la entrega final, el despliegue o la exposición.

---

## Antes de generar el APK de producción (Fase 13 - Deploy)

### Google Sign-In: SHA-1 de release

- [ ] Generar un keystore de **release** propio (no usar el `debug.keystore`).
```bash
  keytool -genkey -v -keystore ~/valora-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias valora
```
- [ ] Configurar el keystore en `android/app/build.gradle` (signingConfigs).
- [ ] Obtener el SHA-1 del build de release:
```bash
  cd android
  ./gradlew signingReport
```
- [ ] Agregar ese SHA-1 nuevo a la credencial OAuth **Android** en Google Cloud Console (sin borrar el de debug, se pueden tener varios).
- [ ] Probar Google Sign-In con el APK de release generado (`flutter build apk --release`), no solo en modo debug.

### Colaboradores y otros dispositivos

- [ ] Si algún colaborador corre la app en modo debug desde su propia máquina, necesita generar su propio SHA-1 (`signingReport`) y agregarlo a la misma credencial Android en Google Cloud Console.

---

## Antes de la exposición / entrega pública

### Dominio verificado en Resend (correos de confirmación)

- [ ] Verificar un dominio propio en Resend (Domains → Add Domain) para dejar de depender del dominio de pruebas `resend.dev`, que **solo envía correos a la cuenta con la que te registraste en Resend**.
- [ ] Sin esto, otras personas (jueces, profesores, invitados a probar la app) no podrán completar el registro con su propio correo.
- [ ] Actualizar el **Sender email** en Supabase SMTP Settings una vez tengas el dominio verificado (ej. `noreply@tudominio.com` en vez de `onboarding@resend.dev`).

### Redirect URLs de producción

- [ ] Si además de la app móvil se despliega Flutter Web (`/app`), revisar si el deep link `io.supabase.valora://login-callback` necesita una URL adicional tipo `https://valora.duckdns.org/app/auth-callback` para que la confirmación de correo funcione también desde el navegador.
- [ ] Agregar esa URL a **Redirect URLs** en Supabase Dashboard cuando llegue ese momento.
