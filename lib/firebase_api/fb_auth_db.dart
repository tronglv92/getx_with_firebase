import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_getx_boilerplate/models/response/error_response.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';
import 'dart:math';

import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
enum AccountType { EMAIL, GOOGLE, FACEBOOK, APPLE }
class FirebaseAuthDatabase {
  FirebaseAuthDatabase();
  final FirebaseAuth _auth= FirebaseAuth.instance;
  AccountType accountType = AccountType.EMAIL;

  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      accountType = AccountType.EMAIL;
      return userCredential;
    } on FirebaseAuthException catch (e) {
      logger.d('Error on the sign in = ');
      logger.d('Failed with error code: ${e.code}');
      logger.d(e.message);
      logger.d('========================== ');
      String? message = e.message;

      throw ErrorResponse(message: message, code: e.code);
    } catch (e) {
      logger.d('Error signInWithApple3 = ' + e.toString());
      throw ErrorResponse(message: e.toString());
    }
  }

  //Method to handle user sign in using email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      accountType = AccountType.EMAIL;
      return userCredential;
    } on FirebaseAuthException catch (e) {
      logger.d('Error on the sign in = ');
      logger.d('Failed with error code: ${e.code}');
      logger.d(e.message);
      logger.d('========================== ');
      String? message = e.message;
      if (e.code == 'user-not-found') {
        message = 'You have not register yet!';
      }
      throw ErrorResponse(message: message, code: e.code);
    } catch (e) {
      logger.d('Error signInWithApple3 = ' + e.toString());
      throw ErrorResponse(message: e.toString());
    }
  }

  //Method to handle password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    // await _auth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
      );
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      accountType = AccountType.GOOGLE;

      return userCredential;
    } on FirebaseAuthException catch (e) {
      logger.d('Error on the sign in = ');
      logger.d('Failed with error code: ${e.code}');
      logger.d(e.message);
      logger.d('========================== ');
      throw ErrorResponse(message: e.message, code: e.code);
    } catch (e) {
      logger.d('Error on the sign in3 = ' + e.toString());
      throw ErrorResponse(message: e.toString());
    }
  }

  Future<UserCredential?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.status == LoginStatus.success) {
        // Create a credential from the access token
        if (loginResult.accessToken?.token == null) return null;
        final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

        // Once signed in, return the UserCredential
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
        accountType = AccountType.FACEBOOK;
        return userCredential;
      } else if (loginResult.status == LoginStatus.cancelled) {
        throw ErrorResponse(message: 'User cancel login by facebook');
      } else {
        throw ErrorResponse(message: 'Have error! Please login again!');
      }
    } on FirebaseAuthException catch (e) {
      logger.d('Error signInWithFacebook = ');
      logger.d('Failed with error code: ${e.code}');
      logger.d(e.message);
      logger.d('========================== ');

      throw ErrorResponse(message: e.message, code: e.code);
    } catch (e) {
      logger.d('Error signInWithApple3 = ' + e.toString());
      throw ErrorResponse(message: e.toString());
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    const String charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final Random random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final List<int> bytes = utf8.encode(input);
    final Digest digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      if (Platform.isIOS) {
        // To prevent replay attacks with the credential returned from Apple, we
        // include a nonce in the credential request. When signing in with
        // Firebase, the nonce in the id token returned by Apple, is expected to
        // match the sha256 hash of `rawNonce`.
        final String rawNonce = generateNonce();
        final String nonce = sha256ofString(rawNonce);

        // Request credential for the currently signed in Apple account.
        final AuthorizationCredentialAppleID appleCredential =
        await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
        );

        // Create an `OAuthCredential` from the credential returned by Apple.
        final OAuthCredential oauthCredential =
        OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          rawNonce: rawNonce,
        );

        // Sign in the user with Firebase. If the nonce we generated earlier does
        // not match the nonce in `appleCredential.identityToken`, sign in will fail.
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);
        accountType = AccountType.APPLE;
        return userCredential;
      } else if (Platform.isAndroid) {
        const String redirectURL =
            'https://stitch-five-lilac.glitch.me/callbacks/sign_in_with_apple';
        const String clientID = "2UD3WQS2VS.com.tronglv.getfirebase";
        final AuthorizationCredentialAppleID appleIdCredential =
        await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            webAuthenticationOptions: WebAuthenticationOptions(
                clientId: clientID, redirectUri: Uri.parse(redirectURL)));

        // Create an `OAuthCredential` from the credential returned by Apple.
        final OAuthCredential oauthCredential =
        OAuthProvider("apple.com").credential(
          idToken: appleIdCredential.identityToken,
          accessToken: appleIdCredential.authorizationCode,
        );

        // Sign in the user with Firebase. If the nonce we generated earlier does
        // not match the nonce in `appleCredential.identityToken`, sign in will fail.
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);
        accountType = AccountType.APPLE;
        return userCredential;
      }
      return null;
    } on SignInWithAppleAuthorizationException catch (e) {
      logger.d('Error signInWithApple1 = ');
      logger.d('Failed with error code: ${e.code}');
      logger.d(e.message);
      logger.d('========================== ');
      if (e.code == AuthorizationErrorCode.canceled) {
        throw ErrorResponse(message: 'You cancel your login');
      } else if (e.code == AuthorizationErrorCode.failed) {
        throw ErrorResponse(message: 'You failed your login');
      } else if (e.code == AuthorizationErrorCode.invalidResponse) {
        throw ErrorResponse(message: 'invalidResponse');
      } else {
        throw ErrorResponse(message: e.message);
      }
    } on FirebaseAuthException catch (e) {
      logger.d('Error signInWithApple2 = ');
      logger.d('Failed with error code: ${e.code}');
      logger.d(e.message);
      logger.d('========================== ');

      throw ErrorResponse(message: e.message, code: e.code);
    } catch (e) {
      logger.d('Error signInWithApple3 = ' + e.toString());
      throw ErrorResponse(message: e.toString());
    }
  }

  Future<void> signOut() async {

    final GoogleSignIn _googleSignIn = GoogleSignIn();
     await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
    await FirebaseAuth.instance.signOut();
  }
}