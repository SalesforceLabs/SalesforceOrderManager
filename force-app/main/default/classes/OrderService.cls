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
                targetAsset.AccountId = oi.Order.AccountId;
                
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
                    Schema.DisplayType sourceFieldDataType = sourceField.getType();
                    
                    Schema.DescribeFieldResult  targetField = targetFieldsMap.get(targetFieldMapping).getDescribe();
                    
                    System.debug('The target field type to be mapped is ' + targetField.getType());
                   
                    if (sourceFieldDataType == Schema.DisplayType.String){
                        String sourceFieldValue = (String) oi.get(sourceFieldMapping);
                        String oldString = (String)targetAsset.put(targetField.getName(), sourceFieldValue);
                    }     
                    if (sourceFieldDataType == Schema.DisplayType.Double){
                        Double sourceFieldValue = (Double) oi.get(sourceFieldMapping);
                        Double oldDouble = (Double)targetAsset.put(targetField.getName(), sourceFieldValue);
                    } 
                    if (sourceFieldDataType == Schema.DisplayType.Reference){
                        Id sourceFieldValue = (Id) oi.get(sourceFieldMapping);
                        Id oldId = (Id)targetAsset.put(targetField.getName(), sourceFieldValue);
                    } 
                    if (sourceFieldDataType == Schema.DisplayType.Boolean){
                        Boolean sourceFieldValue = (Boolean) oi.get(sourceFieldMapping);
                        Boolean oldBoolean = (Boolean)targetAsset.put(targetField.getName(), sourceFieldValue);
                    } 
                    
                    if (sourceFieldDataType == Schema.DisplayType.Date){
                        Date sourceFieldValue = (Date) oi.get(sourceFieldMapping);
                        Date oldDate = (Date)targetAsset.put(targetField.getName(), sourceFieldValue);
                    } 
                    if (sourceFieldDataType == Schema.DisplayType.DateTime){
                        DateTime sourceFieldValue = (DateTime) oi.get(sourceFieldMapping);
                        DateTime oldDateTime = (DateTime)targetAsset.put(targetField.getName(), sourceFieldValue);
                    }
                }
                assetLists.add(targetAsset);
            }
            insert assetLists;
        }
       
    }
}