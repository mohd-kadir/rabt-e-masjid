import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'admin_dashboard_screen.dart';
import 'admin_register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Admin Login screen for mosque administrators. UI only — no Firebase
/// or any backend authentication is wired up. Submitting the form just
/// shows a placeholder snackbar; wire up real auth when ready.
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkExistingAdminSession();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email is required';
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  String? _validatePassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> _checkExistingAdminSession() async {
    final user = FirebaseAuth.instance.currentUser;

    // User logged in nahi hai
    if (user == null) {
      return;
    }

    try {
      final adminDoc = await FirebaseFirestore.instance
          .collection('admins')
          .doc(user.uid)
          .get();

      // Admin document nahi mila
      if (!adminDoc.exists) {
        await FirebaseAuth.instance.signOut();
        return;
      }

      final data = adminDoc.data();

      final role = data?['role'];
      final masjidId = data?['masjidId'];
      final adminName = data?['name'];

      // Admin authorized nahi hai
      if (role != 'admin' ||
          masjidId == null ||
          masjidId.toString().isEmpty) {
        await FirebaseAuth.instance.signOut();
        return;
      }

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => AdminDashboardScreen(
            masjidId: masjidId.toString(),
            adminName: adminName?.toString() ?? 'Admin',
          ),
        ),
      );
    } catch (e) {
      debugPrint('Existing admin session check failed: $e');
    }
  }

  Future<void> _handleLogin() async {
    final form = _formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _isSubmitting = true);

    try {
      // 1. Firebase Authentication se login
      final credential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw Exception('User not found');
      }

      // 2. Logged-in user ki UID se Firestore admin document fetch
      final adminDoc = await FirebaseFirestore.instance
          .collection('admins')
          .doc(user.uid)
          .get();

      // 3. Check: admins collection mein UID exist karti hai ya nahi
      if (!adminDoc.exists) {
        await FirebaseAuth.instance.signOut();

        if (!mounted) return;

        setState(() => _isSubmitting = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'This account is not authorized as an admin.',
            ),
          ),
        );

        return;
      }

      // 4. Admin document ka data
      final data = adminDoc.data();

      final role = data?['role'];
      final masjidId = data?['masjidId'];
      final adminName = data?['name'];

      // 5. Role aur masjidId verify karo
      if (role != 'admin' ||
          masjidId == null ||
          masjidId.toString().isEmpty) {
        await FirebaseAuth.instance.signOut();

        if (!mounted) return;

        setState(() => _isSubmitting = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Admin account setup is incomplete.',
            ),
          ),
        );

        return;
      }

      if (!mounted) return;

      setState(() => _isSubmitting = false);

      // 6. Correct masjid ki information dashboard ko bhejo
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => AdminDashboardScreen(
            masjidId: masjidId.toString(),
            adminName: adminName?.toString() ?? 'Admin',
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() => _isSubmitting = false);

      String message;

      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          message = 'Invalid email or password.';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;

        case 'user-disabled':
          message = 'This admin account has been disabled.';
          break;

        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;

        default:
          message = 'Login failed. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;

      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Database error: ${e.message ?? 'Please try again.'}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong. Please try again.',
          ),
        ),
      );
    }
  }
  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address first'),
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password reset link has been sent to your email.',
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Unable to send reset email.';

      if (e.code == 'user-not-found') {
        message = 'No admin account found with this email.';
      } else if (e.code == 'invalid-email') {
        message = 'Please enter a valid email address.';
      } else if (e.code == 'too-many-requests') {
        message = 'Too many attempts. Please try again later.';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.18 : 24.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 32, horizontalPadding, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Header ---
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          gradient: AppColors.logoGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGreenDark.withOpacity(0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.mosque_rounded, size: 36, color: AppColors.goldLight),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Masjid Administration',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Manage your mosque from one place',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // --- Email field ---
                const _FieldLabel('Email'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: _validateEmail,
                  style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                  decoration: _fieldDecoration(
                    hint: 'admin@masjidnoor.org',
                    icon: Icons.mail_outline_rounded,
                  ),
                ),
                const SizedBox(height: 20),

                // --- Password field ---
                const _FieldLabel('Password'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: _validatePassword,
                  onFieldSubmitted: (_) => _handleLogin(),
                  style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                  decoration: _fieldDecoration(
                    hint: 'Enter your password',
                    icon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // --- Remember me / Forgot password ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => setState(() => _rememberMe = !_rememberMe),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: (v) => setState(() => _rememberMe = v ?? false),
                                activeColor: AppColors.primaryGreen,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Remember me',
                              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _handleForgotPassword,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // --- Login button ---
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primaryGreen.withOpacity(0.6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                  )
                      : const Text(
                    'Login',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
                // --- Register link ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AdminRegisterScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 28),

                // --- Security notice ---
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.shield_outlined, size: 17, color: AppColors.goldMuted),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Authorized mosque administrators only.',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({required String hint, required IconData icon, Widget? suffixIcon}) {
    final borderRadius = BorderRadius.circular(14);
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary, fontWeight: FontWeight.w400),
      prefixIcon: Icon(icon, size: 19, color: AppColors.primaryGreen),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.cardSurfaceAlt,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      border: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.warning, width: 1.4),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.warning, width: 1.6),
      ),
      errorStyle: const TextStyle(fontSize: 11, color: AppColors.warning, fontWeight: FontWeight.w600),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
    );
  }
}