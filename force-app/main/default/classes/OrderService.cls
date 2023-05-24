public with sharing class OrderService {
  private static boolean run = true;
  private static String className = 'OrderService';

  public static boolean runOnce() {
    if (run) {
      run = false;
      return true;
    } else {
      return run;
    }
  }

  public static void orderUpdateHandler(List<Order> orders) {
    List<orderManager__Order_Mapper__mdt> orderMappers = OrderMapperSelector.getOrderMappers();
    System.debug(
      'OrderService.orderUpdateHandler - The number of Order Mapper records found is ' +
      orderMappers.size()
    );
    for (Order o : orders) {
      for (orderManager__Order_Mapper__mdt orderMapper : orderMappers) {
        Boolean addToOrdersToTarget = false;
        if (
          orderMapper.orderManager__Order_Status__c == o.Status &&
          orderMapper.orderManager__Active__c == true
        ) {
          addToOrdersToTarget = orderFilter(orderMapper.id, o.id);
        }
        if (addToOrdersToTarget == true) {
          System.debug(
            'OrderService.orderUpdateHandler - The order with id ' +
              o.id +
              ' will use the Order Mapper with label ' +
              orderMapper.MasterLabel
          );
          orderToTarget(orderMapper.id, o.id);
        }
      }
    }
  }

  public static Boolean orderFilter(id orderMapperId, id orderId) {
    Boolean addToOrdersToTarget = false;
    Integer countOfFields = 0;
    orderManager__Order_Mapper__mdt orderMapper = OrderMapperSelector.getOrderMapperbyId(
      orderMapperId
    );
    List<orderManager__Order_Filter__mdt> orderFilters = OrderFilterSelector.getOrderFilters(
      orderMapperId
    );
    List<String> fieldsToQuery = new List<String>();

    for (orderManager__Order_Filter__mdt orderFilter : orderFilters) {
      fieldsToQuery.add(orderFilter.orderManager__Field_Name__c);
    }
    Order orderToCheck = OrderSelector.getOrderbyId(orderId, fieldsToQuery);
    for (orderManager__Order_Filter__mdt orderFilter : orderFilters) {
      String fieldName = orderFilter.orderManager__Field_Name__c;
      String fieldValue = orderFilter.orderManager__Field_Value__c;
      String orderFieldValue = (String) orderToCheck.get(fieldName);
      if (orderFieldValue == fieldValue) {
        countOfFields = countOfFields + 1;
      }
    }
    System.debug(
      'OrderService.orderFilter - Number of fields matching the field filter values  is ' +
      countOfFields
    );
    if (countOfFields == orderFilters.size()) {
      addToOrdersToTarget = true;
    }
    System.debug(
      'OrderService.orderFilter -The Order with id ' +
        orderId +
        ' has the addToOrdersToTarget value set to ' +
        addToOrdersToTarget
    );
    return addToOrdersToTarget;
  }

  public static void orderToTarget(id orderMapperId, id orderId) {
    list<OrderItem> orderItemsToTarget = new List<OrderItem>();
    orderManager__Order_Mapper__mdt orderMapper = OrderMapperSelector.getOrderMapperbyId(
      orderMapperId
    );
    List<Field_Mapping__mdt> fieldMappings = new List<Field_Mapping__mdt>(
      OrderMapperService.getFieldMappings(orderMapperId)
    );

    List<String> fieldsToQuery = new List<String>();
    System.debug(
      'OrderService.orderToTarget - Field mapping size is ' +
      fieldMappings.size()
    );
    for (Field_Mapping__mdt fieldMapping : fieldMappings) {
      fieldsToQuery.add(fieldMapping.orderManager__Source_Field__c);
      System.debug(
        'OrderService.orderToTarget - Fields to query on the Order Line Items is ' +
        fieldMapping.orderManager__Source_Field__c
      );
    }
    list<OrderItem> orderItems = new List<OrderItem>(
      OrderLineSelector.getOrderItemsbyOrderIdFiltered(orderId, fieldsToQuery)
    );
    Schema.SObjectType targetObjectType = Schema.getGlobalDescribe()
      .get(orderMapper.orderManager__Target_Object2__c);
    Schema.DescribeSobjectResult targetObject = targetObjectType.getDescribe();
    System.debug(
      'OrderService.orderToTarget - The target object is ' +
      targetObject.getName()
    );
    List<Asset> assetLists = new List<Asset>();
    for (OrderItem oi : orderItems) {
      Asset targetAsset = new Asset();
      List<String> assetFields = new List<String>{
        'AccountId',
        'orderManager__Original_Order_Id__c',
        'orderManager__Original_Order_Item_Id__c',
        'Name',
        'orderManager__Created_By_Order_Manager__c'
      };
      if (
        Util.hasWriteObjectAccess(
          targetAsset.getSObjectType().getDescribe().getName()
        ) &&
        Util.hasWriteFieldAccess(
          targetAsset.getSObjectType().getDescribe().getName(),
          assetFields
        )
      ) {
        String sanitizedAccountId = Util.sanitizeId(oi.Order.AccountId);
        targetAsset.AccountId = sanitizedAccountId;
        String sanitizedOrderId = Util.sanitizeId(oi.Order.id);
        targetAsset.orderManager__Original_Order_Id__c = sanitizedOrderId;
        String sanitizedOrdeItemId = Util.sanitizeId(oi.id);
        targetAsset.orderManager__Original_Order_Item_Id__c = sanitizedOrdeItemId;
        String sanitizedProductName = Util.sanitizeString(oi.Product2.Name);
        targetAsset.Name = sanitizedProductName;
        targetAsset.orderManager__Created_By_Order_Manager__c = true;
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get('OrderItem');
        Schema.DescribeSObjectResult sourceDescribeResult = sobjType.getDescribe();
        Map<String, Schema.SObjectField> sourceFieldsMap = sourceDescribeResult.fields.getMap();
        Map<String, Schema.SObjectField> targetFieldsMap = targetObject.fields.getMap();
        System.debug(
          'OrderService.orderToTarget - The fields in the target objects are  ' +
          targetFieldsMap
        );
        try {
          for (Field_Mapping__mdt fieldMapping : fieldMappings) {
            String sourceFieldMapping = (String) fieldMapping.orderManager__Source_Field__c;
            String targetFieldMapping = (String) fieldMapping.orderManager__Target_Field__c;
            Schema.DescribeFieldResult sourceField = sourceFieldsMap.get(
                sourceFieldMapping
              )
              .getDescribe();
            Schema.DisplayType sourceFieldDataType = sourceField.getType();
            Schema.DescribeFieldResult targetField = targetFieldsMap.get(
                targetFieldMapping
              )
              .getDescribe();
            System.debug(
              'OrderService.orderToTarget - The source field to be mapped is ' +
                sourceFieldMapping +
                ' of type ' +
                sourceField.getType() +
                ' and the target field is ' +
                targetFieldMapping +
                ' of type ' +
                targetField.getType()
            );
            if (sourceFieldDataType == Schema.DisplayType.String) {
              String sourceFieldValue = (String) oi.get(sourceFieldMapping);
              String oldString = (String) targetAsset.put(
                targetField.getName(),
                sourceFieldValue
              );
            }
            if (sourceFieldDataType == Schema.DisplayType.Double) {
              Double sourceFieldValue = (Double) oi.get(sourceFieldMapping);
              Double oldDouble = (Double) targetAsset.put(
                targetField.getName(),
                sourceFieldValue
              );
            }
            if (sourceFieldDataType == Schema.DisplayType.Reference) {
              Id sourceFieldValue = (Id) oi.get(sourceFieldMapping);
              Id oldId = (Id) targetAsset.put(
                targetField.getName(),
                sourceFieldValue
              );
            }
            if (sourceFieldDataType == Schema.DisplayType.Boolean) {
              Boolean sourceFieldValue = (Boolean) oi.get(sourceFieldMapping);
              Boolean oldBoolean = (Boolean) targetAsset.put(
                targetField.getName(),
                sourceFieldValue
              );
            }

            if (sourceFieldDataType == Schema.DisplayType.Date) {
              Date sourceFieldValue = (Date) oi.get(sourceFieldMapping);
              Date oldDate = (Date) targetAsset.put(
                targetField.getName(),
                sourceFieldValue
              );
            }
            if (sourceFieldDataType == Schema.DisplayType.DateTime) {
              DateTime sourceFieldValue = (DateTime) oi.get(sourceFieldMapping);
              DateTime oldDateTime = (DateTime) targetAsset.put(
                targetField.getName(),
                sourceFieldValue
              );
            }
          }
        } catch (Exception e) {
          String errorDescription = 'One or more fields are not correctly mapped from the Order Item to the Asset Object. Please check the Field Mapping metadata record type to correct any incorrect field mapping.';
          ErrorHandling.createError(e, className, orderId, errorDescription);
        }
      }
      assetLists.add(targetAsset);
    }

    try {
      System.debug(
        'OrderService.orderToTarget - The number of Asset records to be created is  ' +
        assetLists.size()
      );
      if (Util.hasObjectAccess('Asset')) {
        insert assetLists;
      } else {
        ErrorHandling.createCustomError(
          'OrderService',
          orderId,
          'User does not have access to the Asset object'
        );
      }
    } catch (DmlException e) {
      ErrorHandling.createDMLError(e, className, orderId);
    }
  }
}
