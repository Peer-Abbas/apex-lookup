public with sharing class MultiObjectLookupController {

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> searchAll(
        String searchTerm,
        List<String> selectedIds
    ) {
        List<LookupSearchResult> results = new List<LookupSearchResult>();

        // Safe search term — prevents SOQL injection
        String keyword = '%' + String.escapeSingleQuotes(searchTerm) + '%';

        // ─── Search Accounts ───────────────────────────────────────────
        List<Account> accounts = [
            SELECT Id, Name, Industry, BillingCity
            FROM Account
            WHERE Name LIKE :keyword
            AND Id NOT IN :selectedIds
            WITH SECURITY_ENFORCED
            LIMIT 5
        ];

        for (Account acc : accounts) {
            results.add(new LookupSearchResult(
                acc.Id,
                'Account',
                'standard:account',
                acc.Name,
                (acc.Industry  != null ? acc.Industry  : 'No Industry') +
                ' • ' +
                (acc.BillingCity != null ? acc.BillingCity : 'No City')
            ));
        }

        // ─── Search Contacts ───────────────────────────────────────────
        List<Contact> contacts = [
            SELECT Id, Name, Email, Title, Account.Name
            FROM Contact
            WHERE Name LIKE :keyword
            AND Id NOT IN :selectedIds
            WITH SECURITY_ENFORCED
            LIMIT 5
        ];

        for (Contact con : contacts) {
            results.add(new LookupSearchResult(
                con.Id,
                'Contact',
                'standard:contact',
                con.Name,
                (con.Title != null ? con.Title : 'No Title') +
                ' • ' +
                (con.Account.Name != null ? con.Account.Name : 'No Account')
            ));
        }

        // ─── Search Opportunities ──────────────────────────────────────
        List<Opportunity> opps = [
            SELECT Id, Name, StageName, CloseDate
            FROM Opportunity
            WHERE Name LIKE :keyword
            AND Id NOT IN :selectedIds
            WITH SECURITY_ENFORCED
            LIMIT 5
        ];

        for (Opportunity opp : opps) {
            results.add(new LookupSearchResult(
                opp.Id,
                'Opportunity',
                'standard:opportunity',
                opp.Name,
                (opp.StageName != null ? opp.StageName : 'No Stage') +
                ' • ' +
                (opp.CloseDate != null ? String.valueOf(opp.CloseDate) : 'No Date')
            ));
        }

        return results;
    }
}