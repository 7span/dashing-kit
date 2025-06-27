import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:app_core/app/routes/app_router.dart';
import 'package:app_core/core/presentation/widgets/app_snackbar.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';
import 'package:app_core/modules/verify_otp/bloc/verify_otp_bloc.dart';
import 'package:app_core/modules/verify_otp/bloc/verify_otp_state.dart';
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
  Timer? _timer;
  int _secondsRemaining = 30;
  bool _isTimerRunning = true;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    if (!mounted) return;
    setState(() {
      _secondsRemaining = 30;
      _isTimerRunning = true;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          _secondsRemaining--;
        });
      } else {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          _isTimerRunning = false;
        });
        _timer?.cancel();
      }
    });
  }

  void _onResendOTP(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<VerifyOTPBloc>().add(const ResendEmailEvent());
    _startTimer();
  }

  void _onVerifyOTP(BuildContext contextBuild, VerifyOTPState state) {
    TextInput.finishAutofillContext();
    FocusScope.of(context).unfocus();
    // Static check for OTP
    if (state.otp.value == '222222') {
      showAppSnackbar(contextBuild, 'OTP verified successfully!');
      contextBuild.maybePop();
      if (mounted) {
        contextBuild.replaceRoute(const ChangePasswordRoute());
      }
    } else {
      showAppSnackbar(contextBuild, 'Invalid OTP', type: SnackbarType.failed);
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
                    AppTextField(initialValue: widget.emailAddress, label: context.t.email, readOnly: true),
                    VSpace.medium16(),
                    Padding(padding: const EdgeInsets.all(Insets.small12), child: AppText.sSemiBold(text: context.t.enter_otp)),
                    VSpace.small12(),
                    BlocBuilder<VerifyOTPBloc, VerifyOTPState>(
                      builder:
                          (context, state) => Pinput(
                            length: 6,
                            separatorBuilder: (index) => HSpace.xxsmall4(),
                            errorText: state.otp.error != null ? 'Pin is incorrect' : null,
                            onChanged: (value) {
                              context.read<VerifyOTPBloc>().add(VerifyOTPChanged(value));
                            },
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                    ),
                    VSpace.xsmall8(),
                    if (_isTimerRunning) AppTimer(seconds: 30, onFinished: () {}),
                    VSpace.small12(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: context.t.did_not_receive_otp,
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
                            visible: state.isValid,
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
