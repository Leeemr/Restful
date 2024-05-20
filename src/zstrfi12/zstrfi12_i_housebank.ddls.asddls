@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 입금 거래 내역 조회'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSTRFI12_I_HOUSEBANK
  as select from I_HouseBankAccountLinkage as _HouseBankAccountLinkage

{
  key _HouseBankAccountLinkage.HouseBank        as HouseBank,             
       _HouseBankAccountLinkage.CompanyCode,
       _HouseBankAccountLinkage.BankAccount     as BankAccount1, 
      _HouseBankAccountLinkage.BankAccount      as BankAccount2,
//      trim( cast( _HouseBankAccountLinkage.BankAccount as abap.char(18) ) , '-' )      as BankAccount,
      replace( _HouseBankAccountLinkage.BankAccountNumber, '-' , ' ' )  as BankAccount,
      
      _HouseBankAccountLinkage.BankName         as BankName,
      _HouseBankAccountLinkage.HouseBankAccount as HouseBankAccount,
      _HouseBankAccountLinkage.GLAccount        as GLAccount,
      _HouseBankAccountLinkage.BankAccountCurrency  as BankAccountCurrency

}


