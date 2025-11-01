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

/// 新規登録画面
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    // バリデーション
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // フォーカスを外す（キーボードを閉じる）
    context.unfocus();

    try {
      final signUp = ref.read(signUpProvider);
      await signUp(
        _emailController.text.trim(),
        _passwordController.text,
        _userNameController.text.trim(),
      );

      // 登録成功 → プロジェクト選択画面へ
      if (mounted) {
        context.showSuccessSnackbar('登録が完了しました');
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

  void _handleBackToLogin() {
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authLoadingProvider);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: isLoading ? null : _handleBackToLogin,
          ),
        ),
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
                        AppStrings.register,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppSizes.spaceXxl),

                      // ユーザー名
                      TextFormField(
                        controller: _userNameController,
                        keyboardType: TextInputType.name,
                        autofillHints: const [AutofillHints.name],
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          labelText: AppStrings.userName,
                          hintText: AppStrings.placeholderUserName,
                          prefixIcon: const Icon(Icons.person_outlined),
                        ),
                        validator: Validators.validateUserName,
                      ),
                      const SizedBox(height: AppSizes.spaceLg),

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
                        autofillHints: const [AutofillHints.newPassword],
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
                          helperText: 'パスワードは8文字以上で入力してください',
                          helperStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: AppSizes.fontXs,
                          ),
                        ),
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: AppSizes.spaceXxl),

                      // 登録ボタン
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
                                  AppStrings.register,
                                  style: const TextStyle(
                                    fontSize: AppSizes.fontMd,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: AppSizes.spaceXl),

                      // ログイン画面へ戻るリンク
                      TextButton(
                        onPressed: isLoading ? null : _handleBackToLogin,
                        child: Text(
                          'アカウントをお持ちの方はこちら',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: AppSizes.fontSm,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white.withValues(
                              alpha: 0.9,
                            ),
                          ),
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
