sealed class FetchProvidersState {
  const FetchProvidersState();
}

final class FetchProvidersInitial extends FetchProvidersState {}

final class FetchProvidersLoading extends FetchProvidersState {}

final class FetchProvidersSuccess extends FetchProvidersState {
  // final List<SecondDoctorModel> doctors;

  const FetchProvidersSuccess(
      // this.doctors
      );
}

final class FetchProvidersError extends FetchProvidersState {
  final String errMessage;

  const FetchProvidersError(this.errMessage);
}
