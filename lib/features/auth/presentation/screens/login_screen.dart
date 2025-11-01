import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../providers/auth_state_provider.dart';

/// ログイン画面
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // バリデーション
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // フォーカスを外す（キーボードを閉じる）
    context.unfocus();

    try {
      final login = ref.read(loginProvider);
      await login(_emailController.text.trim(), _passwordController.text);

      // ログイン成功 → プロジェクト選択画面へ
      if (mounted) {
        context.go(AppRoutes.projectSelection);
      }
    } catch (e) {
      // エラーは authErrorProvider に設定済み
      if (mounted) {
        final errorMessage = ref.read(authErrorProvider);
        if (errorMessage != null) {
          context.showErrorSnackbar(errorMessage);
        }
      }
    }
  }

  void _handleRegister() {
    context.go(AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authLoadingProvider);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.paddingXl),
              child: LiquidGlassContainer(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.paddingXxl),
                opacity: 0.3,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // タイトル
                      Text(
                        AppStrings.appName,
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppSizes.spaceXxl),

                      // メールアドレス
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          labelText: AppStrings.email,
                          hintText: AppStrings.placeholderEmail,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: AppSizes.spaceLg),

                      // パスワード
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        autofillHints: const [AutofillHints.password],
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          labelText: AppStrings.password,
                          hintText: AppStrings.placeholderPassword,
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: AppSizes.spaceXxl),

                      // ログインボタン
                      SizedBox(
                        width: double.infinity,
                        height: AppSizes.buttonHeightLg,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.3,
                            ),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusMd,
                              ),
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.6),
                                width: 1.5,
                              ),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  AppStrings.loginButton,
                                  style: const TextStyle(
                                    fontSize: AppSizes.fontMd,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      // 区切り線
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSizes.spaceLg,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(color: Colors.white, thickness: 1),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.paddingMd,
                              ),
                              child: Text(
                                'または',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppSizes.fontSm,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(color: Colors.white, thickness: 1),
                            ),
                          ],
                        ),
                      ),

                      // 新規登録ボタン
                      SizedBox(
                        width: double.infinity,
                        height: AppSizes.buttonHeightLg,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.8,
                            ),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusMd,
                              ),
                            ),
                          ),
                          child: Text(
                            AppStrings.registerButton,
                            style: const TextStyle(
                              fontSize: AppSizes.fontMd,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSizes.spaceXxl),

                      // コピーライト
                      Container(
                        padding: const EdgeInsets.all(AppSizes.paddingMd),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMd,
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          AppStrings.copyright,
                          style: TextStyle(
                            fontSize: AppSizes.fontXs,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
