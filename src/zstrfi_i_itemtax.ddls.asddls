@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 전표아이템 - TAX'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_ITEMTAX as select from ZSTRFI_I_JOURNALITEM
{
  key CompanyCode,

  key AccountingDocument,

  key FiscalYear,

  key AccountingDocumentItem,

      TransactionCurrency,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      AmountInTransactionCurrency,

      CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency,

      TaxCode,

      TransactionTypeDetermination
}
where
      FinancialAccountType         = 'S'
  and TransactionTypeDetermination = 'VST'
  and GLAccount                    = '0012600000'
