import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("Mock Authentication", () {
    final provider = MockAuthProvider();
    test("should not be initialized to begin with", () {
      expect(provider.isInitialized, false);
    });

    test('cannot logout if not initialized', () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test("should be able to initialized", () async {
      await provider.initialize();
      expect(provider._isInitialized, true);
    });

    test("user should be null after initialization", () {
      expect(provider.currentUser, null);
    });

    test(
      "should be able to initialize in2 sec",
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
    test("create user should delegate to login", () async {
      final badEmailUser = provider.createUser(
        email: "foo@bar.com",
        password: "anypassword",
      );

      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPassword = provider.createUser(
        email: "anyemail",
        password: "foobar",
      );

      expect(badPassword,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(email: "foo", password: "bar");
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test("logged in user should be able to get verifed", () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test("should be able to logout and login ", () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );

      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );

    // TODO: implement createUser
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == "foo@bar.com") throw UserNotFoundAuthException();
    if (password == "foobar") throw WrongPasswordAuthException();
    const user =
        AuthUser(isEmailVerified: false, email: 'foo@bar.com', id: 'my_id');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
      id: 'my_id',
      isEmailVerified: true,
      email: 'foo@bar.com',
    );
    _user = newUser;
  }
}
