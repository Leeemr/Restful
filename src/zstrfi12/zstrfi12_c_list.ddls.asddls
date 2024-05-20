@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
//@ObjectModel.semanticKey: [ 'TransactionAmount' ]
@EndUserText.label: '[FI] 입금 거래 내역 조회 전표 처리'
define root view entity ZSTRFI12_C_LIST
  provider contract transactional_query
  as projection on ZSTRFI12_R_LIST

{
      @Search.defaultSearchElement: true
      @Consumption.filter: { selectionType: #SINGLE, multipleSelections: false, defaultValue: '1000', mandatory: true }
      @Consumption.valueHelpDefinition: [{ entity.name: 'I_CompanyCode', entity.element: 'CompanyCode' }]
  key CompanyCode,
  key TransactionKey,
  key uuid,
  key SequenceNo,
  key FiscalYear3,
      FiscalYear,
      @UI.facet: [{ purpose: #QUICK_VIEW, label: 'Accounting Document', type: #HEADERINFO_REFERENCE, targetElement: '_JournalEntry'}]
      AccountingDocument,
      Customer,
      Customer2,
      CustomerName,
      CustomerName2,
      JournalEntryType,
      CreditAccount,
      CreditAccountDetail,
      ReconciliationAccount,
      ReconciliationDetail,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZSTRFI12_V_BANKKEY', entity.element: 'BankInternalID' }]
      BankInternalID,

//      @Consumption.valueHelpDefinition: [{  entity: {name: 'ZSTRFI12_V_BANK', element: 'BankAccount'} ,                                                                                          
//               additionalBinding: [{  element: 'BankAccount' , parameter: 'BankAccount', localElement: 'BankAccount' , usage: #FILTER  }] }] 
//      @Consumption.valueHelpDefinition: [{ entity.name: 'ZSTRFI12_V_BANK', entity.element: 'BankAccount' }]
      BankAccount,
      HouseBank,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZSTRFI12_V_BANKACC', entity.element: 'BankAccount' }]
      HouseBankAccount,
      HouseBankName,
      HouseBankAccountKey,
      GLAccount,
      @EndUserText.label: '대변 내역'
      _GlAccountTextInCompanycode.GLAccountName as GLAccountName,
      TransactionDetail,
      @Semantics.amount.currencyCode: 'waers'
      IncomingAmount,
      @Semantics.amount.currencyCode: 'waers'
      OutgoingAmount,
      @Semantics.amount.currencyCode: 'waers'
      TransactionAmount,
      //    Currency,
      Waers,
      TransactionGb,
      TransactionGbNumber,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZSTRFI12_V_STATUS', entity.element: 'value_low' }]
      status,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZSTRFI12_V_STATUS', entity.element: 'value_low' }]
      STATUSNAME,
      STATUSNAME2,
      Status_icon,
      TransactionTime,
      @Consumption.filter: { selectionType: #INTERVAL, mandatory: true}
      TransactionDate,
      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedBy,
      LastChangedAt,

      //public associations
      _JournalEntry,
      //      _customer,
      _HouseBankAccountLinkage,
      _GlAccountTextInCompanycode
}
