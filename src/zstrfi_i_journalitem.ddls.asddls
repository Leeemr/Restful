@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 전표아이템 BASE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_JOURNALITEM
  as select from I_OperationalAcctgDocItem
  association [0..1] to I_TaxCodeValueHelp as _TaxCode on  $projection.TaxCode              = _TaxCode.TaxCode
                                                       and _TaxCode.TaxCalculationProcedure = '0TXKR'
{
  key CompanyCode,

  key AccountingDocument,

  key FiscalYear,

  key AccountingDocumentItem,

      FinancialAccountType,

      TransactionCurrency,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      AmountInTransactionCurrency,

      CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency,
  
      GLAccount,
    
      PostingKey,
    
      TaxCode,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TaxAmount,

      Supplier,

      AssignmentReference,

      DocumentItemText,

      TransactionTypeDetermination,

      _FinancialAccountType,

      _Supplier,

      _TransactionCurrency,

      _CompanyCodeCurrency,

      _CompanyCode,

      _TaxCode
}
