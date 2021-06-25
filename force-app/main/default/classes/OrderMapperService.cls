public class OrderMapperService {

    public static List<Field_Mapping__mdt> getFieldMappings (id orderMapperId){
        List<Field_Mapping__mdt> fieldMappings = new List<Field_Mapping__mdt>();
        fieldMappings = [SELECT id, orderManager__Source_Field__c, orderManager__Target_Field__c, orderManager__Order_Mapper__c
                         FROM Field_Mapping__mdt WHERE orderManager__Order_Mapper__c =: orderMapperId];
        return fieldMappings;
    }
    public static List<OrderItem> orderItemFilter (id orderMapperId, List<OrderItem> orderItems){
        List <OrderItem> filteredOrderItems = new List<OrderItem>();
        List <orderManager__Order_Item_Filter__mdt>  orderItemFilters = [SELECT id, orderManager__External_Id__c,orderManager__Order_Mapper__c 
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
                    createTarget = false;
                }
            }
        }
        return filteredOrderItems;
    }
    public static Set<Id> validateRecord (id orderMapperId){
        Boolean validRecord = true;
        orderManager__Order_Mapper__mdt orderMapper = OrderMapperSelector.getOrderMapperbyId (orderMapperId);
        List<orderManager__Order_Mapper__mdt> orderMappers=  OrderMapperSelector.getOrderMappers();
        List<String> fieldsToCheck = new List<String>();
        Set<Id> existingOrderMapping =new Set<Id>();

        if(orderMapper.orderManager__Field1__c != null){
            fieldsToCheck.add(orderMapper.orderManager__Field1__c );
        }
        if(orderMapper.orderManager__Field2__c != null){
            fieldsToCheck.add(orderMapper.orderManager__Field2__c );
        }
        if(orderMapper.orderManager__Field3__c != null){
            fieldsToCheck.add(orderMapper.orderManager__Field3__c );
        }
        if(orderMapper.orderManager__Field4__c != null){
            fieldsToCheck.add(orderMapper.orderManager__Field4__c );
        }
        //add additional fields that needs to be checked.
        
        for (orderManager__Order_Mapper__mdt orderMapperInList : orderMappers){
            Integer fieldCounter = 0;
            if(orderMapperId!=orderMapperInList.id){
                List<String> existingFields = new List<String>();
                if(orderMapperInList.orderManager__Field1__c != null){
                    existingFields.add(orderMapperInList.orderManager__Field1__c);
                }
                if(orderMapperInList.orderManager__Field2__c != null){
                    existingFields.add(orderMapperInList.orderManager__Field2__c);
                }
                if(orderMapperInList.orderManager__Field3__c != null){
                    existingFields.add(orderMapperInList.orderManager__Field3__c);
                }
                if(orderMapperInList.orderManager__Field4__c != null){
                    existingFields.add(orderMapperInList.orderManager__Field4__c);
                }
                for (String fieldToCheck :fieldsToCheck){
                    Boolean fieldExist= false;
                    Boolean fieldExistWithSameValue = false;
                    fieldExist = existingFields.contains(fieldToCheck);
                    //if (fieldExist==true && orderMapperInList.)
                    //}
                    if (fieldExistWithSameValue ==true){
                        fieldCounter++;
                    }
                if(fieldsToCheck.size()== fieldCounter){
                    existingOrderMapping.add(orderMapperInList.id);
                    }
                }
            }
        }
        return existingOrderMapping;
    }
}