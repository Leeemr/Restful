@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 전표아이템 - 공급가액'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_ITEMSUPPLY
  as select from ZSTRFI_I_JOURNALITEM
{
  key CompanyCode,

  key AccountingDocument,

  key FiscalYear,

  key AccountingDocumentItem,
  
      PostingKey,

      TransactionCurrency,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      AmountInTransactionCurrency,

      CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency,

      AssignmentReference,

      DocumentItemText
}
where
      FinancialAccountType         =  'S'
  and TransactionTypeDetermination <> 'VST'
