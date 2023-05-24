public with sharing class OrderMapperService {
  public static List<Field_Mapping__mdt> getFieldMappings(id orderMapperId) {
    List<Field_Mapping__mdt> fieldMappings = new List<Field_Mapping__mdt>();
    fieldMappings = [
      SELECT
        id,
        orderManager__Source_Field__c,
        orderManager__Target_Field__c,
        orderManager__Order_Mapper__c
      FROM Field_Mapping__mdt
      WHERE orderManager__Order_Mapper__c = :orderMapperId
    ];
    return fieldMappings;
  }
}
