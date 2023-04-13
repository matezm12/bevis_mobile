import 'package:bevis/blocs/blocs/write/write_bloc.dart';
import 'package:bevis/blocs/events/write_bloc_events.dart';
import 'package:bevis/pages/main_flow/scan_code_page.dart';
import 'package:bevis/pages/write/select_file_option.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:bevis/widgets/buttons/red_bevis_button.dart';
import 'package:bevis/widgets/scaffolds/bevis_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class WritePageContent extends StatelessWidget {
  WritePageContent({@required this.assetId});

  final String assetId;

  @override
  Widget build(BuildContext context) {
    return BevisScaffold(
      title: 'WRITE',
      subtitle: 'to the blockchain',
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: 600,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 46,
                  right: 46,
                  top: 36,
                  bottom: 61,
                ),
                child: Column(
                  children: [
                    assetId != null
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text('You are adding assets to $assetId'),
                          )
                        : Container(),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        SelectFileOption(
                          title: 'Take a photo',
                          icon: SvgPicture.asset(
                            'assets/select_file_page/camera.svg',
                          ),
                          onPressed: () {
                            BlocProvider.of<WriteBloc>(context)
                                .add(TakePicture());
                          },
                        ),
                        SelectFileOption(
                          title: 'Select file',
                          icon: SvgPicture.asset(
                            'assets/select_file_page/select_file.svg',
                          ),
                          onPressed: () {
                            BlocProvider.of<WriteBloc>(context)
                                .add(PickFileFromGallery());
                          },
                        ),
                        SelectFileOption(
                          title: 'Scan Asset',
                          icon: SvgPicture.asset(
                            'assets/select_file_page/scan.svg',
                          ),
                          onPressed: () async {
                            final assetId =
                                await Navigator.of(context).push<String>(
                              MaterialPageRoute(builder: (context) {
                                return ScanCodePage();
                              }),
                            );

                            if (assetId != null) {
                              BlocProvider.of<WriteBloc>(context)
                                  .add(SetAssetId(assetId));
                            }
                          },
                        ),
                        SelectFileOption(
                          title: 'Select photo/video',
                          icon: SvgPicture.asset(
                            'assets/select_file_page/select_from_gallery.svg',
                          ),
                          onPressed: () {
                            BlocProvider.of<WriteBloc>(context)
                                .add(PickMediaFileFromGallery());
                          },
                        ),
                        SelectFileOption(
                          title: 'Record Audio',
                          icon: SvgPicture.asset(
                            'assets/select_file_page/record_audio.svg',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  bottom: ScreenUtil().setHeight(6),
                  top: ScreenUtil().setHeight(33)),
              alignment: Alignment.center,
              child: Text(
                "Go Back to",
                style: TextStyle(color: ColorConstants.textColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
              child: RedBevisButton(
                onPressed: () => Navigator.of(context).pop(),
                title: 'My Assets',
              ),
            )
          ],
        ),
      ),
    );
  }
}
