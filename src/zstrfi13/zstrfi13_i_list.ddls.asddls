@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 입출금 거래 내역 조회'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZSTRFI13_I_LIST
  as select from zstrfi13_alist

  association [0..*] to I_JournalEntry               as _JournalEntry               on  $projection.CompanyCode        = _JournalEntry.CompanyCode
                                                                                    and $projection.AccountingDocument = _JournalEntry.AccountingDocument

  association [0..1] to ZSTRFI13_I_HOUSEBANK         as _HouseBankAccountLinkage    on  $projection.BankAccount = _HouseBankAccountLinkage.BankAccount
                                                                                    and $projection.Waers  = _HouseBankAccountLinkage.BankAccountCurrency 
  association [0..1] to I_GlAccountTextInCompanycode as _GlAccountTextInCompanycode on  $projection.GLAccount                = _GlAccountTextInCompanycode.GLAccount
                                                                                    and _GlAccountTextInCompanycode.Language = '3'

{
      
  key tran_key                                  as TransactionKey,
  key uuid,
     @EndUserText.label: '회사코드'
      bukrs                                     as CompanyCode,
      @EndUserText.label: 'SeqNo'
      seq_no                                    as SequenceNo,
      @EndUserText.label: '회계년도'
      gjahr                                     as FiscalYear,
      @EndUserText.label: '전표번호'
      belnr                                     as AccountingDocument,
      @EndUserText.label: '전표유형'
      blart                                     as JournalEntryType,
      @EndUserText.label: '차변계정'
      caccnt                                    as CreditAccount,
      @EndUserText.label: '차변 내역'
      caccntt_dt                                as CreditAccountDetail,
      @EndUserText.label: '대변계정(Recon)'
      akont                                     as ReconciliationAccount,
      @EndUserText.label: '대변 내역'
      akont_dt                                  as ReconciliationDetail,

      @EndUserText.label: '주거래은행키'
      ubnkl                                     as BankInternalID,
      @EndUserText.label: '은행계좌(기웅)'
      ubknt                                     as BankAccount,
      @EndUserText.label: '주거래은행'
      _HouseBankAccountLinkage.HouseBank        as HouseBank,
      @EndUserText.label: '은행계좌(SAP)'
      _HouseBankAccountLinkage.BankAccount      as HouseBankAccount,
      @EndUserText.label: '주거래은행명'
      _HouseBankAccountLinkage.BankName         as HouseBankName,
      @EndUserText.label: '주거래은행계좌키'
      _HouseBankAccountLinkage.HouseBankAccount as HouseBankAccountKey,
      @EndUserText.label: '대변 계정'
      _HouseBankAccountLinkage.GLAccount        as GLAccount,

      @EndUserText.label: '적요'
      jukyo                                     as TransactionDetail,
      @EndUserText.label: '입금액'
      @Semantics.amount.currencyCode: 'Waers'
      in_bal                                    as IncomingAmount,
      @EndUserText.label: '출금액'
      @Semantics.amount.currencyCode: 'Waers'
      out_bal                                   as OutgoingAmount,
      @EndUserText.label: '잔액'
      @Semantics.amount.currencyCode: 'Waers'
      tran_bal                                  as TransactionAmount,      
      //      @EndUserText.label: '계좌통화코드'
      //      currcd                as Currency,
      @EndUserText.label: '통화'
      waers                                     as Waers,
      @EndUserText.label: '거래구분'
      tran_gb                                   as TransactionGb,
      @EndUserText.label: '거래구분명'
      tran_gb_nm                                as TransactionGbName,

      @EndUserText.label: '처리결과'
      status                                    as status,
      @EndUserText.label: '거래시각'
      trans_time                                as TransactionTime,
      @EndUserText.label: '거래일자'
      trans_date                                as TransactionDate,

      @Semantics.user.createdBy: true
      created_by                                as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                                as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by                     as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at                     as LocalLastChangedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by                           as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                           as LastChangedAt,

      //public associations
      _JournalEntry,
      //      _customer,
      _HouseBankAccountLinkage,
      _GlAccountTextInCompanycode

}
