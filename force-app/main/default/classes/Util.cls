public with sharing class Util {
  public static String sanitizeId(Id idToSanitize) {
    Pattern pattern = Pattern.compile('[^a-zA-Z0-9]');
    Matcher matcher = pattern.matcher(idToSanitize);
    String sanitizedId = matcher.replaceAll('');
    return sanitizedId;
  }
  public static String sanitizeString(String stringToSanitize) {
    Pattern pattern = Pattern.compile('[^a-zA-Z0-9]');
    Matcher matcher = pattern.matcher(stringToSanitize);
    String sanitizedId = matcher.replaceAll('');
    return sanitizedId;
  }
  public static Boolean hasObjectAccess(String objectName) {
    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();

    // Check if the object exists in the schema
    if (schemaMap.containsKey(objectName)) {
      Schema.SObjectType objectType = schemaMap.get(objectName);

      // Check if the current user has access to the object
      return objectType.getDescribe().isAccessible();
    }

    // Object doesn't exist in the schema
    return false;
  }
  public static Boolean hasWriteObjectAccess(String objectName) {
    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();

    // Check if the object exists in the schema
    if (schemaMap.containsKey(objectName)) {
      Schema.SObjectType objectType = schemaMap.get(objectName);

      // Check if the current user has write access to the object
      return objectType.getDescribe().isCreateable();
    }

    // Object doesn't exist in the schema
    return false;
  }

  public static Boolean hasWriteFieldAccess(
    String objectApiName,
    List<String> fieldNames
  ) {
    Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();

    if (globalDescribe.containsKey(objectApiName)) {
      Schema.SObjectType objectType = globalDescribe.get(objectApiName);
      Map<String, Schema.SObjectField> fieldsMap = objectType.getDescribe()
        .fields.getMap();

      for (String fieldName : fieldNames) {
        if (fieldsMap.containsKey(fieldName)) {
          Schema.SObjectField field = fieldsMap.get(fieldName);

          if (!field.getDescribe().isCreateable()) {
            return false; // Field is not editable
          }
        } else {
          return false; // Field doesn't exist on the object
        }
      }

      return true; // All fields are editable
    } else {
      return false; // Object API name is invalid
    }
  }
}
