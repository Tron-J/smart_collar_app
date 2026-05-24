class ApiEndpoints {
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authRefresh = '/auth/refresh';
  static const String authLogout = '/auth/logout';

  static const String farms = '/farms';
  static String farmAnimals(String farmId) => '/farms/$farmId/animals';
  static String farmCollars(String farmId) => '/farms/$farmId/collars';
  static const String collarsPair = '/collars/pair';
  static String collarStatus(String collarId) => '/collars/$collarId/status';

  static String animalReadings(String animalId) => '/animals/$animalId/readings';
  static String animalReadingsLatest(String animalId) =>
      '/animals/$animalId/readings/latest';
  static String animalReadingsAggregate(String animalId) =>
      '/animals/$animalId/readings/aggregate';

  static String farmAlerts(String farmId) => '/farms/$farmId/alerts';
  static String alertById(String alertId) => '/alerts/$alertId';

  static String farmThresholds(String farmId) => '/farms/$farmId/thresholds';
  static String thresholdById(String thresholdId) => '/thresholds/$thresholdId';

  static const String fcmToken = '/devices/fcm-token';
  static const String systemVersion = '/system/version';
}
