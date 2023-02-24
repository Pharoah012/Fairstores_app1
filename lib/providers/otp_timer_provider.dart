import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Duration myDuration = Duration(seconds: 60);
String strDigits(int n) => n.toString().padLeft(2, '0');
final minuteProvider = StateProvider<String>((ref) => strDigits(myDuration.inMinutes.remainder(60)));
final secondsProvider = StateProvider<String>((ref) => strDigits(myDuration.inSeconds.remainder(60)));
final durationProvider = StateProvider<Duration>((ref) => Duration(minutes: 2));
final receivedVerificationIDProvider = StateProvider<String?>((ref) => null);
final resendTokenProvider = StateProvider<int?>((ref) => null);
final numberToVerify = StateProvider<String>((ref) => "");

class OTPTimerProvider extends StateNotifier<Timer?> {
  bool enabledResend = false;
  final ref;

  OTPTimerProvider(this.ref, Timer? state) : super(state);

  void startTimer(){

    state = Timer.periodic(const Duration(seconds: 1),
      (_) {
        final seconds = ref.read(durationProvider).inSeconds - 1;

        if (seconds == 0) {
          stopTimer();
        } else {

          if (ref.read(durationProvider.notifier).state.inMinutes == 2){
            enabledResend = false;
          }

          ref.read(durationProvider.notifier).state = Duration(seconds: seconds);
        }
      }
    );

  }

  void stopTimer(){
    if (state != null){
      state!.cancel();
      ref.read(minuteProvider.notifier).state = "00";
      ref.read(secondsProvider.notifier).state = "00";
      ref.invalidate(receivedVerificationIDProvider);
      ref.invalidate(resendTokenProvider);
      ref.read(durationProvider.notifier).state = Duration(minutes: 2);
      enabledResend = true;
    }
  }
}

final otpTimerProvider = StateNotifierProvider<OTPTimerProvider, Timer?>(
        (ref) => OTPTimerProvider(ref, null)
);
