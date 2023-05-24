public with sharing class ErrorHandling {
  public static void createDMLError(Exception e, String className, Id orderId) {
    System.debug(
      'Custom Error Handling  ' +
        e.getMessage() +
        ' Type  ' +
        e.getTypeName() +
        ' at line ' +
        String.valueOf(e.getLineNumber()) +
        ' in the class ' +
        className
    );

    orderManager__Error_Handler__c errorHandler = new orderManager__Error_Handler__c();
    List<String> errorHandlingfields = new List<String>{
      'orderManager__Class_Name__c',
      'orderManager__Description__c',
      'orderManager__Line_Number__c',
      'orderManager__Message__c',
      'orderManager__Type__c',
      'orderManager__Order_Id__c'
    };
    if (
      Util.hasWriteObjectAccess(
        errorHandler.getSObjectType().getDescribe().getName()
      ) &&
      Util.hasWriteFieldAccess(
        errorHandler.getSObjectType().getDescribe().getName(),
        errorHandlingfields
      )
    ) {
      errorHandler.orderManager__Class_Name__c = className != null
        ? className.escapeHtml4()
        : '';
      errorHandler.orderManager__Line_Number__c = e.getLineNumber() != null
        ? e.getLineNumber()
        : 0;
      errorHandler.orderManager__Message__c = e.getMessage() != null
        ? e.getMessage().escapeHtml4()
        : '';
      errorHandler.orderManager__Type__c = e.getTypeName() != null
        ? e.getTypeName().escapeHtml4()
        : '';
      errorHandler.orderManager__Order_Id__c = Id.valueOf(orderId);
      Database.DMLOptions dmlOptions = new Database.DMLOptions();
      Database.SaveResult saveResult = Database.insert(
        errorHandler,
        dmlOptions
      );
    }
  }
  public static void createError(
    Exception e,
    String className,
    Id orderId,
    String description
  ) {
    String errorMessage = e.getMessage();
    System.debug(
      'Custom Error Handling  ' +
        e.getMessage() +
        ' Type  ' +
        e.getTypeName() +
        ' at line ' +
        String.valueOf(e.getLineNumber()) +
        ' in the class ' +
        className
    );
    orderManager__Error_Handler__c errorHandler = new orderManager__Error_Handler__c();
    List<String> errorHandlingfields = new List<String>{
      'orderManager__Class_Name__c',
      'orderManager__Description__c',
      'orderManager__Line_Number__c',
      'orderManager__Message__c',
      'orderManager__Type__c',
      'orderManager__Order_Id__c'
    };
    if (
      Util.hasWriteObjectAccess(
        errorHandler.getSObjectType().getDescribe().getName()
      ) &&
      Util.hasWriteFieldAccess(
        errorHandler.getSObjectType().getDescribe().getName(),
        errorHandlingfields
      )
    ) {
      errorHandler.orderManager__Class_Name__c = className != null
        ? className.escapeHtml4()
        : '';
      errorHandler.orderManager__Description__c = description != null
        ? description.escapeHtml4()
        : '';
      errorHandler.orderManager__Line_Number__c = e.getLineNumber() != null
        ? e.getLineNumber()
        : 0;
      errorHandler.orderManager__Message__c = e.getMessage() != null
        ? e.getMessage().escapeHtml4()
        : '';
      errorHandler.orderManager__Type__c = e.getTypeName() != null
        ? e.getTypeName().escapeHtml4()
        : '';
      errorHandler.orderManager__Order_Id__c = Id.valueOf(orderId);
      Database.DMLOptions dmlOptions = new Database.DMLOptions();
      Database.SaveResult saveResult = Database.insert(
        errorHandler,
        dmlOptions
      );
    }
  }
  public static void createCustomError(
    String className,
    Id orderId,
    String description
  ) {
    orderManager__Error_Handler__c errorHandler = new orderManager__Error_Handler__c();
    List<String> errorHandlingfields = new List<String>{
      'orderManager__Class_Name__c',
      'orderManager__Description__c',
      'orderManager__Line_Number__c',
      'orderManager__Message__c',
      'orderManager__Type__c',
      'orderManager__Order_Id__c'
    };
    if (
      Util.hasWriteObjectAccess(
        errorHandler.getSObjectType().getDescribe().getName()
      ) &&
      Util.hasWriteFieldAccess(
        errorHandler.getSObjectType().getDescribe().getName(),
        errorHandlingfields
      )
    ) {
      errorHandler.orderManager__Class_Name__c = className != null
        ? className.escapeHtml4()
        : '';
      errorHandler.orderManager__Description__c = description != null
        ? description.escapeHtml4()
        : '';
      errorHandler.orderManager__Order_Id__c = Id.valueOf(orderId);
      Database.DMLOptions dmlOptions = new Database.DMLOptions();
      Database.SaveResult saveResult = Database.insert(
        errorHandler,
        dmlOptions
      );
    }
  }
}
