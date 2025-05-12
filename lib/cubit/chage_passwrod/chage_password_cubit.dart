import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/chage_passwrod.dart';


part 'chage_password_state.dart';

class ChagePasswordCubit extends Cubit<ChagePasswordState> {
  ChagePasswordCubit() : super(ChagePasswordInitial());

  void changePaaswordCubit({required String oldPassword,required String newPasswrod,required String confirmPassword})
 async {
    emit(ChagePasswordLoading());
 

    try{
       if(newPasswrod != confirmPassword)
       {
        emit(ChagePasswordConfirmPassword());
       }else{
           SharedPreferences shared =await SharedPreferences.getInstance();
         String employeeID =shared.getString('EmployeeID')!;
        bool result = await ChagePasswrodController().chagePasswrodMeth(employeeID: employeeID, oldPassword: oldPassword, newPasswrod: newPasswrod);
        result ? emit(ChagePasswordSuccess()):emit(ChagePasswordwrongPasswrod());
       }
    }catch (e)
    {
      emit(ChagePasswordFauiler(err: e.toString()));
    }
  }
}
