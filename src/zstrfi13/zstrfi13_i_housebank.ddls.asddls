@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 입출금 거래 내역 조회'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSTRFI13_I_HOUSEBANK 
  as select from I_HouseBankAccountLinkage as _HouseBankAccountLinkage
{
  key _HouseBankAccountLinkage.HouseBank               as HouseBank,
       _HouseBankAccountLinkage.BankAccount     as BankAccount1, 
      _HouseBankAccountLinkage.BankAccountNumber      as BankAccount2,
      replace( _HouseBankAccountLinkage.BankAccountNumber, '-' , ' ' )  as BankAccount,
      
      _HouseBankAccountLinkage.BankName                as BankName,
      _HouseBankAccountLinkage.HouseBankAccount        as HouseBankAccount,
      _HouseBankAccountLinkage.GLAccount               as GLAccount,
      _HouseBankAccountLinkage.BankAccountCurrency     as BankAccountCurrency

}
