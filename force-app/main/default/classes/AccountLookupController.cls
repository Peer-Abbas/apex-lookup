public with sharing class AccountLookupController {

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> search(
        String searchTerm,
        List<String> selectedIds
    ) {
        List<LookupSearchResult> results = new List<LookupSearchResult>();

        // Safe search term
        String keyword = '%' + String.escapeSingleQuotes(searchTerm) + '%';

        // Query accounts
        List<Account> accounts = [
            SELECT Id, Name, Industry, BillingCity
            FROM Account
            WHERE Name LIKE :keyword
            AND Id NOT IN :selectedIds
            WITH SECURITY_ENFORCED
            LIMIT 5
        ];

        // Build results
        for (Account acc : accounts) {
            results.add(new LookupSearchResult(
                acc.Id,
                'Account',
                'standard:account',
                acc.Name,
                (acc.Industry != null ? acc.Industry : 'No Industry') + 
                ' • ' + 
                (acc.BillingCity != null ? acc.BillingCity : 'No City')
            ));
        }

        return results;
    }
}