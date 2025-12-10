import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:news_app/data/service/auth_service.dart';
import 'package:news_app/core/storage/token_storage.dart';
import 'package:news_app/utils/components/adaptive_scaffold.dart';
import 'package:news_app/utils/components/buttontypeaction.dart';
import 'package:news_app/utils/components/passwordformfield.dart';
import 'package:news_app/utils/components/emailformfield.dart';
import 'package:news_app/utils/helper/form_validator.dart';
import 'package:news_app/utils/helper/toast.dart';

class RegisterPageView extends StatefulWidget {
  const RegisterPageView({super.key});

  @override
  State<RegisterPageView> createState() => _RegisterPageViewState();
}

class _RegisterPageViewState extends State<RegisterPageView> {
  ColorScheme get color => Theme.of(context).colorScheme;
  TextTheme get textStyle => Theme.of(context).textTheme;

  late final TokenStorage _tokenStorage;
  late final AuthService _authService;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tokenStorage = TokenStorage();
    _authService = AuthService(_tokenStorage);
  }

  final nameFocusNode = FocusNode();
  final nameController = TextEditingController();
  final emailFocusNode = FocusNode();
  final emailController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameFocusNode.dispose();
    nameController.dispose();
    emailFocusNode.dispose();
    emailController.dispose();
    passwordFocusNode.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.pop(context);
  }

  Future<void> _tapToRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      await _authService.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;
      ToastHelper.success(context, 'Registrasi berhasil, silakan login');

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('Exception: ', '');
      ToastHelper.error(context, message);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      backgroundColor: color.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: color.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 4,
                    children: [
                      Text(
                        'Buat Akun Baru',
                        style: textStyle.titleLarge?.copyWith(
                          color: color.primary,
                        ),
                      ),
                      Text(
                        'Silahkan daftar untuk melanjutkan',
                        style: textStyle.bodyLarge?.copyWith(
                          color: color.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: [
                      EmailFormField(
                        autofocus: false,
                        focusNode: nameFocusNode,
                        controller: nameController,
                        textStyle: textStyle,
                        color: color,
                        labelText: 'Nama Lengkap',
                        hintText: 'Masukkan nama anda disini',
                        prefixIcon: Icon(
                          LucideIcons.user,
                          size: 20,
                          color: color.primary,
                        ),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.name],
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(emailFocusNode);
                        },
                      ),

                      EmailFormField(
                        autofocus: false,
                        focusNode: emailFocusNode,
                        controller: emailController,
                        textStyle: textStyle,
                        color: color,
                        labelText: 'Email',
                        hintText: 'Masukkan email anda disini',
                        prefixIcon: Icon(
                          LucideIcons.mail,
                          size: 20,
                          color: color.primary,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        validator: FormValidators.email,
                        onFieldSubmitted: (_) {
                          FocusScope.of(
                            context,
                          ).requestFocus(passwordFocusNode);
                        },
                      ),

                      PasswordFormField(
                        focusNode: passwordFocusNode,
                        controller: passwordController,
                        textStyle: textStyle,
                        color: color,
                        labelText: 'Password',
                        hintText: 'Masukkan password anda',
                        prefixIcon: Icon(
                          LucideIcons.lock,
                          size: 20,
                          color: color.primary,
                        ),
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        validator: FormValidators.password,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  ButtonTypeAction(
                    type: ButtonType.elevated,
                    label: _isLoading ? 'Loading...' : 'Daftar Sekarang',
                    onPressed: _isLoading ? null : _tapToRegister,
                    textStyle: textStyle,
                    color: color,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: color.surface,
        child: Center(
          child: InkWell(
            onTap: _goToLogin,
            borderRadius: BorderRadius.circular(8),
            child: Text.rich(
              TextSpan(
                text: 'Sudah punya akun? ',
                style: textStyle.bodyMedium,
                children: [
                  TextSpan(
                    text: 'Masuk',
                    style: textStyle.bodyMedium?.copyWith(
                      color: color.primary,
                      fontWeight: FontWeight.w600,
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
