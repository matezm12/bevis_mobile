import 'package:bevis/blocs/blocs/settings_bloc/events/settings_events.dart';
import 'package:bevis/blocs/blocs/settings_bloc/settings_bloc.dart';
import 'package:bevis/blocs/blocs/settings_bloc/states/settings_states.dart';
import 'package:bevis/data/repositories/shared_prefs/shared_prefs_user_settings_repository.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:bevis/widgets/checkboxes/circular_checkbox.dart';
import 'package:bevis/widgets/scaffolds/bevis_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  SettingsBloc _settingsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _settingsBloc = SettingsBloc(
      userSettingsRepository: SharedPrefsUserSettingsRepository(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BevisScaffold(
      title: 'SETTINGS',
      // subtitle: 'lol',
      body: BlocProvider(
        create: (context) => _settingsBloc,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 40, left: 20),
                child: Text(
                  "Image Quality",
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorConstants.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 10, left: 50, right: 50),
                  child: BlocBuilder<SettingsBloc, SettingsPageState>(
                    builder: (context, state) {
                      if (state.imageQuality == null) {
                        return Container();
                      }

                      return Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  BlocProvider.of<SettingsBloc>(context)
                                      .add(ChangeDefaultImageQuality('low'));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    CircularCheckBox(
                                      onChanged: (bool) {
                                        BlocProvider.of<SettingsBloc>(context)
                                            .add(ChangeDefaultImageQuality(
                                                'low'));
                                      },
                                      isActive: state.imageQuality == "low"
                                          ? true
                                          : false,
                                    ),
                                    Text(
                                      "Low",
                                      style: TextStyle(
                                          color: ColorConstants.textColor,
                                          fontWeight:
                                              state.imageQuality == "low"
                                                  ? FontWeight.bold
                                                  : FontWeight.w400),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                height: 0,
                                thickness: 1,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    BlocProvider.of<SettingsBloc>(context).add(
                                        ChangeDefaultImageQuality('medium'));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      CircularCheckBox(
                                        onChanged: (bool) {
                                          BlocProvider.of<SettingsBloc>(context)
                                              .add(ChangeDefaultImageQuality(
                                                  'medium'));
                                        },
                                        isActive: state.imageQuality == "medium"
                                            ? true
                                            : false,
                                      ),
                                      Text(
                                        "Medium",
                                        style: TextStyle(
                                          color: ColorConstants.textColor,
                                          fontWeight:
                                              state.imageQuality == "medium"
                                                  ? FontWeight.bold
                                                  : FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                height: 0,
                                thickness: 1,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    BlocProvider.of<SettingsBloc>(context)
                                        .add(ChangeDefaultImageQuality('high'));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      CircularCheckBox(
                                        onChanged: (bool) {
                                          BlocProvider.of<SettingsBloc>(context)
                                              .add(ChangeDefaultImageQuality(
                                                  'high'));
                                        },
                                        isActive: state.imageQuality == "high"
                                            ? true
                                            : false,
                                      ),
                                      Text(
                                        "High",
                                        style: TextStyle(
                                          color: ColorConstants.textColor,
                                          fontWeight:
                                              state.imageQuality == "high"
                                                  ? FontWeight.bold
                                                  : FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                height: 0,
                                thickness: 1,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    BlocProvider.of<SettingsBloc>(context).add(
                                        ChangeDefaultImageQuality('original'));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      CircularCheckBox(
                                        onChanged: (bool) {
                                          BlocProvider.of<SettingsBloc>(context)
                                              .add(ChangeDefaultImageQuality(
                                                  'original'));
                                        },
                                        isActive:
                                            state.imageQuality == "original"
                                                ? true
                                                : false,
                                      ),
                                      Text(
                                        "Original",
                                        style: TextStyle(
                                          color: ColorConstants.textColor,
                                          fontWeight:
                                              state.imageQuality == "original"
                                                  ? FontWeight.bold
                                                  : FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  )),
              Container(
                margin: EdgeInsets.only(top: 10, left: 30),
                child: Text("Default Blockchain",
                    style: TextStyle(
                        fontSize: 16,
                        color: ColorConstants.textColor,
                        fontWeight: FontWeight.w600)),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                  top: 13,
                  left: 50,
                  right: 50,
                ),
                child: BlocBuilder<SettingsBloc, SettingsPageState>(
                  builder: (context, state) {
                    final defaultBlockchain = state.blockchain;

                    if (defaultBlockchain == null) {
                      return Container();
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                BlocProvider.of<SettingsBloc>(context)
                                    .add(ChangeDefaultBlockchain('BCH'));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  CircularCheckBox(
                                    onChanged: (bool) {
                                      BlocProvider.of<SettingsBloc>(context)
                                          .add(ChangeDefaultBlockchain('BCH'));
                                    },
                                    isActive: defaultBlockchain == "BCH"
                                        ? true
                                        : false,
                                  ),
                                  Text(
                                    "BCH",
                                    style: TextStyle(
                                      color: ColorConstants.textColor,
                                      fontWeight: defaultBlockchain == "BCH"
                                          ? FontWeight.bold
                                          : FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              height: 0,
                              thickness: 1,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  BlocProvider.of<SettingsBloc>(context)
                                      .add(ChangeDefaultBlockchain('ETH'));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    CircularCheckBox(
                                      onChanged: (bool) {
                                        BlocProvider.of<SettingsBloc>(context)
                                            .add(
                                                ChangeDefaultBlockchain('ETH'));
                                      },
                                      isActive: defaultBlockchain == "ETH"
                                          ? true
                                          : false,
                                    ),
                                    Text(
                                      "ETH",
                                      style: TextStyle(
                                        color: ColorConstants.textColor,
                                        fontWeight: defaultBlockchain == "ETH"
                                            ? FontWeight.bold
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              height: 0,
                              thickness: 1,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  BlocProvider.of<SettingsBloc>(context)
                                      .add(ChangeDefaultBlockchain('BTC'));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    CircularCheckBox(
                                      onChanged: (bool) {
                                        BlocProvider.of<SettingsBloc>(context)
                                            .add(
                                                ChangeDefaultBlockchain('BTC'));
                                      },
                                      isActive: defaultBlockchain == "BTC"
                                          ? true
                                          : false,
                                    ),
                                    Text(
                                      "BTC",
                                      style: TextStyle(
                                        color: ColorConstants.textColor,
                                        fontWeight: defaultBlockchain == "BTC"
                                            ? FontWeight.bold
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              height: 0,
                              thickness: 1,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  BlocProvider.of<SettingsBloc>(context)
                                      .add(ChangeDefaultBlockchain('LTC'));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    CircularCheckBox(
                                      onChanged: (bool) {
                                        BlocProvider.of<SettingsBloc>(context)
                                            .add(
                                                ChangeDefaultBlockchain('LTC'));
                                      },
                                      isActive: defaultBlockchain == "LTC"
                                          ? true
                                          : false,
                                    ),
                                    Text(
                                      "LTC",
                                      style: TextStyle(
                                        color: ColorConstants.textColor,
                                        fontWeight: defaultBlockchain == "LTC"
                                            ? FontWeight.bold
                                            : FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
