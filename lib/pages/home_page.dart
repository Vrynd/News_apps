import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:news_app/utils/components/adaptive_scaffold.dart';
import 'package:news_app/utils/components/buttontypeaction.dart';
import 'package:news_app/utils/components/passwordformfield.dart';
import 'package:news_app/utils/components/emailformfield.dart';
import 'package:news_app/utils/helper/form_validator.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  // Warna dan Teks
  ColorScheme get color => Theme.of(context).colorScheme;
  TextTheme get textStyle => Theme.of(context).textTheme;

  final emailFocusNode = FocusNode();
  final emailController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final passwordController = TextEditingController();

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
                      'Selamat Datang!',
                      style: textStyle.titleLarge?.copyWith(
                        color: color.primary,
                      ),
                    ),
                    Text(
                      'Silahkan login untuk melanjutkan',
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
                      autofocus: true,
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
                        FocusScope.of(context).requestFocus(passwordFocusNode);
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
                  label: 'Login',
                  onPressed: () {},
                  textStyle: textStyle,
                  color: color,
                ),
                const SizedBox(height: 16),

                Text(
                  'atau',
                  style: textStyle.labelLarge?.copyWith(
                    color: color.outlineVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                ButtonTypeAction(
                  type: ButtonType.outline,
                  label: 'Lanjut Sebagai Anonimus',
                  onPressed: () {},
                  textStyle: textStyle,
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: color.surface,
        child: Center(
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(8),
            child: Text.rich(
              TextSpan(
                text: 'Belum punya akun? ',
                style: textStyle.bodyMedium,
                children: [
                  TextSpan(
                    text: 'Daftar',
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
