// archivo: inicio_tutor.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'recuperar_contrasena.dart'; // Pantalla para recuperar contraseña
import 'conecta_tutor.dart';       // <<< Pantalla de destino para el tutor

class InicioTutor extends StatefulWidget {
  const InicioTutor({super.key});

  @override
  State<InicioTutor> createState() => _InicioTutorState();
}

class _InicioTutorState extends State<InicioTutor> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _recordarme = false;
  bool _cargando = false;
  bool _verPassword = false;

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Por favor, ingrese ambos campos.');
      return;
    }

    setState(() => _cargando = true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ConectaTutor()), // <<< aquí
      );
    } on FirebaseAuthException catch (e) {
      String msg = 'Error al iniciar sesión.';
      switch (e.code) {
        case 'user-not-found':
          msg = 'No existe un usuario con ese correo.';
          break;
        case 'wrong-password':
          msg = 'Contraseña incorrecta.';
          break;
        case 'invalid-email':
          msg = 'Correo inválido.';
          break;
        case 'user-disabled':
          msg = 'La cuenta está deshabilitada.';
          break;
      }
      _showSnackBar(msg);
    } catch (e) {
      _showSnackBar('Error: $e');
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Por favor, ingrese ambos campos.');
      return;
    }

    setState(() => _cargando = true);
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _showSnackBar('Cuenta creada. Ahora puedes iniciar sesión.');

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ConectaTutor()), // <<< y aquí
      );
    } on FirebaseAuthException catch (e) {
      String msg = 'Error al crear cuenta.';
      switch (e.code) {
        case 'weak-password':
          msg = 'La contraseña es muy débil.';
          break;
        case 'email-already-in-use':
          msg = 'Ese correo ya está en uso.';
          break;
        case 'invalid-email':
          msg = 'Correo inválido.';
          break;
      }
      _showSnackBar(msg);
    } catch (e) {
      _showSnackBar('Error: $e');
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                const Text(
                  'Inicio de sesión tutor',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

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

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
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

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: !_verPassword,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => !_cargando ? _signIn() : null,
                    decoration: InputDecoration(
                      labelText: 'Ingrese su contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _verPassword = !_verPassword),
                        icon: Icon(_verPassword ? Icons.visibility_off : Icons.visibility),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

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
                              setState(() => _recordarme = value ?? false);
                            },
                          ),
                          const Text('Recordarme', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RecuperarContrasena()),
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

                // Botón ingresar -> ConectaTutor
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: _cargando ? null : _signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2EB79B),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: _cargando
                        ? const SizedBox(
                            height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.4),
                          )
                        : const Text(
                            'Ingresar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    children: [
                      const Text(
                        '¿Aún no tienes una cuenta? ',
                        style: TextStyle(color: Colors.black87, fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: _cargando ? null : _register,
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
