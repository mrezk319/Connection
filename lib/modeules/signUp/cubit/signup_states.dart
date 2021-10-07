abstract class SignUpStates{}
class SignUpInitialState extends SignUpStates{}


class SignUpLoadingState extends SignUpStates{}
class SignUpSuccessState extends SignUpStates{}
class SignUpErrorState extends SignUpStates{
   late String error;
  SignUpErrorState(this.error);
}


class ChangeHintTextState extends SignUpStates{}

class UserLoadingState extends SignUpStates{}
class UserSuccessState extends SignUpStates{}
class UserErrorState extends SignUpStates{
  late String error;
  UserErrorState(this.error);
}