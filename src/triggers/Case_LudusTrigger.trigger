trigger Case_LudusTrigger on Case (after insert, after update) {
	GamificationEngine.handleCRUD('Case', Trigger.newMap, Trigger.oldMap);
}