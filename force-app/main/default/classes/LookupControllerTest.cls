@isTest
public class LookupControllerTest {

    // ─── Setup Test Data ───────────────────────────────────────────────
    @TestSetup
    static void setup() {
        // Create test accounts
        List<Account> accounts = new List<Account>{
            new Account(
                Name        = 'Ali Traders',
                Industry    = 'Retail',
                BillingCity = 'Lahore'
            ),
            new Account(
                Name        = 'Abbas Corp',
                Industry    = 'Technology',
                BillingCity = 'Karachi'
            ),
            new Account(
                Name        = 'Peer Solutions',
                Industry    = 'Consulting',
                BillingCity = 'Islamabad'
            )
        };
        insert accounts;
    }

    // ─── Test 1: Basic Search Returns Results ──────────────────────────
    @isTest
    static void testSearchReturnsResults() {
        Test.startTest();
            List<LookupSearchResult> results =
                AccountLookupController.search('Ali', new List<String>());
        Test.stopTest();

        Assert.areEqual(1, results.size(), 'Should find 1 account');
        Assert.areEqual('Ali Traders',  results[0].title);
        Assert.areEqual('Account',      results[0].sObjectType);
        Assert.areEqual('standard:account', results[0].icon);
    }

    // ─── Test 2: Search Excludes Selected IDs ─────────────────────────
    @isTest
    static void testSearchExcludesSelectedIds() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Ali Traders' LIMIT 1];

        Test.startTest();
            List<LookupSearchResult> results =
                AccountLookupController.search('Ali', new List<String>{ acc.Id });
        Test.stopTest();

        Assert.areEqual(0, results.size(), 'Excluded ID should not appear');
    }

    // ─── Test 3: Search With No Match Returns Empty ────────────────────
    @isTest
    static void testSearchNoMatch() {
        Test.startTest();
            List<LookupSearchResult> results =
                AccountLookupController.search('ZZZNOMATCH', new List<String>());
        Test.stopTest();

        Assert.areEqual(0, results.size(), 'Should return empty list');
    }

    // ─── Test 4: Search Returns Multiple Results ───────────────────────
    @isTest
    static void testSearchReturnsMultiple() {
        Test.startTest();
            List<LookupSearchResult> results =
                AccountLookupController.search('a', new List<String>());
        Test.stopTest();

        Assert.isTrue(results.size() > 1, 'Should return multiple results');
    }

    // ─── Test 5: Subtitle Contains Industry and City ───────────────────
    @isTest
    static void testSubtitleFormat() {
        Test.startTest();
            List<LookupSearchResult> results =
                AccountLookupController.search('Abbas', new List<String>());
        Test.stopTest();

        Assert.areEqual(1, results.size(), 'Should find Abbas Corp');
        Assert.isTrue(
            results[0].subtitle.contains('Technology'),
            'Subtitle should contain Industry'
        );
        Assert.isTrue(
            results[0].subtitle.contains('Karachi'),
            'Subtitle should contain City'
        );
    }
}