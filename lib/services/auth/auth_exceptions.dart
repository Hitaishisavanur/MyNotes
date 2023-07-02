//login
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

//register
class EmailAlreadyInUseAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//generic
class GenericAuthException implements Exception {}

class UserNotLOggedInAuthException implements Exception {}
