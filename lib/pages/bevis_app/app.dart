import 'package:bevis/app/app_config.dart';
import 'package:bevis/blocs/app_init_bloc/app_init_bloc.dart';
import 'package:bevis/blocs/app_init_bloc/events/app_init_events.dart';
import 'package:bevis/blocs/blocs/login/login_bloc.dart';
import 'package:bevis/blocs/blocs/sign_up_email_bloc/sign_up_email_bloc.dart';
import 'package:bevis/data/repositories/network_repositories/clients/http_rest_client.dart';
import 'package:bevis/data/repositories/network_repositories/http/login_network_repository_impl.dart';
import 'package:bevis/data/repositories/network_repositories/http/sign_up_network_respository_imp.dart';
import 'package:bevis/factories/bevis_components_factory/bevis_components_factory.dart';
import 'package:bevis/factory_producers/bevis_components_factory_producer.dart';
import 'package:bevis/pages/bevis_app/app_widget.dart';
import 'package:bevis/widgets/providers/bevis_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class BevisApp extends StatefulWidget {
  final Widget initialPage;

  BevisApp({@required this.initialPage});

  @override
  State<StatefulWidget> createState() => _BevisAppState();
}

class _BevisAppState extends State<BevisApp> {
  final _initAppBloc = AppInitBloc(
    bevisComponentsFactoryProducer: BevisComponentsFactoryProducer(),
  );

  @override
  void initState() {
    super.initState();

    _initAppBloc.add(InitAppEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignUpEmailBloc>(
          create: (context) => SignUpEmailBloc(
              networkRepo: SignUpNetworkRepositoryImp(
            networkConfig: AppConfig.getInstance().networkConfig,
            client: HttpRestClient(
              httpClient: Client(),
            ),
          )),
        ),
        BlocProvider<LoginEmailBloc>(
          create: (context) => LoginEmailBloc(
            networkRepo: LoginNetworkRepositoryImpl(
              networkConfig: AppConfig.getInstance().networkConfig,
              client: HttpRestClient(
                httpClient: Client(),
              ),
            ),
          ),
        ),
      ],
      child: BevisProvider<BevisComponentsFactory>(
        create: (context) {
          return BevisComponentsFactoryProducer().getFactory();
        },
        child: AppWidget(
          initialPage: widget.initialPage,
        ),
      ),
    );
  }
}
