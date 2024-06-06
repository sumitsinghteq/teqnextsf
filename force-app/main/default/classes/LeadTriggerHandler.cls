public class LeadTriggerHandler {
    public Static Void afterUpdate(List<Lead> newLeadRecs, Map<Id, Lead> oldLeadMap) {
    	List<Lead> leadsToConvert = new List<Lead>();

        for (Lead lead : newLeadRecs) {
            Lead oldLead = oldLeadMap.get(lead.Id);
            if (lead.Create_Opportunity__c && !oldLead.Create_Opportunity__c) {
                leadsToConvert.add(lead);
            }
        }
    
        if (!leadsToConvert.isEmpty()) {
            LeadTriggerHelper.convertLeads(leadsToConvert);
        }
    }
}