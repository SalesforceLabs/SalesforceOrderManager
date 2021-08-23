public without sharing class ErrorHandling {

    public static void createDMLError(Exception e, String className, Id orderId) {
        System.debug('Custom Error Handling  ' + e.getMessage() + ' Type  ' + e.getTypeName()  + ' at line '+ 
        String.valueOf(e.getLineNumber()) + ' in the class ' + className);
        orderManager__Error_Handler__c errorHandler = new orderManager__Error_Handler__c();
        errorHandler.orderManager__Class_Name__c = className;
        errorHandler.orderManager__Line_Number__c = e.getLineNumber();
        errorHandler.orderManager__Message__c = e.getMessage();
        errorHandler.orderManager__Type__c = e.getTypeName();
        errorHandler.orderManager__Order_Id__c = Id.valueOf(orderId);
        insert errorHandler;
    }
    public static void createError(Exception e, String className, Id orderId, String description) {
        System.debug('Custom Error Handling  ' + e.getMessage() + ' Type  ' + e.getTypeName()  + ' at line '+ 
        String.valueOf(e.getLineNumber()) + ' in the class ' + className);
        orderManager__Error_Handler__c errorHandler = new orderManager__Error_Handler__c();
        errorHandler.orderManager__Class_Name__c = className;
        errorHandler.orderManager__Description__c = description;
        errorHandler.orderManager__Line_Number__c = e.getLineNumber();
        errorHandler.orderManager__Message__c = e.getMessage();
        errorHandler.orderManager__Type__c = e.getTypeName();
        errorHandler.orderManager__Order_Id__c = Id.valueOf(orderId);
        insert errorHandler;
    }
    public static void createErrorWithoutException(String className, Id orderId, String description) {
        orderManager__Error_Handler__c errorHandler = new orderManager__Error_Handler__c();
        errorHandler.orderManager__Class_Name__c = className;
        errorHandler.orderManager__Description__c = description;
        errorHandler.orderManager__Order_Id__c = Id.valueOf(orderId);
        insert errorHandler;
    }
}