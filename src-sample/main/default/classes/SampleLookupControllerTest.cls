@isTest
public class SampleLookupControllerTest {
    @isTest
    static void search_should_return_Account() {
        Id [] fixedResults = new Id[1];
        Account account = createTestAccount('Account');
        fixedResults.add(account.Id);
        Test.setFixedSearchResults(fixedResults);
        List<String> selectedIds = new List<String>();

        List<LookupSearchResult> results = SampleLookupController.search('Acc', selectedIds, null);

        System.assertEquals(1, results.size());
        System.assertEquals(account.Id, results.get(0).getId());
    }

    @isTest
    static void search_should_not_return_selected_item() {
        Id [] fixedResults = new Id[1];
        Account account1 = createTestAccount('Account1');
        fixedResults.add(account1.Id);
        Account account2 = createTestAccount('Account2');
        fixedResults.add(account2.Id);
        Test.setFixedSearchResults(fixedResults);
        List<String> selectedIds = new List<String>();
        selectedIds.add(account2.Id);

        List<LookupSearchResult> results = SampleLookupController.search('Acc', selectedIds, null);

        System.assertEquals(1, results.size());
        System.assertEquals(account1.Id, results.get(0).getId());
    }

    @isTest
    static void search_should_return_five_results(){
        Id [] fixedResults = new Id[5];
        Account acc1 = createTestAccount('Account1');
        fixedResults.add(acc1.Id);
        Opportunity opp1 = createTestOpportunity('Opp1');
        fixedResults.add(opp1.Id);
        Account acc2 = createTestAccount('Account2');
        fixedResults.add(acc2.Id);
        Opportunity opp2 = createTestOpportunity('Opp2');
        fixedResults.add(opp2.Id);
        Account acc3 = createTestAccount('Account3');
        fixedResults.add(acc3.Id);
        Opportunity opp3 = createTestOpportunity('Opp3');
        Test.setFixedSearchResults(fixedResults);
        List<String> selectedIds = new List<String>();
        List<LookupSearchResult> results = SampleLookupController.search('', selectedIds, null);
        System.assertEquals(5, results.size());
    }

    private static Account createTestAccount(String name) {
        Account account = new Account(Name = name);
        insert account;
        return account;
    }

    private static Opportunity createTestOpportunity(String name) {
        Opportunity opp = new Opportunity(Name = name, StageName='Prospecting', CloseDate=Date.today());
        insert opp;
        return opp;
    }

}
