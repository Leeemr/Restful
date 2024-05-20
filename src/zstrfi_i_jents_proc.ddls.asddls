@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 세금계산서 대사'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_JENTS_PROC
  as select from ZSTRFI_I_JENTS_SOURCE
  association to ZSTRFI_I_JENTS_CNT as _JeNtsCnt on  $projection.CompanyCode        = _JeNtsCnt.CompanyCode
                                                 and $projection.FiscalYear         = _JeNtsCnt.FiscalYear
                                                 and $projection.AccountingDocument = _JeNtsCnt.AccountingDocument
  association to ZSTRFI_I_NTSJE_CNT as _NtsJeCnt on  $projection.HTApprvNo          = _NtsJeCnt.HTApprvNo                                                 
{
  key CompanyCode,
  
  key FiscalYear,
  
  key AccountingDocument,
  
  key HTApprvNo,
  
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
      
      _JeNtsCnt.cnt as JeCnt,
      
      _NtsJeCnt.cnt as NtsCnt,
      
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case
        when HTApprvNo is null
          then TotalAmount * -1
        else
          HTTotalAmount - TotalAmount
      end as CalcuTotal,
      
      case
        when HTInputDate is null
          then DocumentDate
        else HTInputDate
      end as   SDate,
      
      case
        when HTSupplierNo is null
          then SupplierTaxNum2
        else HTSupplierNo
      end as  SSuplierNo
}
