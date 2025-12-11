import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kerprak/model/user.dart';
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
  bool? success;

  String? _loginError; // variabel untuk menyimpan pesan error

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// LOGO
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Image.asset("lib/asset/rumahGadang.png"),
              ),

              /// TITLE
              Text(
                "Ampera Saiyo",
                style: GoogleFonts.pacifico(
                  fontSize: 35,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Welcome back!",
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),

              const SizedBox(height: 30),

              /// FORM
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// USERNAME FIELD
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        controller: _emailCtrl,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '            Username tidak boleh kosong';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline),
                          border: InputBorder.none,
                          hintText: "Username",
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    /// PASSWORD FIELD
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscure,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '            Password tidak boleh kosong';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: InputBorder.none,
                          hintText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    /// PESAN ERROR LOGIN
                    if (_loginError != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          _loginError!,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    /// SIGN IN BUTTON
                    Consumer<Users>(
                      builder: (context, value, child) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                bool success = await value.Login(
                                  _emailCtrl.text,
                                  _passwordCtrl.text,
                                );

                                if (!success) {
                                  // Jika login gagal, tampilkan SnackBar popup
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Email atau password salah!",
                                        textAlign: TextAlign.center,
                                      ),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  // Login sukses, navigasi atau hapus snackbar
                                  ScaffoldMessenger.of(
                                    context,
                                  ).hideCurrentSnackBar();
                                  // Misal navigasi ke halaman utama:
                                  // Navigator.pushReplacementNamed(context, '/home');
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Sign in",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
