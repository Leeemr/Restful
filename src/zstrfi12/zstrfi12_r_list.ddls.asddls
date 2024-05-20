@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 입금 거래 내역 조회'

define root view entity ZSTRFI12_R_LIST
  as select from zstrfi12_i_list as _LIST
      left outer join I_Customer as _CUSTOMER 
                 on _LIST.Customer2 = _CUSTOMER.Customer

  //  association [0..*] to I_JournalEntry               as _JournalEntry               on  $projection.CompanyCode        = _JournalEntry.CompanyCode
  //                                                                                    and $projection.AccountingDocument = _JournalEntry.AccountingDocument
  //
  //  association [0..1] to I_Customer                   as _customer                   on  $projection.Customer2 = _customer.Customer
  //
  //  association [0..1] to I_HouseBankAccountLinkage    as _HouseBankAccountLinkage    on  $projection.BankAccount = _HouseBankAccountLinkage.BankAccount
  //  association [0..1] to I_GlAccountTextInCompanycode as _GlAccountTextInCompanycode on  $projection.GLAccount                = _GlAccountTextInCompanycode.GLAccount
  //                                                                                    and _GlAccountTextInCompanycode.Language = '3'

{
  key _LIST.CompanyCode,
  key _LIST.TransactionKey,
  key _LIST.uuid,
  key _LIST.SequenceNo,
  key _LIST.FiscalYear3,
      _LIST.FiscalYear,
      _LIST.AccountingDocument,
      _LIST.Customer,
      _LIST.Customer2,
      _LIST.CustomerName,      
      @EndUserText.label: '고객 명'
      _CUSTOMER.CustomerName as CustomerName2,
      _LIST.JournalEntryType,
      _LIST.CreditAccount,
      _LIST.CreditAccountDetail,
      _LIST.ReconciliationAccount,
      _LIST.ReconciliationDetail,
      @Consumption.valueHelpDefault.display: true
      _LIST.BankInternalID,
      _LIST.BankAccount,
      _LIST.HouseBank,
      _LIST.HouseBankAccount,
      _LIST.HouseBankName,
      _LIST.HouseBankAccountKey,
      _LIST.GLAccount,
      _LIST.TransactionDetail,
      _LIST.IncomingAmount,
      _LIST.OutgoingAmount,
      _LIST.TransactionAmount,
      _LIST.Waers,
      _LIST.TransactionGb,
      _LIST.TransactionGbNumber,
      _LIST.status,
      case _LIST.status 
           when 'S' then 3
           when 'X' then 1
           when 'R' then 2
           when 'e' then 1          
           else 2 end as Status_icon,
     @EndUserText.label: '처리결과'
     case _LIST.status 
          when 'S' then '전표생성완료'
          when 'X' then '처리제외'
          when 'R' then '전표생성준비'
          when 'E' then '에러'
          else _LIST.status end as STATUSNAME,
          case _LIST.status 
          when 'S' then '전표생성완료'
          when 'X' then '처리제외'
          when 'R' then '전표생성준비'
          when 'E' then '에러'
          else _LIST.status end as STATUSNAME2,
      _LIST.TransactionTime,
      _LIST.TransactionDate,
      _LIST.CreatedBy,
      _LIST.CreatedAt,
      _LIST.LocalLastChangedBy,
      _LIST.LocalLastChangedAt,
      _LIST.LastChangedBy,
      _LIST.LastChangedAt,

      //public associations
      _LIST._JournalEntry,
//      _customer,
      _LIST._HouseBankAccountLinkage,
      _LIST._GlAccountTextInCompanycode

      //
      //
      //      @EndUserText.label: '회사코드'
      //  key bukrs                                     as CompanyCode,
      //  key tran_key                                  as TransactionKey,
      //  key uuid,
      //      @EndUserText.label: 'SeqNo'
      //  key seq_no                                    as SequenceNo,
      //      @EndUserText.label: '회계년도'
      //  key gjahr                                     as FiscalYear,
      //      @EndUserText.label: '전표번호'
      //      belnr                                     as AccountingDocument,
      //      @EndUserText.label: '고객 코드'
      //      kunnr                                     as Customer,
      //      @EndUserText.label: '고객 코드'
      //      lpad(kunnr,10,'0')                        as Customer2,
      //      @EndUserText.label: '고객 명'
      //      knunrname                                 as CustomerName,
      //      @EndUserText.label: '전표유형'
      //      blart                                     as JournalEntryType,
      //      @EndUserText.label: '차변계정'
      //      caccnt                                    as CreditAccount,
      //      @EndUserText.label: '차변 내역'
      //      caccntt_dt                                as CreditAccountDetail,
      //      @EndUserText.label: '대변계정(Recon)'
      //      akont                                     as ReconciliationAccount,
      //      @EndUserText.label: '대변 내역'
      //      akont_dt                                  as ReconciliationDetail,
      //
      //      @EndUserText.label: '주거래은행키'
      //      ubnkl                                     as BankInternalID,
      //      @EndUserText.label: '자사은행계정'
      //      ubknt                                     as BankAccount,
      //
      //      @EndUserText.label: '주거래은행명'
      //      _HouseBankAccountLinkage.BankAccount      as HouseBankAccount,
      //      @EndUserText.label: '주거래은행계좌'
      //      _HouseBankAccountLinkage.BankName         as HouseBankName,
      //      @EndUserText.label: '대변 계정'
      //      _HouseBankAccountLinkage.GLAccount        as GLAccount,
      //
      //      @EndUserText.label: '적요'
      //      jukyo                                     as TransactionDetail,
      //      @EndUserText.label: '입금액'
      //      @Semantics.amount.currencyCode: 'Waers'
      //      in_bal                                    as IncomingAmount,
      //      @EndUserText.label: '출금액'
      //      @Semantics.amount.currencyCode: 'Waers'
      //      out_bal                                   as OutgoingAmount,
      //      //      @EndUserText.label: '계좌통화코드'
      //      //      currcd                as Currency,
      //      @EndUserText.label: '통화'
      //      waers                                     as Waers,
      //      @EndUserText.label: '거래구분'
      //      tran_gb                                   as TransactionGb,
      //      @EndUserText.label: '거래구분명'
      //      tran_gb_nm                                as TransactionGbNumber,
      //
      //      @EndUserText.label: '처리결과'
      //      status                                    as status,
      //      @EndUserText.label: '거래시각'
      //      trans_time                                as TransactionTime,
      //      @EndUserText.label: '거래일자'
      //      trans_date                                as TransactionDate,
      //
      //      @Semantics.user.createdBy: true
      //      created_by                                as CreatedBy,
      //      @Semantics.systemDateTime.createdAt: true
      //      created_at                                as CreatedAt,
      //      @Semantics.user.localInstanceLastChangedBy: true
      //      local_last_changed_by                     as LocalLastChangedBy,
      //      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      //      local_last_changed_at                     as LocalLastChangedAt,
      //      @Semantics.user.lastChangedBy: true
      //      last_changed_by                           as LastChangedBy,
      //      @Semantics.systemDateTime.lastChangedAt: true
      //      last_changed_at                           as LastChangedAt,


}
