import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeAuthRepository {

  final _authState = InMemoryStore<AppUser?>(null);

  Stream<AppUser?> authStateChanges() => _authState.stream;
  AppUser? get currentUser => _authState.value;

  Future<void> signInWithEmailAndPassword(String email, String password) async{
    if(currentUser == null) {
      _createUser(email);
    }

  }

  void _createUser(String email) {
    _createUser(email);
  } 

  Future<void> createUserWithEmailAndPassword(String email, String password) async{
    _createUser(email);
  }

  Future<void> signOut() async{    
    _authState.value = null;    
  }  

  void dispose() => _authState.close();
}

/// create a provider for the respository and ensure the stream for the inMem store is disposed when not used anymore
final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {  
  final authRepository = FakeAuthRepository();
  ref.onDispose(() => authRepository.dispose());
  return authRepository;
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref){
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});