import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/wallet_model.dart';
import '../../domain/use_cases/charge_wallet_use_case.dart';
import '../../domain/use_cases/get_wallet_use_case.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final ChargeWalletUseCase chargeWallet;
  final GetWalletBalanceUseCase getWalletBalance;

  WalletCubit(this.chargeWallet, this.getWalletBalance)
      : super(WalletInitial());

  Future<void> fetchWalletBalance(String userId) async {
    emit(WalletBalanceLoading());
    try {
      final wallet = await getWalletBalance.execute(userId);
      emit(WalletBalanceLoaded(wallet: wallet));
    } catch (e) {
      emit(WalletBalanceError(e.toString()));
    }
  }

  Future<void> addFunds(String userId, double amount) async {
    emit(WalletLoading());
    try {
      await chargeWallet.execute(userId, amount);
      emit(WalletCharged());
      await fetchWalletBalance(userId);
    } catch (e) {
      emit(WalletChargedError(e.toString()));
    }
  }
}
