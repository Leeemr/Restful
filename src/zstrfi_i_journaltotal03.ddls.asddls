@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 부가세 신고 - 세금계산서 기준 회계원장 대사'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_JOURNALTOTAL03
  as select from ZSTRFI_I_JOURNALITEM03
  association to I_KR_SupplierVATInformation as _KRSupplier on $projection.Supplier = _KRSupplier.Supplier

{
  key CompanyCode,

  key FiscalYear,

  key AccountingDocument,

      TransactionCurrency,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      AmountInTransactionCurrency as TotalAmount,

      DebitCreditCode,
      
      FinancialAccountType,
      
      AccountingDocumentType,

      GLAccount,

      Supplier,

      _Supplier.SupplierFullName  as SupplierName,

      _Supplier.TaxNumber2        as SupplierTaxNum2,

      _KRSupplier
}
where
   FinancialAccountType = 'K'
//   DebitCreditCode = 'H'
