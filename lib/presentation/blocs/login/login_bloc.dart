import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pda/config.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/services/shared_pref_service.dart';
import 'package:pda/data/data_providers/api/api_client.dart';
import 'package:pda/data/repository/repository.dart';
import 'package:pda/domain/entities/user.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/exceptions/server_exception.dart';
import 'package:pda/domain/repository/repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.empty()) {
    on<Login>(_login);
  }

  FutureOr<void> _login(Login event, Emitter<LoginState> emit) async {
    try {
      emit(state.copyWith(loginStatus: AppStatus.loading));

      Repository repository = Dependencies.get<Repository>();
      UserEntity user =
          await repository.login(event.email, event.password, event.company);
      Dependencies.put(user);

      ApiClient apiClient = ApiClientIml(baseUrl: baseUrl, token: user.token);

      Repository newRepository =
          (Dependencies.get<Repository>() as RepositoryIml)
              .copyWith(apiClient: apiClient);
      Dependencies.put(newRepository);

      SharedPrefService sharedPrefService =
          Dependencies.get<SharedPrefService>();
      sharedPrefService.putValue(SharedPrefService.token, user.token);
      sharedPrefService.putValue(SharedPrefService.company, event.company);
      sharedPrefService.putValue(SharedPrefService.idCamion, user.idCamion);

      int company = Dependencies.get<SharedPrefService>()
          .getValue(SharedPrefService.company, 0);
      print("🔍 [DEBUG] company value after login = $company");

      emit(state.copyWith(
        loginStatus: AppStatus.success,
      ));
    } on NetworkConnectivityException catch (ex) {
      emit(state.copyWith(loginStatus: AppStatus.error, isOffline: true));
    } on ServerException catch (ex) {
      emit(state.copyWith(loginStatus: AppStatus.error, error: ex.toString()));
    } catch (ex) {
      emit(state.copyWith(loginStatus: AppStatus.error));
    }
  }
}
