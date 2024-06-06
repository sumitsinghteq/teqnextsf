trigger LeadTrigger on Lead (after update) {
	if (trigger.isAfter && trigger.isUpdate) {
        //System.debug('inside trigger update');
        LeadTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
    }
}