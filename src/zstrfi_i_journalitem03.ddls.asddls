@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 부가세 신고 - 세금계산서 기준 회계원장 대사'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_JOURNALITEM03
  as select distinct from I_JournalEntryItem
{
  key CompanyCode,
  
  key FiscalYear,
  
  key AccountingDocument,
  
  GLAccount,
  
  CostCenter,
  
  ProfitCenter,
  
  TransactionCurrency,
  
  @Semantics.amount.currencyCode: 'TransactionCurrency'
  AmountInTransactionCurrency,
  
  CompanyCodeCurrency,
  
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  AmountInCompanyCodeCurrency,
  
  FunctionalCurrency,
  
  @Semantics.amount.currencyCode: 'FunctionalCurrency'
  AmountInFunctionalCurrency,
  
  FiscalPeriod,
  
  FiscalYearVariant,
  
  FiscalYearPeriod,
  
  PostingDate,
  
  DocumentDate,
  
  AccountingDocumentType,
  
  DebitCreditCode,
  
  AccountingDocumentItem,
  
  PostingKey,
  
  TransactionTypeDetermination,
  
  GLAccountType,
  
  Product,
  
  Plant,
  
  Supplier,
  
  FinancialAccountType,
  
  TaxCode,
  
  /* Associations */
  _AccountingDocumentTypeText,
  _AccountingDocumentType,
  _CompanyCode,
  _FiscalYear,
  _DebitCreditCodeText,
  _GLAccountType,
  _JournalEntry,
  _Plant,
  _PostingKey,
  _Product,
  _ProductText,
  _Supplier,
  _SupplierCompany,
  _SupplierText,
  _TaxCode,
  _TransactionCurrency
  }
