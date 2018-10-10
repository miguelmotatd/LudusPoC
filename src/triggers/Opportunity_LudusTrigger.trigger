trigger Opportunity_LudusTrigger on Opportunity (after insert, after update) {
	GamificationEngine.handleCRUD('Opportunity', Trigger.newMap, Trigger.oldMap);
}