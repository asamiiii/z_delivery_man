class DmConditions {
  static bool showItemCountTextField(String? nextStatus) {
    if (nextStatus == 'picked' || nextStatus == 'from_provider') {
      return true;
    }
    return false;
  }
}
