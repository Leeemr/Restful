@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 세금계산서 대사'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_NTSJE_PROC
  as select from ZSTRFI_I_NTSJE_SOURCE
  association to ZSTRFI_I_NTSJE_CNT as _NtsJeCnt on  $projection.HTApprvNo          = _NtsJeCnt.HTApprvNo
  association to ZSTRFI_I_JENTS_CNT as _JeNtsCnt on  $projection.CompanyCode        = _JeNtsCnt.CompanyCode
                                                 and $projection.FiscalYear         = _JeNtsCnt.FiscalYear
                                                 and $projection.AccountingDocument = _JeNtsCnt.AccountingDocument
{
  key HTApprvNo,
  
  key CompanyCode,
  
  key FiscalYear,
  
  key AccountingDocument,
  
      HTInputDate,
      
      HTSupplierNo,
      
      @Semantics.amount.currencyCode: 'Currency'
      HTSupplyAmount,
      
      HTSupplier,
      
      @Semantics.amount.currencyCode: 'Currency'
      HTTaxAmount,
      
      @Semantics.amount.currencyCode: 'Currency'
      HTTotalAmount,
      
      Currency,
      
      BusinessPlace,
      
      AccountingDocumentType,
      
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
      
      _NtsJeCnt.cnt as NtsCnt,
      
      _JeNtsCnt.cnt as JeCnt,
      
      @Semantics.amount.currencyCode: 'Currency'
      case
        when AccountingDocument is null
          then HTTotalAmount
        else
          HTTotalAmount - TotalAmount
      end as CalcuTotal
}
