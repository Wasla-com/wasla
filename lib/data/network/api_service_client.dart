import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';
import 'package:wasla/data/network/end_points_manager.dart';
import 'package:wasla/data/responses/login_response.dart';

part 'api_service_client.g.dart';

@RestApi(baseUrl: EndPointsManager.baseUrl)
abstract class ApiServiceClient {
  factory ApiServiceClient(Dio dio, {String baseUrl}) = _ApiServiceClient;

  @POST(EndPointsManager.login)
  @Headers(HeadersManager.loginHeaders)
  Future<LoginResponse> login({
    @Field("phoneNumber") required String phone,
    @Field("password") required String password,
  });
}
