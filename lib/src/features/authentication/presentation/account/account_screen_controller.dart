import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreenController extends StateNotifier<AsyncValue<void>> {
  AccountScreenController({required this.authRepository})
      : super(const AsyncValue<void>.data(null));

  final FakeAuthRepository authRepository;

  Future<bool> signOut() async {
    // try {
    //   state = const AsyncValue<void>.loading();
    //   await authRepository.signOut();
    //   state = const AsyncValue<void>.data(null);
    //   return true;
    // } catch (e) {
    //   state = AsyncError(e);
    //   return false;
    // }

    // same as above, but simpler

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authRepository.signOut());
    return state.hasError == false;
  }
}

final accountScreenControllerProvider = StateNotifierProvider.autoDispose<AccountScreenController, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AccountScreenController(authRepository: authRepository);
});
