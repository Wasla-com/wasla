// base dirs
const String _assets = 'assets';
const String _images = '/images';
const String _json = '/json';
const String _animation = '/animation';

//base paths
const String _imagePath = _assets + _images;
const String _jsonPath = _assets + _json;
const String _animationPath = _assets + _animation;

class AssetsProvider {
  ///dirs
  //images_dirs
  static const String _logo = '$_imagePath/logo';
  static const String _onboarding = '$_imagePath/onboarding';
  static const String _svg = '$_imagePath/svg';
  static const String _background = '$_imagePath/background';

  //animation_dirs
  static const String _rive = '$_animationPath/rive';

  //rive
  static const String loginBear = '$_rive/login_bear.riv';

  //images
  static const String logo = '$_logo/logo.png';
  static const String logo1 = '$_logo/logo1.png';
  static const String logo2 = '$_logo/logo2.png';
  static const String logoIcon = '$_logo/logo_icon.png';
  static const String logoTitle = '$_logo/logo_title.png';
  static const String onboarding1 = '$_onboarding/welcome.png';
  static const String onboarding2 = '$_onboarding/ticket.png';
  static const String onboarding3 = '$_onboarding/delivery.png';
  static const String onboarding4 = '$_onboarding/ads.png';
  static const String onboarding5 = '$_onboarding/following.png';
  static const String onboarding6 = '$_onboarding/private_bus.png';
  static const String startNowBackground =
      '$_background/background_start_now.png';

  //svg
  static const String arrowDown1 = '$_svg/arrow_down1.svg';
  static const String arrowDown2 = '$_svg/arrow_down2.svg';
  static const String arrowDown3 = '$_svg/right_arrow_ic.svg';
}
