import 'package:bevis/pages/asset_info/read_asset_info_page.dart';
import 'package:bevis/pages/login/login_page.dart';
import 'package:bevis/pages/main_flow/scan_code_page.dart';
import 'package:bevis/pages/onboarding/widgets/quick_scan_button.dart';
import 'package:bevis/pages/signup/signup_page.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:bevis/widgets/dialogs/bevis_info_dialog.dart';
import 'package:bevis/widgets/dots_indicator.dart';
import 'package:bevis/widgets/tutorial_screen/tutorial_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';

class TutorialPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final _pageController = PageController();

  static const tutorialIconWidth = 76.0;

  final _pages = [
    TutorialPageView(
      image: Image.asset(
        "assets/logo_bevis.png",
        width: tutorialIconWidth,
        color: Colors.white,
        fit: BoxFit.fitWidth,
      ),
      text:
          'Bevis is Blockchain for Everyone!\nThere are so many great ways to use Bevis\nscroll for a few ideas!',
      background: "assets/tutorial/first_intro_page_bg.png",
    ),
    TutorialPageView(
      image: Image.asset(
        "assets/logo_bevis.png",
        width: tutorialIconWidth,
        color: Colors.white,
        fit: BoxFit.fitWidth,
      ),
      text:
          'That expensive item you bought?\n Snap a picture of the goods and receipt \n for warranty verification',
      background: "assets/tutorial/second_intro_page_bg.png",
    ),
    TutorialPageView(
      image: Image.asset(
        "assets/logo_bevis.png",
        width: tutorialIconWidth,
        color: Colors.white,
        fit: BoxFit.fitWidth,
      ),
      text:
          'Record your university diploma,\n proving your pedigree\nto prospective employers.',
      background: "assets/tutorial/third_intro_page_bg.png",
    ),
    TutorialPageView(
      image: Image.asset(
        "assets/logo_bevis.png",
        width: tutorialIconWidth,
        color: Colors.white,
        fit: BoxFit.fitWidth,
      ),
      text:
          'That track you wrote?\nRecord the audio and prove that it’s yours.',
      background: "assets/tutorial/fourth_intro_page_bg.png",
    ),
    TutorialPageView(
      image: Image.asset(
        "assets/logo_bevis.png",
        width: tutorialIconWidth,
        color: Colors.white,
        fit: BoxFit.fitWidth,
      ),
      text:
          'That brilliant idea you sketched\n use Bevis like the poor man’s patent.',
      background: "assets/tutorial/fifth_intro_page_bg.png",
    ),
  ];

  @override
  void initState() {
    super.initState();
    Permission.camera.request();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.toString() + " size");
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(375, 723),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: _buildTutorialPages(),
            ),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(
                        15,
                      ),
                    ),
                    height: ScreenUtil().setHeight(40),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          ColorConstants.colorAppRed,
                        ),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      child: Container(
                        width: 200,
                        height: ScreenUtil().setHeight(30),
                        alignment: Alignment.center,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setHeight(20),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      onPressed: _showSignUp,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                    child: TextButton(
                      onPressed: _showLogin,
                      child: Container(
                        width: 100,
                        height: ScreenUtil().setHeight(40),
                        alignment: Alignment.center,
                        child: Text(
                          "Log in",
                          style: TextStyle(
                            color: ColorConstants.textColor,
                            fontWeight: FontWeight.w400,
                            fontSize: ScreenUtil().setHeight(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(50),
                      bottom: ScreenUtil().setHeight(13),
                    ),
                    height: ScreenUtil().setHeight(50),
                    child: QuickScanButton(
                      onPressed: () async {
                        PermissionStatus isShown =
                            await Permission.camera.status;

                        switch (isShown) {
                          case PermissionStatus.granted:
                            {
                              print("granted");
                              _showScanner();
                            }
                            break;
                          case PermissionStatus.denied:
                            {
                              print("denieds");

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return BevisInfoDialog(
                                    title:
                                        'Please allow the app to access camera to scan QR code',
                                    onOkPressed: () {
                                      Navigator.of(context).pop();
                                      openAppSettings();
                                    },
                                  );
                                },
                              );
                            }
                            break;
                          case PermissionStatus.restricted:
                            break;
                          case PermissionStatus.limited:
                            break;
                          case PermissionStatus.permanentlyDenied:
                            break;
                        }
                      },
                    ),
                  ),
                  Text(
                    "Learn why it's better to create an account",
                    style: TextStyle(
                      color: ColorConstants.textColor,
                      fontSize: ScreenUtil().setHeight(12),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showScanner() async {
    final scannedWalletAddress = await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 500),
            alignment: Alignment.center,
            child: ScanCodePage()));
    if (scannedWalletAddress != null) {
      debugPrint('Did scan coin with address: $scannedWalletAddress');
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          duration: Duration(milliseconds: 500),
          alignment: Alignment.center,
          child: ReadAssetInfoPage(
            walletAddress: scannedWalletAddress,
          ),
        ),
      );
    }
  }

  void _showSignUp() async {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        duration: Duration(milliseconds: 500),
        alignment: Alignment.center,
        child: SignUpPage(),
      ),
    );
  }

  void _showLogin() async {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 500),
            alignment: Alignment.center,
            child: LoginPage()));
  }

  Widget _buildTutorialPages() {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 1.5,
          child: PageView(
            controller: _pageController,
            children: _pages,
            onPageChanged: (pageIndex) {},
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: DotsIndicator(
            controller: _pageController,
            itemCount: _pages.length,
            onPageSelected: (int page) {
              _pageController.animateToPage(
                page,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
          ),
        ),
      ],
    );
  }
}
