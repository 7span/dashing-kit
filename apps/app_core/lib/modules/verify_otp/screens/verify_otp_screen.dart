import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:app_core/app/routes/app_router.dart';
import 'package:app_core/core/presentation/widgets/app_snackbar.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';
import 'package:app_core/modules/verify_otp/bloc/verify_otp_bloc.dart';
import 'package:app_translations/app_translations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

@RoutePage()
class VerifyOTPScreen extends StatefulWidget implements AutoRouteWrapper {
  const VerifyOTPScreen({super.key, this.emailAddress});

  final String? emailAddress;

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
      create: (context) => const AuthRepository(),
      child: BlocProvider(
        lazy: false,
        create: (context) => VerifyOTPBloc(RepositoryProvider.of<AuthRepository>(context), emailAddress ?? ''),
        child: this,
      ),
    );
  }
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> with TickerProviderStateMixin {
  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> formKey;

  Timer? _timer;
  int _secondsRemaining = 30;
  bool _isTimerRunning = true;

  @override
  void dispose() {
    _timer?.cancel();
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 30;
      _isTimerRunning = true;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _isTimerRunning = false;
        });
        _timer?.cancel();
      }
    });
  }

  void _onResendOTP(BuildContext context) {
    final email = widget.emailAddress;
    if (email == null || email.isEmpty) {
      showAppSnackbar(context, 'Email address is missing. Cannot resend OTP.');
      return;
    }
    debugPrint('Resending OTP to email: $email');

    pinController.clear();
    FocusScope.of(context).unfocus();
    context.read<VerifyOTPBloc>().add(ResendEmailEvent());
    _startTimer();
  }

  void _onVerifyOTP(BuildContext contextBuild, VerifyOTPState state) {
    TextInput.finishAutofillContext();
    FocusScope.of(context).unfocus();
    // Static check for OTP
    if (state.otp == '222222') {
      pinController.clear();
      showAppSnackbar(contextBuild, 'OTP verified successfully!');
      contextBuild.maybePop();
      if (mounted) {
        contextBuild.pushRoute(const ChangePasswordRoute());
      }
    } else {
      showAppSnackbar(contextBuild, 'Invalid OTP');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        backgroundColor: context.colorScheme.white,
        automaticallyImplyLeading: true,
        title: context.t.verify_otp,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Insets.small12),
          child: BlocConsumer<VerifyOTPBloc, VerifyOTPState>(
            listener: (BuildContext context, VerifyOTPState state) {
              if (state.statusForResendOTP == ApiStatus.error || state.statusForVerifyOTP == ApiStatus.error) {
                final errorMessage = state.errorMessage;
                pinController.clear();
                showAppSnackbar(context, errorMessage);
              }
              if (state.statusForResendOTP == ApiStatus.loaded) {
                showAppSnackbar(context, context.t.otp_send_to_email);
              }
              // Remove API success navigation, handled in static check
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    VSpace.large24(),
                    SlideAndFadeAnimationWrapper(delay: 100, child: Center(child: Assets.images.logo.image(width: 100))),
                    VSpace.large24(),
                    SlideAndFadeAnimationWrapper(
                      delay: 200,
                      child: Center(child: AppText.xsSemiBold(text: context.t.welcome, fontSize: 16)),
                    ),
                    VSpace.large24(),
                    AppTextField(
                      initialValue: widget.emailAddress,
                      label: context.t.email,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                    ),
                    VSpace.medium16(),
                    Padding(padding: const EdgeInsets.all(Insets.small12), child: AppText.sSemiBold(text: context.t.enter_otp)),
                    VSpace.small12(),
                    BlocBuilder<VerifyOTPBloc, VerifyOTPState>(
                      builder:
                          (context, state) => Pinput(
                            length: 6,
                            controller: pinController,
                            focusNode: focusNode,
                            separatorBuilder: (index) => HSpace.xxsmall4(),
                            validator: (value) {
                              return value == '222222' ? null : 'Pin is incorrect';
                            },
                            onCompleted: (pin) {
                              debugPrint('onCompleted: $pin');
                            },
                            onChanged: (value) {
                              context.read<VerifyOTPBloc>().add(VerifyOTPChanged(value));
                            },
                          ),
                    ),
                    VSpace.xsmall8(),
                    if (_isTimerRunning)
                      AppText(
                        text: '00:${_secondsRemaining.toString().padLeft(2, '0')}',
                        style: context.textTheme?.sSemiBold.copyWith(color: context.colorScheme.primary400),
                      ),
                    VSpace.small12(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: "Didn't receive the verification OTP?",
                          style: context.textTheme?.xsRegular.copyWith(color: context.colorScheme.black),
                        ),
                        AppButton(
                          text: context.t.resend_otp,
                          buttonType: ButtonType.text,
                          textColor: context.colorScheme.primary400,
                          onPressed: _isTimerRunning ? null : () => _onResendOTP(context),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    VSpace.large24(),
                    BlocBuilder<VerifyOTPBloc, VerifyOTPState>(
                      builder:
                          (contextBuild, state) => Visibility(
                            visible: state.otpIsValid,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Insets.large24),
                              child: AppButton(
                                isExpanded: true,
                                text: context.t.verify_otp,
                                isLoading: state.statusForVerifyOTP == ApiStatus.loading,
                                onPressed: () => _onVerifyOTP(contextBuild, state),
                              ),
                            ),
                          ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Countdown extends AnimatedWidget {
  Countdown({super.key, this.animation}) : super(listenable: animation!);
  final Animation<int>? animation;

  @override
  Widget build(BuildContext context) {
    final clockTimer = Duration(seconds: animation!.value);

    final timerText = '${clockTimer.inMinutes.remainder(60)}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    return AppText(text: timerText);
  }
}
