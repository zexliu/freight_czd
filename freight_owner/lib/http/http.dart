import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freightowner/generated/json/base/json_convert_content.dart';
import 'package:freightowner/model/token_entity.dart';
import 'package:freightowner/pages/login.dart';
import 'package:freightowner/global.dart';
import 'dart:convert' as convert;
import 'package:freightowner/utils/shared_preferences.dart';
import 'http_error.dart';

///http请求成功回调
typedef HttpSuccessCallback<T> = void Function(dynamic data);

///失败回调
typedef HttpFailureCallback = void Function(HttpError data);

///数据解析回调
typedef T JsonParse<T>(dynamic data);

class HttpManagerConfig {
  // static String baseUrl = "http://api.zex.nat300.top";
 static String baseUrl = "https://www.czdhy.com";
}

class HttpManager {
  static HttpManager _instance = HttpManager._internal();
  Dio _dio;
  CancelToken _cancelToken = new CancelToken();

  factory HttpManager() => _instance;

  static String clientId = "master_client";
  static String secret = "secret";

  ///通用全局单例，第一次使用时初始化
  HttpManager._internal() {
    if (null == _dio) {
      _dio = new Dio(new BaseOptions(
          baseUrl: HttpManagerConfig.baseUrl, connectTimeout: 30000));
      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          if (options.path == "/oauth/token") {
            options.headers['Authorization'] =
                "Basic " + _base64Encode('$clientId:$secret');
          } else {
            String accessToken =
                DefaultSharedPreferences.getInstance().get("ACCESS_TOKEN");
            if (accessToken != null) {
              options.headers['Authorization'] = "Bearer $accessToken";
            }
          }
          return options;
        },
        onError: (DioError err) async {
          if (err.type != DioErrorType.RESPONSE) {
            return err;
          }
          if (err.response.statusCode == 401 &&
              err.request.path != "/oauth/token") {
            String refreshToken =
                DefaultSharedPreferences.getInstance().get("REFRESH_TOKEN");
            if (refreshToken != null) {
              _dio.lock();
              return _refreshToken(refreshToken, err);
            } else {
              Navigator.of(Global.navigatorKey.currentContext)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return new LoginPage();
              }));
              return err;
            }
          }
          return HttpError.dioError(err);
        },
      ));
      _dio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }

  static HttpManager getInstance({String baseUrl}) {
    if (baseUrl == null) {
      return _instance._normal();
    } else {
      return _instance._baseUrl(baseUrl);
    }
  }

  //用于指定特定域名，比如cdn和kline首次的http请求
  HttpManager _baseUrl(String baseUrl) {
    if (_dio != null) {
      _dio.options.baseUrl = baseUrl;
    }
    return this;
  }

  //一般请求，默认域名
  HttpManager _normal() {
    if (_dio != null) {
      if (_dio.options.baseUrl != HttpManagerConfig.baseUrl) {
        _dio.options.baseUrl = HttpManagerConfig.baseUrl;
      }
    }
    return this;
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests({CancelToken token}) {
    token ?? _cancelToken.cancel("cancelled");
  }

  _base64Encode(String data) {
    var content = convert.utf8.encode(data);
    var digest = convert.base64Encode(content);
    return digest;
  }

  /// restful get 操作
  Future<T> get<T>(String path,
      {Map<String, dynamic> params,
      Options options,
      CancelToken cancelToken}) async {

    Response<T> response;
    response = await _dio.get(path,
        queryParameters: params,
        options: options,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  /// restful post 操作
  Future<T> post<T>(
    String path, {
    Map<String, dynamic> params,
    data,
    Options options,
    CancelToken cancelToken

  }) async {

    Response<T> response = await _dio.post(path,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: cancelToken ?? _cancelToken);

    return response.data;
  }

  /// restful put 操作
  Future<T> put<T>(
    String path, {
    data,
    Map<String, dynamic> params,
    Options options,
    CancelToken cancelToken,
  }) async {
    Response<T> response = await _dio.put(path,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  /// restful delete 操作
  Future<T> delete<T>(
    String path, {
    data,
    Map<String, dynamic> params,
    Options options,
    CancelToken cancelToken,
  }) async {
    Response<T> response = await _dio.delete(path,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  /// restful post form 表单提交操作
  Future<T> postForm<T>(
    String path, {
    Map<String, dynamic> params,
    Options options,
    CancelToken cancelToken,
  }) async {
    Response<T> response = await _dio.post(path,
        data: FormData.fromMap(params),
        options: options,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  Future _refreshToken(String refreshToken, DioError err) async {
    Dio dio = Dio(
        BaseOptions(baseUrl: HttpManagerConfig.baseUrl, connectTimeout: 30000));
//    dio.interceptors.add(LogInterceptor());
    return await dio
        .post("/oauth/token",
            queryParameters: {
              "grant_type": "refresh_token",
              "refresh_token": refreshToken
            },
            options: RequestOptions(headers: {
              "Authorization": "Basic " + _base64Encode('$clientId:$secret')
            }))
        .then((value) {
      TokenEntity tokenEntity = JsonConvert.fromJsonAsT(value.data);
      err.request.headers['Authorization'] =
          'Bearer ${tokenEntity.accessToken}';
      DefaultSharedPreferences.getInstance()
          .put("ACCESS_TOKEN", tokenEntity.accessToken);
      DefaultSharedPreferences.getInstance()
          .put("REFRESH_TOKEN", tokenEntity.refreshToken);
      _dio.unlock();
      return _dio.request(err.request.path,
          data: err.request.data,
          queryParameters: err.request.queryParameters,
          cancelToken: err.request.cancelToken,
          options: err.request,
          onSendProgress: err.request.onSendProgress,
          onReceiveProgress: err.request.onReceiveProgress);
    }).catchError((err) {
      DefaultSharedPreferences.getInstance().put("ACCESS_TOKEN", null);
      DefaultSharedPreferences.getInstance().put("REFRESH_TOKEN", null);
      _dio.unlock();
      Global.navigatorKey.currentState.pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) {
        return new LoginPage();
      }), (route) => false);
    });
  }
}
