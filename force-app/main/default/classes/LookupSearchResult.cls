public class LookupSearchResult {
    
    @AuraEnabled public String id          { get; set; }
    @AuraEnabled public String sObjectType { get; set; }
    @AuraEnabled public String icon        { get; set; }
    @AuraEnabled public String title       { get; set; }
    @AuraEnabled public String subtitle    { get; set; }

    public LookupSearchResult(
        String id,
        String sObjectType,
        String icon,
        String title,
        String subtitle
    ) {
        this.id          = id;
        this.sObjectType = sObjectType;
        this.icon        = icon;
        this.title       = title;
        this.subtitle    = subtitle;
    }
}