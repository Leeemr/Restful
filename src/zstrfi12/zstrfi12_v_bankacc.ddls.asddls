    @AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 입금 거래 내역 조회 - Bank Account Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSTRFI12_V_BANKACC 
as select distinct from ZSTRFI12_V_BANK
   association [0..*] to ZSTRFI12_V_BANK               as _V_BANK              
        on  $projection.BankInternalID        = _V_BANK.BankInternalID
{

//   HouseBank,
//    HouseBankAccount  
//          
    @Consumption.valueHelpDefault.display: true 
    @EndUserText.label: '주거래은행계좌'    
    key BankAccount,
    
    @EndUserText.label: '주거래은행키'
    key BankInternalID
}

group by
   BankAccount,
   BankInternalID
//   HouseBank,
//    HouseBankAccount  
