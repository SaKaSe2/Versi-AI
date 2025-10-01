import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // for button animation
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.08,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() async {
    // play touch animation
    await _animController.forward();
    await _animController.reverse();

    // Simple validation (replace with real auth)
    final email = _emailController.text.trim();
    final pass = _passwordController.text;

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password harus diisi')),
      );
      return;
    }

    // Navigate to dashboard (replace with real auth result)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => DashboardPage(username: email)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsiveness
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final height = mq.size.height;

    // Responsiveness thresholds
    final isLarge = width > 800;
    final contentWidth = isLarge ? 500.0 : width * 0.9;
    final logoSize = isLarge ? 140.0 : width * 0.22;
    final fieldFontSize = isLarge ? 18.0 : 15.0;
    final titleFontSize = isLarge ? 32.0 : 24.0;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: height * 0.06),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                SizedBox(
                  width: contentWidth,
                  child: Column(
                    children: [
                      // Use FlutterLogo for an example. Replace with Image.asset(...) for a custom logo.
                      SizedBox(
                        height: logoSize,
                        child: Hero(
                          tag: 'app-logo',
                          child: FlutterLogo(size: logoSize),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Welcome back',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 8),
                      Text('Login ke akun kamu',
                          style: TextStyle(fontSize: fieldFontSize)),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Form card
                Container(
                  width: contentWidth,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Email
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        style: TextStyle(fontSize: fieldFontSize),
                      ),
                      const SizedBox(height: 12),

                      // Password
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        style: TextStyle(fontSize: fieldFontSize),
                      ),

                      const SizedBox(height: 18),

                      // Animated Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: child,
                            );
                          },
                          child: ElevatedButton(
                            onPressed: _onLoginPressed,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 6,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.login),
                                SizedBox(width: 10),
                                Text('Masuk', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Additional actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {}, child: const Text('Daftar')),
                          TextButton(
                              onPressed: () {}, child: const Text('Lupa password?')),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // small footer
                TextButton.icon(
                  onPressed: () {
                    // quick demo: jump to dashboard without login
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const DashboardPage(username: 'Guest')),
                    );
                  },
                  icon: const Icon(Icons.explore_outlined),
                  label: const Text('Jelajahi sebagai tamu'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final String username;
  const DashboardPage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final isLarge = width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              // back to login (replace to demonstrate navigation)
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginPage()));
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isLarge ? 40.0 : 16.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Hero(tag: 'app-logo', child: FlutterLogo(size: 54)),
                const SizedBox(width: 12),
                Text('Halo, $username', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 14),
            const Text('Ini adalah contoh dashboard sederhana.'),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: isLarge ? 3 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: List.generate(
                  6,
                  (index) => Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Text('Item ${index + 1}')),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*
Notes:
- Kode ini self-contained di main.dart.
- Untuk mengganti logo, ganti FlutterLogo(...) dengan Image.asset('assets/logo.png')
  lalu tambahkan asset di pubspec.yaml.
- Tombol animasi menggunakan AnimationController + Transform.scale untuk efek "tekan".
- MediaQuery digunakan di beberapa tempat untuk responsivitas (ukuran logo, card width, grid).
- Untuk autentikasi nyata, gantikan logika sederhana di _onLoginPressed dengan panggilan API / Firebase.
*/
