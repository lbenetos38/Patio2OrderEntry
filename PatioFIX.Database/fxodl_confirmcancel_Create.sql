USE [ODL]
GO
/****** Object:  StoredProcedure [dbo].[fxodl_confirmcancel_Create]    Script Date: 30/9/2026 1:44:30 μμ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
	Project Name: 'Patio2FixClients'
	Author: 'gmil'
	Original Code produced at: '29/01/2021 9:57:16 πμ'
	---------------------------------
	Version: 2.0 - (7 June 2022) - FIX protocol adaptation
	Version: 2.1 - (15 February 2023) - FIX protocol release...
	Version: 2.2 - (3 March 2023) - Bank_Orders integration...
	Version: 2.3 - (30 September 2026) - Euronext Release - AppID converted to varchar(250)
*/
ALTER PROCEDURE [dbo].[fxodl_confirmcancel_Create]
	@cfcMemberID char(4),
	@cfcTraderID char(5),
	@cfcBoardID char(1),
	@clOrdID char(16),						--ClOrdID tag11
	@cfcCSDAccountID char(12),
	@cfcOrderNumber char(8),
	@cfcEntryDate char(8),
	@cfcSource char(1),
	@cfcReasonCode char(1),
	@cfcTime char(8),
	@cfcVenueId char(4),
	@cfcLeavesQuantity decimal(18,0),		--LeavesQty::tag151
	@cfcAveragePrice decimal(18,6),
	@cfcEditType char(1),
	@cfcCurrentCreditValue decimal(18,2),
	@cfcCreditLimitValue decimal(18,2) = null,
	@origClOrdID varchar(16),				--OrigClOrdID  tag41
	@cfcSecurityID nvarchar(20),
	@cfcSecurityIDSource char(1),
	@cfcCurrency char(3),
	@cfcExpirationDate char(8),
	@ODLOrderStatus char(2),				--ODLOrderStatus (not exactly tag39)
	@FIXOrderStatus char(1),				--FIXOrderStatus (the real tag39)
	@DisclosedVolume decimal(18,0),			--MaxShow (tag 210)
	@cfcOrderNote varchar(25),
	@cfcListID char(6),
	@cfcOriCSDAccountID char(10),
	@cfcTimeStamp char(20),
	@exchangeOrderID varchar(64),			/*EXCHANGE's OrderID (Tag37)*/
	@appMsgId int,
	@msgSeqNum int,
	@AppID varchar(250),
	@msgSource tinyint,						/*0 = Administrator, 1 = Broker*/
	@DayOfYear smallint,
	@ATHEXServer tinyint					/*0 = ETS, 1 = ORA, 2 = DSS*/ 
