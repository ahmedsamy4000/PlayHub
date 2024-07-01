import 'package:playhub/features/Trainer/data/booking_package.dart';
import 'package:playhub/features/Trainer/data/trainer_package_model.dart';

abstract class AppStates {}

class InitialState extends AppStates {}

class AppChangeBottomNavBarScreen extends AppStates {}

class ChangeProfilePhotoSuccessState extends AppStates {}

class ChangeProfilePhotoFailedState extends AppStates {}

class GetPlaygroundDataLoadingState extends AppStates {}

class GetPlaygroundDataSuccessState extends AppStates {}

class GetPlaygroundDataErrorState extends AppStates {}

class AppChangeSearchQuery extends AppStates {}

class AppChangeSelectedCategory extends AppStates {}

class AppChangeSelectedCity extends AppStates {}

class AppChangeSearchFunction extends AppStates {}

class GetCurrentUserLoadingState extends AppStates {}

class GetCurrentUserSuccessState extends AppStates {}

class GetCurrentUserErrorState extends AppStates {}

class ChangeProfilePhotoLoadingState extends AppStates {}

class ChangeProfilePhotoErrorState extends AppStates {}

class UpdateUserInfoSuccessState extends AppStates {}

class UpdateUserInfoLoadingState extends AppStates {}

class UserLogoutSuccessState extends AppStates {}

class UserLogoutErrorState extends AppStates {}

class DeleteUserSuccessState extends AppStates {}

class DeleteUserErrorState extends AppStates {}

class UpdateUserInfoErrorState extends AppStates {}

class GetCategoryPlaygroundsLoadingState extends AppStates {}

class GetCategoryPlaygroundsSuccessState extends AppStates {}

class GetCategoryPlaygroundsErrorState extends AppStates {}

class AddPlaygroundToFavoritesSuccessState extends AppStates {}

class AddPlaygroundToFavoritesErrorState extends AppStates {}

class GetFavoritesPlaygroundsLoadingState extends AppStates {}

class GetFavoritesPlaygroundsSuccessState extends AppStates {}

class GetFavoritesPlaygroundsErrorState extends AppStates {}

class DeletePlaygroundFromFavoritesSuccessState extends AppStates {}

class DeletePlaygroundFromFavoritesErrorState extends AppStates {}

class AddNewOrderLoadingState extends AppStates {}

class AddNewOrderSuccessState extends AppStates {}

class AddNewOrderErrorState extends AppStates {}

class GetStatisticsLoadingState extends AppStates {}

class GetStatisticsSuccessState extends AppStates {}

class GetStatisticsErrorState extends AppStates {}

class GetHomePlaygroundsLoadingState extends AppStates {}

class GetHomePlaygroundsSuccessState extends AppStates {}

class GetHomePlaygroundsErrorState extends AppStates {}

class ChangeMonthSuccessState extends AppStates {}

class GetCategoriesSuccessState extends AppStates {}

class GetBookingListErrorState extends AppStates {}

class GetBookingListSuccessState extends AppStates {}

class GetBookingListLoadingState extends AppStates {}

class PackageAdded extends AppStates {
  final TrainingPackage package;

  PackageAdded(this.package);
}

class GetTrainerPackagesLoadingState extends AppStates {}

class GetTrainerPackagesSuccessState extends AppStates {}

class GetTrainerPackagesErrorState extends AppStates {
  final String error;
  GetTrainerPackagesErrorState(this.error);
}

class AddNewPlaygroundSuccessState extends AppStates {}

class AddNewPlaygroundErrorState extends AppStates {}

class PickPlaygroundImageLoadingState extends AppStates {}

class PickPlaygroundImageSuccessState extends AppStates {}

class PickPlaygroundImageErrorState extends AppStates {}

class RemoveSelectedPlaygroundImageSuccessState extends AppStates {}

class GetOwnerPlaygroundsLoadingState extends AppStates {}

class GetOwnerPlaygroundsSuccessState extends AppStates {}

class GetOwnerPlaygroundsErrorState extends AppStates {}

class DeletePlaygroundLoadingState extends AppStates {}

class DeletePlaygroundSuccessState extends AppStates {}

class DeletePlaygroundErrorState extends AppStates {}

class UpdatePlaygroundSuccessState extends AppStates {}

class UpdatePlaygroundErrorState extends AppStates {}

class AddFeedBackLoadingState extends AppStates {}

class AddFeedBackSuccessState extends AppStates {}

class AddFeedBackErrorState extends AppStates {}

class GetFeedbacksSuccessState extends AppStates {}

class GetFeedbacksErrorState extends AppStates {}

class GetPlaygroundReservationsSuccessState extends AppStates {}

class GetPlaygroundReservationsErrorState extends AppStates {}

class SaveUserDataSuccessState extends AppStates {}

class UpdatePackageLoadingState extends AppStates {}
class UpdatePackageSuccessState extends AppStates {
  final TrainingPackage updatedPackage;
  UpdatePackageSuccessState(this.updatedPackage);
}
class UpdatePackageErrorState extends AppStates {}

class DeletePackageLoadingState extends AppStates {}
class DeletePackageSuccessState extends AppStates {}
class DeletePackageErrorState extends AppStates {}

class GetTrainersLoadingState extends AppStates {}

class GetTrainersSuccessState extends AppStates {}

class GetTrainerBookedPackageSuccessState extends AppStates {}

class GetTrainerBookedPackageErrorState extends AppStates {}

class GetTrainersErrorState extends AppStates {}

class GetPlayerBookedPackageSuccessState extends AppStates {}

class GetPlayerBookedPackageErrorState extends AppStates {}

class AddPackageBookingLoadingState extends AppStates {}

class AddPackageBookingSuccessState extends AppStates {
  final PackageBooking package;

  AddPackageBookingSuccessState(this.package);
}

class AddPackageBookingErrorState extends AppStates {
  final String error;

  AddPackageBookingErrorState(this.error);
}

class ChangeLanguageSuccessState extends AppStates {}

class ChangeLanguageErrorState extends AppStates {}

class LoadLanguageSuccessState extends AppStates {}

class AddTrainerToFavoritesSuccessState extends AppStates {}

class AddTrainerToFavoritesErrorState extends AppStates {}

class DeleteTrainerFromFavoritesSuccessState extends AppStates {}

class DeleteTrainerFromFavoritesErrorState extends AppStates {}

class GetFavoritesTrainersLoadingState extends AppStates {}

class GetFavoritesTrainersSuccessState extends AppStates {}

class GetFavoritesTrainersErrorState extends AppStates {}