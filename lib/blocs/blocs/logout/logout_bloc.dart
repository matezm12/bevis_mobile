import 'package:bevis/blocs/states/base_state.dart';
import 'package:bevis/data/repositories/database_repositories/asset_sqlite_db_repository.dart';
import 'package:bevis/main.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogOutState> {
  AssetSqliteDatabaseRepositoryImpl _assetSqliteDatabaseRepository;

  LogoutBloc(this._assetSqliteDatabaseRepository) : super(LogOutState());

  @override
  Stream<LogOutState> mapEventToState(
    LogoutEvent event,
  ) async* {
    if (event is LogoutEvent) {
      isLogIn = false;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setBool("login", false);

      token = "";
      _assetSqliteDatabaseRepository.deleteAll();
      yield LogOutSuccessState();
    }
  }
}
