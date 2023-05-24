public with sharing class OrderFilterSelector {
  public static List<orderManager__Order_Filter__mdt> getOrderFilters(
    id orderMapperId
  ) {
    List<orderManager__Order_Filter__mdt> orderFilters = new List<orderManager__Order_Filter__mdt>();
    Pattern pattern = Pattern.compile('[^a-zA-Z0-9]');
    Matcher matcher = pattern.matcher(orderMapperId);
    String sanitizedOrderMapperId = matcher.replaceAll('');

    orderFilters = [
      SELECT
        id,
        orderManager__Field_Name__c,
        orderManager__Field_Value__c,
        orderManager__Order_Mapper__c
      FROM orderManager__Order_Filter__mdt
      WHERE orderManager__Order_Mapper__c = :sanitizedOrderMapperId
    ];
    return orderFilters;
  }
}
