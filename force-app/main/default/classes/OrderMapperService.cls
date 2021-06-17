public class OrderMapperService {

    public static List<Field_Mapping__mdt> getFieldMappings (id orderMapperId){
        List<Field_Mapping__mdt> fieldMappings = new List<Field_Mapping__mdt>();
        fieldMappings = [SELECT id, orderManager__Source_Field__c, orderManager__Target_Field__c, orderManager__Order_Mapper__c
                         FROM Field_Mapping__mdt WHERE orderManager__Order_Mapper__c =: orderMapperId];
        return fieldMappings;
    }
    public static List<OrderItem> orderItemFilter (id orderMapperId, List<OrderItem> orderItems){
        List <OrderItem> filteredOrderItems = new List<OrderItem>();
        List <orderManager__Order_Item_Filter__mdt>  orderItemFilters = [SELECT id, orderManager__External_Id__c, orderManager__Product_Identifier_Type__c , orderManager__Product__c,orderManager__Order_Mapper__c 
                                                                         FROM orderManager__Order_Item_Filter__mdt 
                                                                         WHERE orderManager__Order_Mapper__c =: orderMapperId];
        for(OrderItem orderItem : orderItems){
            Boolean createTarget = false;
            for(orderManager__Order_Item_Filter__mdt orderItemFilter : orderItemFilters){
                if (orderItemFilter.orderManager__External_Id__c == orderItem.Product2.orderManager__External_Id__c ){
                   createTarget = true; 
                }
                if(createTarget == true){
                    filteredOrderItems.add(orderItem);
                }
            }
        }
        return filteredOrderItems;
    }
}