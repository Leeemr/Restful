@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 세금계산서 대사'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_JENTS_SOURCE 
  as select from ZSTRFI_I_JOURNALENTRY03
  association to ZSTRFI_I_HOMETAX as _HomeTax on  $projection.DocumentDate    = _HomeTax.HTInputDate
                                              and $projection.SupplierTaxNum2 = _HomeTax.HTSupplierNo
                                              and $projection.TotalAmount     = _HomeTax.HTTotalAmount
{
  key CompanyCode,
  
  key FiscalYear,
  
  key AccountingDocument,
  
  key _HomeTax.HTApprvNo,
  
      AccountingDocumentType,
      
      BusinessPlace,
      
      DocumentDate,
      
      PostingDate,
      
      TransactionCurrency,
      
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TaxAmount,
      
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TotalAmount,
      
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      SupplyAmount,
      
      Supplier,
      
      SupplierName,
      
      SupplierTaxNum2,
      
      _HomeTax.HTInputDate,
      
      _HomeTax.HTSupplierNo,
      
      @Semantics.amount.currencyCode: 'Currency'
      _HomeTax.HTSupplyAmount,
      
      _HomeTax.HTSupplier,
      
      @Semantics.amount.currencyCode: 'Currency'
      _HomeTax.HTTaxAmount,
      
      @Semantics.amount.currencyCode: 'Currency'
      _HomeTax.HTTotalAmount,
      
      _HomeTax.Currency
      
}
