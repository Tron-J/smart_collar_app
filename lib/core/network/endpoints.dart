class ApiEndpoints {
  static const String farms = '/farms';
  static String farmAnimals(String farmId) => '/farms/$farmId/animals';
  static String farmAnimalWithCollar(String farmId) =>
      '/farms/$farmId/animals-with-collar';
  static String animalById(String animalId) => '/animals/$animalId';
  static String farmCollars(String farmId) => '/farms/$farmId/collars';
  static const String collarsPair = '/collars/pair';
  static String collarById(String collarId) => '/collars/$collarId';
  static String collarStatus(String collarId) => '/collars/$collarId/status';
  static String collarDisconnect(String collarId) =>
      '/collars/$collarId/disconnect';

  static String animalReadings(String animalId) =>
      '/animals/$animalId/readings';
  static String animalReadingsLatest(String animalId) =>
      '/animals/$animalId/readings/latest';
  static String animalReadingsAggregate(String animalId) =>
      '/animals/$animalId/readings/aggregate';

  static String farmAlerts(String farmId) => '/farms/$farmId/alerts';
  static String alertById(String alertId) => '/alerts/$alertId';
  static String alertResolve(String alertId) => '/alerts/$alertId/resolve';

  static String farmThresholds(String farmId) => '/farms/$farmId/thresholds';
  static String thresholdById(String thresholdId) => '/thresholds/$thresholdId';
  static String animalReadingsExport(String animalId) =>
      '/animals/$animalId/readings/export';

  static const String systemVersion = '/system/version';
}
