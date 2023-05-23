public with sharing class Util {
    public static String sanitizeId (Id idToSanitize) {
        Pattern pattern = Pattern.compile('[^a-zA-Z0-9]');
        Matcher matcher = pattern.matcher(idToSanitize);
        String sanitizedId = matcher.replaceAll('');
        return sanitizedId;
    }
    public static String sanitizeString (String stringToSanitize) {
        Pattern pattern = Pattern.compile('[^a-zA-Z0-9]');
        Matcher matcher = pattern.matcher(stringToSanitize);
        String sanitizedId = matcher.replaceAll('');
        return sanitizedId;
    }
}