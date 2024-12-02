import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'theming_manager_state.dart';

class ThemingManagerCubit extends Cubit<ThemingManagerState> {
  ThemingManagerCubit() : super(ThemingManagerInitial());
}
