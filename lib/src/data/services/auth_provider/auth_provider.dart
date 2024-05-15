import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:diconnection/src/core/handler/utils_handler.dart';
import 'package:diconnection/src/core/messages/warning_message/warning_message.dart';
import 'package:diconnection/src/core/shared_preferences/delete_preferences.dart';
import 'package:diconnection/src/core/shared_preferences/get_preferences.dart';
import 'package:diconnection/src/core/shared_preferences/store_preferences.dart';
import 'package:diconnection/src/core/utils/constants.dart';
import 'package:diconnection/src/data/models/login_model/login_model.dart';
import 'package:diconnection/src/data/models/super_user_model/super_user_model.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

part 'auth_provider.g.dart';

@riverpod
class AsyncAuth extends _$AsyncAuth {
  Future<int> _fetchUser() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    //empty
    String hostAPI = UtilsHandler.apiLink == "" ? kHost : UtilsHandler.apiLink;
    int authCode = 0;
    //2020-04-01Z
    String token = await GetPreferences().getStoredAccessToken() ?? "";
    try {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        final json = await http.get(
            isHttp
                ? Uri.http(hostAPI, 'auth/protected')
                : Uri.https(hostAPI, 'auth/protected'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            }).timeout(const Duration(seconds: 60));
        if (json.statusCode == 200 || json.statusCode == 201) {
          authCode = 1;
        } else {
          //token expire need to login
          throw Exception(
              'Error: ${json.statusCode} \n Failed to Login from API');
        }
      } else {
        if (token.isNotEmpty) {
          authCode = 1;
        }
      }
    } catch (ex) {
      print(ex);
    }
    return authCode;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return _fetchUser();
    });
  }

  Future<void> isExpired() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      DeletePreferences().deleteAccessToken();
      return _fetchUser();
    });
  }

  Future<void> login(
      LoginM input, StreamController<int> events, BuildContext context) async {
    state = await AsyncValue.guard(() async {
      String hostAPI =
          UtilsHandler.apiLink == "" ? kHost : UtilsHandler.apiLink;
      events.add(0);
      //2020-04-01Z
      SuperUser user = const SuperUser(
          team: null, userId: "", username: "", accessToken: "");
      try {
        final json = await http
            .post(
                isHttp
                    ? Uri.http(hostAPI, 'auth/login')
                    : Uri.https(hostAPI, 'auth/login'),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
                body: jsonEncode(input.toJson()))
            .timeout(const Duration(seconds: 60));
        if (json.statusCode == 200 || json.statusCode == 201) {
          user = SuperUser.fromJson(
              Map<String, dynamic>.from(jsonDecode(json.body)));
          StorePreferences().storeAccessToken(user.accessToken!);
          events.add(1);
          UtilsHandler().passText.clear();
          return _fetchUser();
        } else {
          events.add(2);
          // ignore: use_build_context_synchronously
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => WarningMessage(
                    content: 'invalid username or password',
                    title: 'Invalid Credential',
                    function: () {
                      Navigator.pop(context);
                    },
                  ));
          throw Exception(
              'Error: ${json.statusCode} \n Failed to Login from API');
        }
      } catch (ex) {
        print(ex);
      }
      return 0;
    });
  }

  @override
  FutureOr<int> build() async {
    return _fetchUser();
  }
}
