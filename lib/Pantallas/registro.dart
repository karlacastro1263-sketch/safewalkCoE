import 'package:flutter/material.dart';
import 'inicio_sesion.dart';   // Pantalla de inicio de sesión (usuario)
import 'inicio_tutor.dart';    // Pantalla de inicio del tutor (contacto de emergencia)

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  bool isVisualImpaired = false;
  bool isEmergencyContact = false;

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void _onContinue() {
    // Debe haber exactamente UNA opción seleccionada
    if (isVisualImpaired == isEmergencyContact) {
      _showSnack('Selecciona exactamente una opción para continuar.');
      return;
    }

    if (isVisualImpaired) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const InicioSesion()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const InicioTutor()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo principal
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondo_registro.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Imagen decorativa en la esquina superior izquierda
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/fondo_registro2.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),

          // Contenido principal
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 40),

                  // Título principal
                  const Text(
                    'Regístrese con Correo Electrónico',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Subtítulo
                  const Text(
                    'Regístrate a SafeWalk para una experiencia personalizada con tu gorro Navicap.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // Campos de texto
                  _buildTextField('Ingrese su correo electrónico'),
                  const SizedBox(height: 15),
                  _buildTextField('Ingrese su nombre'),
                  const SizedBox(height: 15),
                  _buildTextField('Ingrese su RUT'),
                  const SizedBox(height: 15),
                  _buildTextField('Ingrese su número de teléfono'),
                  const SizedBox(height: 15),
                  _buildTextField('Introduzca la contraseña', obscureText: true),
                  const SizedBox(height: 25),

                  // Texto antes de checkboxes
                  const Text(
                    '¿Es usuario con discapacidad visual o contacto de emergencia?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // Checkbox usuario (exclusivo)
                  Row(
                    children: [
                      Checkbox(
                        value: isVisualImpaired,
                        onChanged: (bool? value) {
                          setState(() {
                            isVisualImpaired = value ?? false;
                            if (isVisualImpaired) {
                              isEmergencyContact = false; // exclusividad
                            }
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Soy usuario con discapacidad visual',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),

                  // Checkbox contacto (exclusivo)
                  Row(
                    children: [
                      Checkbox(
                        value: isEmergencyContact,
                        onChanged: (bool? value) {
                          setState(() {
                            isEmergencyContact = value ?? false;
                            if (isEmergencyContact) {
                              isVisualImpaired = false; // exclusividad
                            }
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Soy contacto de emergencia',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Botón continuar (navega según selección)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2EB79B),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Continuar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Texto de términos y privacidad
                  const Text(
                    'Al crear una cuenta, aceptas nuestros Términos y confirmas haber leído nuestra Política de privacidad',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método para construir textfields con mismo estilo
  Widget _buildTextField(String hintText, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
