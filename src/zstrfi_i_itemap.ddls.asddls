@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 전표아이템 - AP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_ITEMAP  as select from ZSTRFI_I_JOURNALITEM
  
{
  key CompanyCode,

  key AccountingDocument,

  key FiscalYear,

  key AccountingDocumentItem,

      FinancialAccountType,

      Supplier,

      _Supplier.SupplierFullName,
      
      PostingKey,

      TransactionCurrency,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      AmountInTransactionCurrency,

      CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency
}
where
  FinancialAccountType = 'K'
