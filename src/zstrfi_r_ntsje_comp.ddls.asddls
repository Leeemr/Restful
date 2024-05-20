@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 세금계산서 대사'
define root view entity ZSTRFI_R_NTSJE_COMP
  as select from ZSTRFI_I_NTSJE_COMP
{
  key HTApprvNo,
  
  key CompanyCode,
  
  key FiscalYear,
  
  key AccountingDocument,
  
      HTInputDate,
      
      HTSupplierNo,
      
      HTSupplier,
      
      HTSupplyAmount,
      
      HTTaxAmount,
      
      HTTotalAmount,
      
      Currency,
      
      BusinessPlace,
      
      AccountingDocumentType,
      
      Supplier,
      
      SupplierName,
      
      DocumentDate,
      
      PostingDate,
      
      SupplyAmount,
      
      TaxAmount,
      
      TotalAmount,
      
      TransactionCurrency,
      
      SupplierTaxNum2,
      
      NtsCnt,
      
      JeCnt,
      
      CalcuTotal,
      
      @Consumption          : {
        filter              : {
//          mandatory         : true,
          selectionType     : #INTERVAL
        }
      }
      SDate,
      
      SSuplierNo
}
