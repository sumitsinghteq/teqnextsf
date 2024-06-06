public class LeadTriggerHelper {
	 public static void convertLeads(List<Lead> leadsToConvert) {
        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
        List<Database.LeadConvertResult> leadConvertResults = new List<Database.LeadConvertResult>();
		LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];

        for (Lead lead : leadsToConvert) {
            if (lead.Create_Opportunity__c && lead.IsConverted == false) {
                System.debug('inside lead forloop'+lead.Name);
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(lead.Id);
                lc.setConvertedStatus(convertStatus.MasterLabel);
                lc.setDoNotCreateOpportunity(false); // Set to false if you want to create an opportunity
                lc.setOpportunityName(lead.Company + ' Opportunity');
                leadConverts.add(lc);
            }
        }
		
        System.debug('leadconver last list size:==>'+leadConverts.size());
        if (!leadConverts.isEmpty()) {
             try {
                leadConvertResults = Database.convertLead(leadConverts, false);
                for (Database.LeadConvertResult result : leadConvertResults) {
                    if (!result.isSuccess()) {
                        // Handle the failed conversion
                        System.debug('Lead conversion failed for LeadId: ' + result.getLeadId() + ', Error: ' + result.getErrors()[0].getMessage());
                    }
                }
            } catch (Exception e) {
                System.debug('Exception during lead conversion: ' + e.getMessage());
            }
        }
    }
}