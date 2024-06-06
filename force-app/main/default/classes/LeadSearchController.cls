// LeadSearchController.cls
public with sharing class LeadSearchController {
    
    // Method to fetch specialization options
    @AuraEnabled(cacheable=true)
   
    public static List<String> getSpecializations() {
        List<String> options = new List<String>();
        // Retrieve picklist values dynamically using describe call
        Schema.DescribeFieldResult fieldResult = Lead.Specialization__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : picklistValues) {
            options.add(entry.getValue());
        }
        return options;
    }
    
    // Method to search for leads based on specialization and region
    @AuraEnabled(cacheable=true)
    public static List<Lead> searchLeads(String specialization, String region) {
        List<Lead> leads = new List<Lead>();
        // Perform SOQL query to fetch leads based on specialization and region
        leads = [SELECT Id, Name, Specialization__c, Country FROM Lead WHERE Specialization__c = :specialization AND Country = :region];
        return leads;
    }
    
    // Method to store selected leads in junction object
    @AuraEnabled(cacheable=false)
    public static String setLeadsInJunctionObject(List<String> leadIds , String productId) {

        System.debug('lead id and product id:>>>>> '+ productId);
        String message = '';
        List<ProductInterest__c> result = new List<ProductInterest__c>();
        
        Product2 productInfo = [SELECT Id
                                        // ,
                                        // Pharma_Content__c,
                                        // Ready_to_Launch__c,
                                        // Receive_Token__c,
                                        // Image_URL__c,
                                        // Subject__c
                                        FROM Product2
                                        WHERE Id =: productId];
        
        //  if (productInfo.Ready_to_Launch__c != null && productInfo.Ready_to_Launch__c) {
            for (String leadId : leadIds) {
                ProductInterest__c junctionRecord = new ProductInterest__c();
                junctionRecord.Lead__c = leadId;
                junctionRecord.Product__c = productInfo.Id;
                // junctionRecord.Generated_Content__c = productInfo.Receive_Token__c;
                // junctionRecord.Image_URL__c = productInfo.Image_URL__c;
                // junctionRecord.Subject__c = productInfo.Subject__c;
                result.add(junctionRecord);
            }
        //  }
        if (result.size() > 0) {
            try{
                insert result;
                message = 'Records Created Successfully!!!';
            }catch(Exception ex){
                message = ex.getMessage();
            }
           
        }
       return message; 
    }
}