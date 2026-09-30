USE [ODL]
GO
/****** Object:  StoredProcedure [dbo].[fxodl_ordermarketstatus_Create]    Script Date: 30/9/2026 1:52:47 μμ ******/
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
ALTER PROCEDURE [dbo].[fxodl_ordermarketstatus_Create]
	@marStatMarketID char(1),
	@marStatBoardID char(1),
	@marStatStatus char(1),
	@marVenueId char(4),
	@appMsgId int,
	@msgSeqNum int,
	@AppID varchar(250),
	@msgSource tinyint,				/*0 = Administrator, 1 = Broker*/
	@DayOfYear smallint,
	@ATHEXServer tinyint			/*0 = ETS, 1 = ORA, 2 = DSS*/ 
as
set nocount on

	/*we check if we have already insert this particular msgid*/
	if exists(select * from dbo.OrderMarketStatus where msgid = @appMsgId and MarVenueId = @marVenueId and datepart(dayofyear, WorkingDate) = @DayOfYear)
		return


	insert into dbo.OrderMarketStatus
		(MarStatMarketID, MarStatBoardID, MarStatStatus, MarVenueId, msgid)
	values
		(@marStatMarketID, @marStatBoardID, @marStatStatus, @marVenueId, @appMsgId);

			
	update dbo.MarketStatus set MarStatStatus = @marStatStatus, WorkingDate = getdate() where MarStatMarketID = @marStatMarketID and MarStatBoardID = @marStatBoardID

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
