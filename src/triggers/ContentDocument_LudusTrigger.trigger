trigger ContentDocument_LudusTrigger on ContentDocument (after insert, after update) {
	GamificationEngine.handleCRUD('ContentDocument', Trigger.newMap, Trigger.oldMap);
}