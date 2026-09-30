USE [ODL]
GO
/****** Object:  StoredProcedure [dbo].[fxodl_Orders_UpdateStatuses]    Script Date: 30/9/2026 1:58:02 μμ ******/
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
	Version: 2.2 - (30 September 2026) - Euronext Release - AppID converted to varchar(250)
*/
ALTER PROCEDURE [dbo].[fxodl_Orders_UpdateStatuses]
	@orderID int,
	@processCode int,
	@statusCode char(1),
	@rejectReasonCode char(3),
	@appMsgId int,
	@msgSeqNum int,
	@AppID varchar(250),
	@msgSource tinyint,				/*0 = Administrator, 1 = Broker*/
	@DayOfYear smallint,
	@ATHEXServer tinyint			/*0 = ETS, 1 = ORA, 2 = DSS*/ 
AS
set nocount on

	/*we check if we have already insert this particular msgid*/
	if exists(select * from dbo.PatioFIXClients_MsgIds where ATHEXServer = @ATHEXServer and MsgId = @appMsgId and [DayOfYear] = @DayOfYear)
		return

	/*we save this msgid so that do not replay it in future*/
	insert into [dbo].[PatioFIXClients_MsgIds] ([ATHEXServer],[MsgId],[DayOfYear],[AppID],[MesssageSource]) values (@ATHEXServer,@appMsgId,@DayOfYear,@AppID,@msgSource)


	/*do the real work here*/
	if @statusCode = /*Rejected*/'8' 
		begin
			declare @errorText varchar(100);
			select @errorText = isnull(RejReasDescription,'Unidentified Error Code') from [dbo].[RejReason] where [RejReasCode] = @rejectReasonCode
 
			UPDATE Orders set OrderProcessCode = @processCode, OrderStatusCode = @statusCode, OrderRejectText= @errorText where OrderID = @orderID;
		end 
	else begin

			if @processCode = /*H_entolh_akyrwshs_apetyxe*/12 
				begin
					/*Εαν ειναι ηδη ακυρωμενη, δλδ ειναι σε status 11 δεν το αλλαζουμε:*/
					update Orders set OrderProcessCode = @processCode, OrderStatusCode = @statusCode where OrderID = @orderID and OrderProcessCode != /*H_entolh_akyrwshs_petyxe*/11
				end 
			else begin
				update Orders set OrderProcessCode = @processCode, OrderStatusCode = @statusCode where OrderID = @orderID;
			end
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
