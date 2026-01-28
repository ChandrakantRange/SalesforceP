public  class AccountCreate {
    @AuraEnabled

    public static void createAccount(String name,String phone,String website,Integer employees, Integer revenue
    ) {
        Account acc = new Account(
            Name = name,
            Phone = phone,
            Website = website,
            NumberOfEmployees = employees,
            AnnualRevenue = revenue
        );
        insert acc;
    }
}