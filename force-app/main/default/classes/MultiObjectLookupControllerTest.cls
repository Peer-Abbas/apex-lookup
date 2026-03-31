@isTest
public class MultiObjectLookupControllerTest {

    // ─── Setup Test Data ───────────────────────────────────────────────
    @TestSetup
    static void setup() {
        // Create test Account
        Account acc = new Account(
            Name        = 'Peer Solutions',
            Industry    = 'Technology',
            BillingCity = 'Lahore'
        );
        insert acc;

        // Create test Contact linked to Account
        Contact con = new Contact(
            FirstName = 'Abbas',
            LastName  = 'Ali',
            Email     = 'abbas@peersolutions.com',
            Title     = 'Developer',
            AccountId = acc.Id
        );
        insert con;

        // Create test Opportunity linked to Account
        Opportunity opp = new Opportunity(
            Name        = 'Peer Deal 2025',
            StageName   = 'Prospecting',
            CloseDate   = Date.today().addDays(30),
            AccountId   = acc.Id
        );
        insert opp;
    }

    // ─── Test 1: Search Finds Account ─────────────────────────────────
    @isTest
    static void testSearchFindsAccount() {
        Test.startTest();
            List<LookupSearchResult> results =
                MultiObjectLookupController.searchAll('Peer', new List<String>());
        Test.stopTest();

        // Find account result
        Boolean foundAccount = false;
        for (LookupSearchResult r : results) {
            if (r.sObjectType == 'Account') {
                foundAccount = true;
                Assert.areEqual('Peer Solutions', r.title);
                Assert.areEqual('standard:account', r.icon);
            }
        }
        Assert.isTrue(foundAccount, 'Should find Account in results');
    }

    // ─── Test 2: Search Finds Contact ─────────────────────────────────
    @isTest
    static void testSearchFindsContact() {
        Test.startTest();
            List<LookupSearchResult> results =
                MultiObjectLookupController.searchAll('Abbas', new List<String>());
        Test.stopTest();

        Boolean foundContact = false;
        for (LookupSearchResult r : results) {
            if (r.sObjectType == 'Contact') {
                foundContact = true;
                Assert.areEqual('Abbas Ali', r.title);
                Assert.areEqual('standard:contact', r.icon);
            }
        }
        Assert.isTrue(foundContact, 'Should find Contact in results');
    }

    // ─── Test 3: Search Finds Opportunity ─────────────────────────────
    @isTest
    static void testSearchFindsOpportunity() {
        Test.startTest();
            List<LookupSearchResult> results =
                MultiObjectLookupController.searchAll('Peer Deal', new List<String>());
        Test.stopTest();

        Boolean foundOpp = false;
        for (LookupSearchResult r : results) {
            if (r.sObjectType == 'Opportunity') {
                foundOpp = true;
                Assert.areEqual('Peer Deal 2025', r.title);
                Assert.areEqual('standard:opportunity', r.icon);
            }
        }
        Assert.isTrue(foundOpp, 'Should find Opportunity in results');
    }

    // ─── Test 4: Search Excludes Selected IDs ─────────────────────────
    @isTest
    static void testSearchExcludesSelectedIds() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Peer Solutions' LIMIT 1];

        Test.startTest();
            List<LookupSearchResult> results =
                MultiObjectLookupController.searchAll(
                    'Peer', new List<String>{ acc.Id }
                );
        Test.stopTest();

        for (LookupSearchResult r : results) {
            Assert.areNotEqual(acc.Id, r.id, 'Excluded ID should not appear');
        }
    }

    // ─── Test 5: No Match Returns Empty ───────────────────────────────
    @isTest
    static void testNoMatchReturnsEmpty() {
        Test.startTest();
            List<LookupSearchResult> results =
                MultiObjectLookupController.searchAll('ZZZNOMATCH', new List<String>());
        Test.stopTest();

        Assert.areEqual(0, results.size(), 'Should return empty list');
    }

    // ─── Test 6: Mixed Results Returned ───────────────────────────────
    @isTest
    static void testMixedResultsReturned() {
        Test.startTest();
            List<LookupSearchResult> results =
                MultiObjectLookupController.searchAll('Peer', new List<String>());
        Test.stopTest();

        Assert.isTrue(results.size() >= 2, 'Should return Account and Opportunity');
    }
}