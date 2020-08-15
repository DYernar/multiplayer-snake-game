import 'package:brain_wars/features/model/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final GoogleSignIn _googleSignIn;

  UserRepository(this._googleSignIn);

  Future<GoogleSignInAccount> signInWithGoogle() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: <String>[
          'email',
        ],
      );

      GoogleSignInAccount _currentUser =
          await _googleSignIn.signIn().catchError((error) {
        print(error);
        return null;
      });

      await saveUser(_currentUser);
      return _currentUser;
    } catch (err) {}
  }

  Future<void> saveUser(GoogleSignInAccount _currentUser) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", _currentUser.displayName);
    await prefs.setString("email", _currentUser.email);
    await prefs.setString("photoUrl", _currentUser.photoUrl);
  }

  Future<void> signOut() async {
    await deleteUser();
    Future.wait([
      _googleSignIn.signOut(),
    ]);
  }

  Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("displayname", "");
    await prefs.setString("email", "");
    await prefs.setString("img", "");
  }

  Future<bool> isSignedIn() async {
    final user = await getUserPref();

    if (user.username == "") {
      return false;
    }

    return true;
  }

  Future<User> getUserPref() async {
    final prefs = await SharedPreferences.getInstance();

    final username = prefs.getString("displayname");
    final email = prefs.getString("email");
    final img = prefs.getString("img");

    return User(username, email, img);
  }
}
