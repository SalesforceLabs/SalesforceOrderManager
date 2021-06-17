public class OrderService {
    public static void orderUpdateHandler(List<Order> orders ){
        List<orderManager__Order_Mapper__mdt> orderMappers = OrderMapperSelector.getOrderMappers();
        
        for (Order o : orders){
            Boolean addToOrdersToTarget = false;
            for (orderManager__Order_Mapper__mdt orderMapper : orderMappers){
                if (orderMapper.orderManager__Order_Status__c == o.Status){
       				//add the logic on the order record type or other filters 
                    addToOrdersToTarget = true;
                }
                if (addToOrdersToTarget == true){
                    orderToTarget (orderMapper.id,o.id);
                }
            }
        }
    }
    public static void orderToTarget(id orderMapperId, id orderId){
      	list<OrderItem > orderItems = new List<OrderItem>(OrderLineSelector.getOrderItemsbyOrderId(orderId));
      	list<OrderItem > orderItemsToTarget =new List<OrderItem>();
        orderManager__Order_Mapper__mdt orderMapper = OrderMapperSelector.getOrderMapperbyId(orderMapperId);
  		orderItemsToTarget = OrderMapperService.orderItemFilter(orderMapperId, orderItems);
        System.debug('orderItemsToTarget size is ' + orderItemsToTarget.size());
        List<Field_Mapping__mdt> fieldMappings= new List<Field_Mapping__mdt>(OrderMapperService.getFieldMappings(orderMapperId));
        System.debug('fieldMappings size is ' + fieldMappings.size());
        Schema.SObjectType targetObjectType = Schema.getGlobalDescribe().get(orderMapper.orderManager__Target_Object__c);
        Schema.DescribeSobjectResult targetObject = targetObjectType.getDescribe();
        System.debug('The target object is ' + targetObject.getName());
        If (targetObject.getName() =='Asset'){
            List <Asset> assetLists = new List<Asset>();
            for (OrderItem oi : orderItemsToTarget){
 				Asset targetAsset = new Asset();
                Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
                Schema.SObjectType sobjType = gd.get('OrderItem'); 
                Schema.DescribeSObjectResult sourceDescribeResult = sobjType.getDescribe(); 
                Map<String,Schema.SObjectField> sourceFieldsMap = sourceDescribeResult.fields.getMap(); 
                
                Map<String,Schema.SObjectField> targetFieldsMap = targetObject.fields.getMap(); 
                System.debug('The fields in the target objects are  ' + targetFieldsMap);
                for(Field_Mapping__mdt fieldMapping :fieldMappings){
                    
                    String sourceFieldMapping = (String) fieldMapping.orderManager__Source_Field__c;
                    String targetFieldMapping = (String) fieldMapping.orderManager__Target_Field__c;
                    System.debug('The source field to be mapped is ' + sourceFieldMapping);
                    System.debug('The target field to be mapped is ' + targetFieldMapping);
                    
                    
                    Schema.DescribeFieldResult  sourceField = sourceFieldsMap.get(sourceFieldMapping).getDescribe();
                    System.debug('The source field type to be mapped is ' + sourceField.getType());
                    
                    Schema.DescribeFieldResult  targetField = targetFieldsMap.get(targetFieldMapping).getDescribe();
                    System.debug('The target field type to be mapped is ' + targetField.getType());
                    
                    if(sourceField.name =='OrderItemNumber'){
                        String sourceFieldValue = (String) oi.get(sourceFieldMapping);
                        System.debug('The source field value to be mapped is ' + sourceFieldValue);
                        targetAsset.Name = sourceFieldValue;
                    }
                    if(sourceField.name =='Product2Id'){
                        Id sourceFieldValue = (Id) oi.get(sourceFieldMapping);
                    }
                    if(sourceField.name =='Quantity'){
                        Double sourceFieldValue = (Double) oi.get(sourceFieldMapping);
                        System.debug('The source field value to be mapped is ' + sourceFieldValue);
                        
                        targetAsset.Quantity = sourceFieldValue;
                        System.debug('The target object Quantity field  ' + targetAsset.Quantity );
 
                        //sObj.Quantity = sourceFieldValue;
                        
                    }
                    
                    // Schema.DisplayType sourceFieldDataType = Schema.getGlobalDescribe().OrderItem.get(sourceField).getDescribe().getType();
                    //Schema.DisplayType sourceFieldDataType = Schema.getGlobalDescribe().get(OrderItem).getDescribe().fields.getMap().get(sourceField).getDescribe().getType(); 
                    //oi.fieldMapping.orderManager__Target_Field__c = 'sdf';
                    //String sourceFieldName = (String);
                    //Schema.DescribeFieldResult dfr = Schema.OrderItem.getDescribe();
                    //Schema.DisplayType sourceFieldDataType = OrderItem.getDescribe().getType();
                    //System.debug('The source field to be mapped is data type ' + fieldMapping.orderManager__Source_Field__c);
                    //if(fieldDataType == 'Decimal'){
                    
                    //}
                    //String sourceFieldValue = (String) oi.get(fieldMapping.orderManager__Source_Field__c);
                    
                }
                targetAsset.AccountId = '0011F00000t7R35QAE';
                targetAsset.ContactId='0031F00000jjezAQAQ';
                assetLists.add(targetAsset);
            }
            insert assetLists;
        }
       
    }
}