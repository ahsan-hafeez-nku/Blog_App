class UserEntity {
  final String id;
  final String name;
  final String email;
  UserEntity({required this.id, required this.name, required this.email});
}

/*
Supabase JSON → UserModel → UserEntity → AuthBloc (state)
- The remote data source fetches JSON from Supabase and converts it into a UserModel.
- The repository converts UserModel into a UserEntity.
- The use case and BLoC work only with UserEntity — unaware of the database or API.


 */
