// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_services.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: type=lint
// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main,avoid_redundant_argument_values

class _ApiServices implements ApiServices {
  _ApiServices(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= 'https://movies-api.accel.li/api/v2/';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<MoviesListResponse> getMoviesList(int pag) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'page': pag};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<MoviesListResponse>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'list_movies.json',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<dynamic>(_options);
    late MoviesListResponse _value;
    try {
      _value = MoviesListResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<MovieDetailsResponse> getMovieDetails(int movieID) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'movie_id': movieID};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<MovieDetailsResponse>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'movie_details.json',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<dynamic>(_options);
    late MovieDetailsResponse _value;
    try {
      _value = MovieDetailsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<MoviesListResponse> getMovieSuggestions(int movieID) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'movie_id': movieID};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<MoviesListResponse>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'movie_suggestions.json',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<dynamic>(_options);
    late MoviesListResponse _value;
    try {
      _value = MoviesListResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
