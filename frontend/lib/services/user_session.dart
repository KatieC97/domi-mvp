class UserSession {
  static String? userName;

  static void setUserName(String name) {
    userName = name;
  }

  static String? getUserName() {
    return userName;
  }

  static void clear() {
    userName = null;
  }
}
