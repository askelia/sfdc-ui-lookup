public with sharing class SampleLookupController {

    private final static Integer MAX_RESULTS = 5;

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> search(String searchTerm, List<String> selectedIds, String anOptionalParam) {
        // We're not using anOptionalParam parameter
        // it's just here to demonstrate custom params
        
        // Check the searchTerm length
        Boolean tooShortForSosl = searchTerm.length()<2;

        // Prepare query paramters
        searchTerm += tooShortForSosl ? '%' : '*';

        Account [] accounts;
        Opportunity [] opptys;

        if (tooShortForSosl){
            //SOQL queries
            List<Account> accs = [SELECT Id, Name, BillingCity, LastModifiedDate FROM Account 
                                        WHERE id NOT IN :selectedIds 
                                        AND Name like :searchTerm 
                                        limit :MAX_RESULTS oreder by LastModifiedDate];
            List<Opportunity> opps = [SELECT Id, Name, StageName, LastModifiedDate FROM Opportunity 
                                        WHERE id NOT IN :selectedIds 
                                        AND Name like :searchTerm 
                                        limit :MAX_RESULTS order by LastModifiedDate];
            accounts = new List<Account>();
            opptys = new List<Opportunity>();
            // keep only MAX_RESULTS results, the ones with most recent modifed date
            for (Integer i=0; i<=MAX_RESULTS; i++ ){
                if (accs.size()>0 && opps.size()>0){
                    if (accs.get(0).LastModifiedDate > opps.get(0).LastModifiedDate)
                    {
                        accounts.add(accs.get(0));
                        accs.remove(0);
                    } else {
                        opptys.add(opps.get(0));
                        opps.remove(0);
                    }
                }
                else if (accs.size()>0){
                    accounts.add(accs.get(0));
                    accs.remove(0);
                }
                else if (opss.size()>0){
                    opptys.add(opps.get(0));
                    opps.remove(0);
                }
            }            
        }
        else {
            // Execute search query
            List<List<SObject>> searchResults = [FIND :searchTerm IN ALL FIELDS RETURNING
                Account (Id, Name, BillingCity WHERE id NOT IN :selectedIds),
                Opportunity (Id, Name, StageName WHERE id NOT IN :selectedIds)
                LIMIT :MAX_RESULTS];

            // Extract Accounts
            accounts = ((List<Account>) searchResults[0]);
            // Extract Opportunities
            opptys = ((List<Opportunity>) searchResults[1]);
        }

        // Prepare results
        List<LookupSearchResult> results = new List<LookupSearchResult>();

        // Convert accounts into LookupSearchResult
        String accountIcon = 'standard:account';
        for (Account account : accounts) {
            results.add(new LookupSearchResult(account.Id, 'Account', accountIcon, account.Name, 'Account • '+ account.BillingCity));
        }

        // Convert opportunities into LookupSearchResult
        String opptyIcon = 'standard:opportunity';        
        for (Opportunity oppty : opptys) {
            results.add(new LookupSearchResult(oppty.Id, 'Opportunity', opptyIcon, oppty.Name, 'Opportunity • '+ oppty.StageName));
        }

        return results;
    }

     
}