as
set nocount on



	/*we check if we have already insert this particular msgid*/
	if exists(select * from dbo.ConfirmCancel where msgid = @appMsgId and cfcVenueId = @cfcVenueId and datepart(dayofyear, WorkingDate) = @DayOfYear)
		return

	
	/*
		Προσπαθω να διαβασω την αρχικη μου εντολη
		-Αυτο το ConfirmCancel μπορει να ειναι απο Patio2, Eurobank Trader ή απο το BankOrders.
		-Μην ξεχναμε ότι "ακουμε" ConfirmCancels και για Orders που δεν υπαρχουν ατο συστημα μας (Horizon, Catalys, Skouras, ORAMA, ...)
		-Επισης καθε πρωι παιρνουμε ConfirμCancels για  (τυχων) εντολεςδιαρκειας που εγιναν expired (GTC, GTE)
	*/
	declare @OrderID int = null
	declare @OrderComment varchar(128)
	select @OrderID = OrderID, @OrderComment = OrderComment from [dbo].[Orders] where [ExchangeOrderID] = @exchangeOrderID
	


	/*
		Βρισκω το cfcMemberOrderNumber 1) στην αρχη απο το tag41:
	*/
	declare @memberOrderNumber char(16) = /*tag 41*/ @origClOrdID
	/*
		Βρισκω το cfcMemberOrderNumber 2) Εαν το tag41 δεν εχει τιμη, τοτε του δινω την τιμη του tag11:
	*/
	if @memberOrderNumber is null or @memberOrderNumber = '' 
		begin
			set @memberOrderNumber = /*tag 11*/ @clOrdID
		end
	
	/*
		Βρισκω το cfcMemberOrderNumber 1) Εαν ομως εχουμε εμεις την εντολη, τοτε του δινουμε την τιμη του OrderID:
	*/
	if @OrderID is not null 
		begin
			set @memberOrderNumber = @OrderID
		end



	insert into dbo.ConfirmCancel
		(CfcMessageType, CfcMessageSource, CfcMemberID, CfcTraderID, CfcMemberSequenceNumber, CfcBoardID, 
		CfcMemberOrderNumber, CfcCSDAccountID, CfcOrderNumber, 
		CfcEntryDate, CfcSource, CfcReasonCode, CfcTime, msgid, cfcVenueId, cfcLeavesQuantity, cfcAveragePrice, cfcEditType, cfcCurrentCreditValue, /* cfcCreditLimitValue, */
		CfcOrigClientOrderID, CfcClientOrderID,
		CfcSecurityID, CfcSecurityIDSource, CfcCurrency, CfcExpirationDate, CfcOrderStatus, CfcEditedDisclosedVolume, CfcOrderNote, CfcListID, CfcOriCSDAccountID, CfcTimeStamp, 
		ExchangeOrderID)
	values
		('TC', ' ', @cfcMemberID, @cfcTraderID, '000000', @cfcBoardID, 
		@memberOrderNumber, @cfcCSDAccountID, @cfcOrderNumber, 
		@cfcEntryDate, @cfcSource, @cfcReasonCode, @cfcTime, @appMsgId, @cfcVenueId, @cfcLeavesQuantity, @cfcAveragePrice, @cfcEditType, @cfcCurrentCreditValue, /* @cfcCreditLimitValue, */
		@origClOrdID, @clOrdID,
		@cfcSecurityID, @cfcSecurityIDSource, @cfcCurrency, @cfcExpirationDate, @ODLOrderStatus, @DisclosedVolume, @cfcOrderNote, @cfcListID, @cfcOriCSDAccountID, @cfcTimeStamp, 
		@exchangeOrderID);

		
		/*
			Σε αυτο το σημειο πρεπει να αλλαξουμε καταλληλα το status της αρχικης μας εντολης...
		*/
		if @OrderID is not null 
			begin
				update 
					[dbo].[Orders] 
				set 
					[OrderProcessCode] =	 11, /*H_entolh_akyrwshs_petyxe*/
					[OrderStatusCode] =		 4, /*Canceled*/
					[OrderDisclosedVolume] = @DisclosedVolume,
					[LastClOrdID] =			 @clOrdID
				where 
					OrderID = @OrderID
			end

		/*
			Μήπως το Cancel-confirmation που μας ήρθε πρεπει να παει και στην Τραπεζα?
			Δηλαδη insert και στον πίνακα bank.dbo.[Cancels]?
		*/
		if @OrderComment = 'GALATIA\Eurobank' 
			begin
				insert into bank.dbo.Cancels(Cancelorderid, CancelMemberOrderNumber, CancelBankOrderId, CustomerAseCode, CustomerXrimaCode, StockAseCode, BuySell, CancelVolume, Price)
				select
					OrderID, OrderMemberOrderNumber, OrderExternalOrderId, UserAseCode, UserXrimaCode, [StockAseCode], 
					case OrderSide when 'B' then 'Α' when 'S' then 'Π' end as Buysell, @cfcLeavesQuantity, OrderPrice
				from 
					Orders
				where 
					OrderID = @OrderID
			end
	
	/*
		Σε αυτο το σημείο αποθηκεύουμε το τελευταίο messageID που μας ήρθε
	*/
	if @ATHEXServer = 0 /*ETS*/
		begin
			update [dbo].[PatioFIXClients_State] set ETS_LastAppMsgId = @appMsgId, ETS_LastMsgSeqNum = @msgSeqNum, LastUpdateDT = GETDATE() where AppID=@AppID and DayOfYear = @DayOfYear
		end
	else if @ATHEXServer = 1 /*ORA*/
		begin
			update [dbo].[PatioFIXClients_State] set ORA_LastAppMsgId = @appMsgId, ORA_LastMsgSeqNum = @msgSeqNum,LastUpdateDT = GETDATE() where AppID=@AppID and DayOfYear = @DayOfYear
		end


