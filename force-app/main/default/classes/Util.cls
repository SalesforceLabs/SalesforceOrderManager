public without sharing class Util {
    static final String CLASS_NAME = 'Util';
    
    public static Boolean isValidSalesforceId(id sfdcId, System.Type type, id orderId){
        Boolean isValidSalesforceId = false;
        String sfdcIdString = String.valueOf(sfdcId);
        try {
            if ( Pattern.compile( '[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}').matcher(sfdcIdString).matches() ){
                Id id =  Id.valueOf(sfdcIdString);
                sObject sObj = (sObject) type.newInstance();
                sObj.Id = id;
                isValidSalesforceId = true;
            }
        } catch ( Exception e ){
            String errorDescription = 'The identifier is not a valid Salesforce Id';
            ErrorHandling.createError(e, CLASS_NAME,orderId, errorDescription);
        }
        return isValidSalesforceId;       
    }
    public static Boolean isValidFieldList(List<String> fieldNames, System.Type type, id orderId){
        Boolean isValidFieldList = true;    
        String sObjName = type.toString();
        Set<String> objectFields = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap().keySet();
            for (String fieldName : fieldNames){
                if (!objectFields.contains(fieldName.toLowerCase())) {
                    isValidFieldList = false;
                }
            }
        return isValidFieldList;
    }
}
