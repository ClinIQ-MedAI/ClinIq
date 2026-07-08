import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cliniq/core/utils/success.dart';

final verifyResetCodeProvider =
    AsyncNotifierProvider.autoDispose<VerifyResetCodeNotifier, Success?>(
      VerifyResetCodeNotifier.new,
    );

class VerifyResetCodeNotifier extends AsyncNotifier<Success?> {
  String? _email;
  String? _otp;

  @override
  Future<Success?> build() async {
    return null;
  }

  String? get email => _email;
  String? get otp => _otp;

  Future<void> verifyResetCode({
    required String email,
    required String code,
  }) async {
    _email = email;
    _otp = code;
    state = const AsyncLoading();
    await Future.delayed(const Duration(seconds: 1));
    state = const AsyncData(Success());
    // await ref
    //     .read(getAuthRepoProvider)
    //     .verifyResetCode(email: email, code: code)
    //     .onSuccess((_) async {
    //       state = const AsyncData(Success());
    //     })
    //     .onFailure((l) {
    //       state = AsyncError(l, StackTrace.current);
    //     });
  }
}
