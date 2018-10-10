trigger Campaign_LudusTrigger on Campaign (after insert, after update) {
	GamificationEngine.handleCRUD('Campaign', Trigger.newMap, Trigger.oldMap);
}