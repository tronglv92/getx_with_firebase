enum Role {
  user,
  store
}

extension RoleExtension on Role {

  int get value {
    switch (this) {
      case Role.user:
        return 0;
      case Role.store:
        return 1;
      default:
        return 0;
    }
  }


}
