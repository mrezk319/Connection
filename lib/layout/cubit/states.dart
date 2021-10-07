abstract class HomeStates{}
class HomeInitialState extends HomeStates{}


class getUserLoadingState extends HomeStates{}
class getUserSuccessState extends HomeStates{}
class getUserErrorState extends HomeStates{
  late String error;
  getUserErrorState(this.error);
}

class changeIndexState extends HomeStates{}

class getProfileImagePickerSuccessState extends HomeStates{}
class getProfileImagePickerErrorState extends HomeStates{}

class getCoverImagePickerSuccessState extends HomeStates{}
class getCoverImagePickerErrorState extends HomeStates{}


class uploadCoverImagePickerLoadingState extends HomeStates{}
class uploadCoverImagePickerSuccessState extends HomeStates{}
class uploadCoverImagePickerErrorState extends HomeStates{}


class uploadProfileImagePickerLoadingState extends HomeStates{}
class uploadProfileImagePickerSuccessState extends HomeStates{}
class uploadProfileImagePickerErrorState extends HomeStates{}


class uploadUserErrorState extends HomeStates{}
class uploadUserLoadingState extends HomeStates{}


class updateUploadDataUser extends HomeStates{}

class addPhotoPost extends HomeStates{}

class postUploadSuccessState extends HomeStates{}
class postUploadLoadingState extends HomeStates{}
class postUploadErrorState extends HomeStates{}


class uploadPostImageErrorState extends HomeStates{}
class uploadPostImageSuccessState extends HomeStates{}
class uploadPostImageLoadingState extends HomeStates{}

class getPostsErrorState extends HomeStates{}
class getPostsSuccessState extends HomeStates{}
class getPostsLoadingState extends HomeStates{}

class likePostErrorState extends HomeStates{}
class likePostSuccessState extends HomeStates{}

class dislikePostSuccessState extends HomeStates{}


class getCountlikesSuccessState extends HomeStates{}


class getSuccess extends HomeStates{}

class getMyPostsErrorState extends HomeStates{}
class getMySuccess extends HomeStates{}
class getMyPostsLoadingState extends HomeStates{}

class getColorSuccess extends HomeStates{}

class isLikeChecker extends HomeStates{}

class increaseNumState extends HomeStates{}
class decreaseNumState extends HomeStates{}


class getAllUsersLoadingState extends HomeStates{}
class getAllUsersSuccessState extends HomeStates{}
class getAllUsersErrorState extends HomeStates{}


class sendMessageSuccessState extends HomeStates{}
class sendMessageErrorState extends HomeStates{}


class sendMessagetoRecieverSuccessState extends HomeStates{}
class sendMessagetoRecieverErrorState extends HomeStates{}


class testes extends HomeStates{}


class getMessagesSuccessState extends HomeStates{}
