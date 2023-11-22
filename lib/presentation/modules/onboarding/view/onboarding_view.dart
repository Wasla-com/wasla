import 'package:concentric_transition/concentric_transition.dart';
import 'package:wasla/app/shared/common/common_libs.dart';
import 'package:wasla/presentation/widgets/progress_painter.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveManager(context);
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingInitial) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: BlocBuilder<OnChangeOnBoardingPageCubit,
                OnChangeOnBoardingPageState>(
              builder: (onChangeContext, onChangeState) {
                return ConcentricPageView(
                  itemCount: state.onboardingPages.itemsCount,
                  onFinish: () {
                    _onFinish(context);
                  },
                  scaleFactor: AppSize.s2,
                  direction: Axis.vertical,
                  verticalPosition: 0.87,
                  physics: const BouncingScrollPhysics(),
                  onChange: (index) {
                    context
                        .read<OnChangeOnBoardingPageCubit>()
                        .changeIndex(index);
                  },
                  colors: state.onboardingPages.pagesColors,
                  radius: responsive.screenWidth * AppSize.s0_075,
                  nextButtonBuilder: (context) => _buildNextButton(
                    responsive,
                    onChangeState,
                    state.onboardingPages.itemsCount,
                  ),
                  itemBuilder: (index) {
                    final page =
                        state.onboardingPages.getOnboardingPageData(index);
                    return _page(context, page: page, index: index);
                  },
                );
              },
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildNextButton(
    ResponsiveManager responsive,
    OnChangeOnBoardingPageState onChangeState,
    int itemsCount,
  ) {
    const iconColor = ColorsManager.paleVioletRed;
    return SizedBox(
      width: responsive.screenWidth * AppSize.s2,
      height: responsive.screenWidth * AppSize.s2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          //indicator
          _buildCustomPaintIndicator(responsive, onChangeState, itemsCount),
          //icon
          if (onChangeState is OnChangeOnBoardingPage &&
              onChangeState.index == itemsCount - 1)
            Icon(
              Icons.done,
              color: iconColor,
              size: responsive.screenWidth * AppSize.s0_075,
            )
          else
            Padding(
              padding: EdgeInsets.only(
                  top: responsive.screenHeight * AppSize.s0_015),
              child: SvgPicture.asset(
                AssetsProvider.arrowDown1Icon,
                fit: BoxFit.scaleDown,
                colorFilter: const ColorFilter.mode(
                  iconColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
        ],
      ),
    );
  }

  CustomPaint _buildCustomPaintIndicator(ResponsiveManager responsive,
      OnChangeOnBoardingPageState onChangeState, int itemsCount) {
    return CustomPaint(
      size: Size(responsive.screenWidth * AppSize.s1_5,
          responsive.screenWidth * AppSize.s1_5),
      painter: onChangeState is OnChangeOnBoardingPage
          ? ProgressPainter(
              progress: ((onChangeState.index + 1) / itemsCount) * 100,
              barColor: ColorsManager.paleVioletRed,
              topColor: ColorsManager.paleVioletRed.withOpacity(AppSize.s0_75),
            )
          : null,
    );
  }

  void _onFinish(context) {
    context.pushReplacementNamed(RoutesStrings.loginRoute);
  }

  Widget _page(context, {required OnboardingModel page, required int index}) {
    final responsive = ResponsiveManager(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSkipButton(context),
            responsive.heightSpace(3),
            Text(
              page.title,
              style: getBoldStyle(
                  fontSize: AppSize.s20.sp, color: ColorsManager.beige2),
            ),
            responsive.heightSpace(2),
            Text(
              page.subTitle,
              style: getMediumStyle(
                  color: ColorsManager.white, fontSize: AppSize.s14.sp),
            ),
            responsive.heightSpace(7),
            Center(
              child: Center(
                child: Image.asset(
                  page.image,
                  width: responsive.screenWidth * AppSize.s0_9,
                  height: responsive.bodyHeight * AppSize.s0_5,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  //not used
  List<Color> _getGradientList(int index) {
    final evenGradient = [
      ColorsManager.lightViolet,
      ColorsManager.darkViolet,
    ];
    final oddGradient = [
      ColorsManager.lightBlackViolet,
      ColorsManager.darkBlackViolet
    ];
    return index % 2 == 0 ? evenGradient : oddGradient;
  }

  TextButton _buildSkipButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        _onFinish(context);
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(AppPadding.p0),
      ),
      child: Text(
        AppStrings.skip.tr(),
        style: getMediumStyle(
            color: ColorsManager.mauva.withOpacity(AppSize.s0_75),
            fontSize: AppSize.s14.sp),
      ),
    );
  }
}
