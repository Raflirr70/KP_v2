import 'package:flutter/material.dart';
import 'package:kerprak/model/user.dart';
import 'package:kerprak/screen/owner/homePage_admin.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  bool _obscure = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  void _showMessage(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  void _onLoginPressed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    // 🔥 Cek ke provider
    final users = Provider.of<Users>(context, listen: false);
    final user = users.login(email, password);

    await Future.delayed(const Duration(seconds: 1)); // efek loading saja
    setState(() => _isLoading = false);

    if (user != null) {
      _showMessage("Login berhasil");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomepageAdmin(email: user.nama)),
      );
    } else {
      _passwordCtrl.clear();
      _showMessage("Email atau password salah", error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Icon(Icons.person, size: 80, color: Colors.teal),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? "Email tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? "Password tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onLoginPressed,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text("Masuk"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
