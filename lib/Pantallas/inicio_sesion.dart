import 'package:app_prueba/auth_service.dart';
import 'package:flutter/material.dart';
import 'recuperar_contrasena.dart'; // Pantalla para recuperar contraseña
import 'conecta.dart'; // Pantalla siguiente

class InicioSesion extends StatefulWidget {
  const InicioSesion({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InicioSesionState createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  bool _recordarme = false;

  // Controladores para los campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Función asincrónica para el inicio de sesión
  void _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(context, 'Por favor, ingrese ambos campos.');
      return;
    }

    try {
      // Llamada al servicio para iniciar sesión
      await authService.value.SignIn(email: email, password: password);

      // Si el inicio de sesión es exitoso, redirigir a la siguiente pantalla
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const Conecta()),
      );
    } catch (e) {
      // Mostrar el error si ocurre uno
      // ignore: use_build_context_synchronously
      _showSnackBar(context, 'Error: ${e.toString()}');
    }
  }

  // Función para registrar un nuevo usuario
  void _register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(context, 'Por favor, ingrese ambos campos.');
      return;
    }

    try {
      // Llamada al servicio para crear una nueva cuenta
      await authService.value.createAccount(email: email, password: password);
      // ignore: use_build_context_synchronously
      _showSnackBar(context, 'Cuenta creada exitosamente. Ahora puedes iniciar sesión.');
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const Conecta()),
      );
    } catch (e) {
      // Mostrar el error si ocurre uno
      // ignore: use_build_context_synchronously
      _showSnackBar(context, 'Error al crear cuenta: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    const turquesa = Color(0xFF69A6A1);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),

                // ---------- Título ----------
                const Text(
                  'Inicio de sesión',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                // ---------- Fondo + Imagen ----------
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 310,
                      height: 310,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/fondo_registroyinicio.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/registroyinicio.png',
                      width: 320,
                      height: 320,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // ---------- Campo correo ----------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Ingrese su correo electrónico',
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ---------- Campo contraseña ----------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Ingrese su contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ---------- Recordarme + Olvidaste tu contraseña ----------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _recordarme,
                            onChanged: (bool? value) {
                              setState(() {
                                _recordarme = value!;
                              });
                            },
                          ),
                          const Text(
                            'Recordarme',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RecuperarContrasena(),
                            ),
                          );
                        },
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(
                            color: turquesa,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ---------- Botón ingresar ----------
                ElevatedButton(
                  onPressed: _signIn, // Se llama a la función _signIn
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2EB79B),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 100,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Ingresar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // ---------- ¿Aún no tienes cuenta? ----------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    children: [
                      const Text(
                        '¿Aún no tienes una cuenta? ',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                      GestureDetector(
                        onTap: _register,  // Llama al método _register
                        child: const Text(
                          'Regístrate aquí',
                          style: TextStyle(
                            color: turquesa,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
