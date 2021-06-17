public class OrderMapperSelector {
    public static List<orderManager__Order_Mapper__mdt > getOrderMappers (){
        List<orderManager__Order_Mapper__mdt> orderMappers = new List<orderManager__Order_Mapper__mdt>();
        orderMappers = [SELECT id, orderManager__Order_Status__c,orderManager__Source_Object__c,orderManager__Source_Object_Record_Type__c ,
                       orderManager__Target_Object2__c FROM orderManager__Order_Mapper__mdt];
        return orderMappers;
    }
    public static orderManager__Order_Mapper__mdt getOrderMapperbyId (id orderMapperId){
        orderManager__Order_Mapper__mdt orderMapper = [SELECT id, orderManager__Order_Status__c,orderManager__Source_Object__c,orderManager__Source_Object_Record_Type__c ,
                       orderManager__Target_Object2__c FROM orderManager__Order_Mapper__mdt LiMIT 1];
        return orderMapper;
    }
}