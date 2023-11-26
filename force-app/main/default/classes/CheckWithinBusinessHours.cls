public class CheckWithinBusinessHours {
	@InvocableMethod(label = 'Within Business Hours Check')
	public static list <Boolean> makeGetCallout(List<CriteriaInputs> inputs ) {
		String BHName = inputs[0].BHName;
		String SPack = inputs[0].pkg;
		String CId = inputs[0].caseId;
    
    	Boolean isPackageContained = false;
    	Boolean finalResult = false;
    
    	List<Case> SNCases = [SELECT Id, Package__c FROM Case WHERE Id= :CId];
    	for(Case c : SNCases){
        	if(c.Package__c.contains(SPack)){
				isPackageContained = true;
        	}
    	}
    
    	if(!isPackageContained)
        	finalResult = true;
    	else{
            BusinessHours bh = [SELECT Id FROM BusinessHours WHERE name= :BHName];
    		Datetime targetTime = Datetime.now();
    		finalResult = BusinessHours.isWithin(bh.id, targetTime);
    	}
    
		return new list <Boolean> {finalResult}; 
   	}
    
	public class CriteriaInputs {
        @InvocableVariable(required=false label='Business Hours Name' description='Provides the Business Hours Name')
        public String BHName;

        @InvocableVariable(required=false label='CaseId' description='CaseID')
        public String caseId;

        @InvocableVariable(required=false label='Package' description='Package')
        public String pkg;   
    }
}