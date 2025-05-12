part of 'qrcode_scanner_cubit.dart';

@immutable
sealed class QrcodeScannerState {}

final class QrcodeScannerInitial extends QrcodeScannerState {}
final class QrcodeScannerNotNumber extends QrcodeScannerState {}
final class QrcodeScannerSuccessfuly extends QrcodeScannerState {
}
final class QrcodeScannerNo12Number extends QrcodeScannerState {}
