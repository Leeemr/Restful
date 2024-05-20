@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 부가세 신고 - 세금계산서 기준 회계원장 대사'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_JOURNALTAX03
  as select from ZSTRFI_I_JOURNALITEM03
{
  key CompanyCode,

  key FiscalYear,

  key AccountingDocument,

      GLAccount,

      TransactionCurrency,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      AmountInTransactionCurrency     as TaxAmount,

      DebitCreditCode
}
where
      DebitCreditCode      = 'S'
  and GLAccount            = '0012600000'
