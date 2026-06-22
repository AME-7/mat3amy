import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mat3amy/core/firebase/firestore_provider.dart';
import 'package:mat3amy/core/services/firebase/failure/failure.dart';
import 'package:mat3amy/core/services/local/shared_pref.dart';
import 'package:mat3amy/features/auth/presentation/model/auth_params.dart';
import 'package:mat3amy/features/auth/presentation/model/user_model.dart';

class AuthRepo {
  static Future<Either<Failure, Unit>> login(AuthParams params) async {
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: params.email,
            password: params.password,
          );

      await SharedPref.cacheUserId(credential.user?.uid ?? '');

      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return left(Failure(massage: 'الحساب غير موجود'));
      }

      if (e.code == 'wrong-password') {
        return left(Failure(massage: 'كلمة المرور غير صحيحة'));
      }

      if (e.code == 'invalid-email') {
        return left(Failure(massage: 'البريد الإلكتروني غير صالح'));
      }

      return left(Failure(massage: e.message ?? 'حدث خطأ أثناء تسجيل الدخول'));
    } catch (e) {
      return left(Failure(massage: 'حدث خطأ غير متوقع'));
    }
  }

  static Future<Either<Failure, Unit>> register(AuthParams params) async {
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: params.email,
            password: params.password,
          );

      User? user = credential.user;

      await user?.updateDisplayName(params.name);

      await SharedPref.cacheUserId(user?.uid ?? '');

      final userData = UserModel(
        uid: user?.uid,
        name: params.name,
        email: params.email,
        image: '',
        phone: '',
        city: '',
        bio: '',
      );
      await FirebaseProvider.addUser(userData);

      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return left(Failure(massage: 'كلمة المرور ضعيفة'));
      }

      if (e.code == 'email-already-in-use') {
        return left(Failure(massage: 'هذا البريد الإلكتروني مستخدم بالفعل'));
      }

      if (e.code == 'invalid-email') {
        return left(Failure(massage: 'البريد الإلكتروني غير صالح'));
      }

      return left(Failure(massage: e.message ?? 'حدث خطأ أثناء إنشاء الحساب'));
    } catch (e) {
      return left(Failure(massage: 'حدث خطأ غير متوقع'));
    }
  }

  static Future<Either<Failure, Unit>> logout() async {
    try {
      await FirebaseAuth.instance.signOut();

      await SharedPref.removeData(SharedPref.kUserId);

      return right(unit);
    } catch (e) {
      return left(Failure(massage: 'حدث خطأ أثناء تسجيل الخروج'));
    }
  }

  static Future<Either<Failure, Unit>> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      return right(unit);
    } on FirebaseAuthException catch (e) {
      return left(
        Failure(massage: e.message ?? 'فشل إرسال رابط إعادة تعيين كلمة المرور'),
      );
    } catch (e) {
      return left(Failure(massage: 'حدث خطأ غير متوقع'));
    }
  }
}
