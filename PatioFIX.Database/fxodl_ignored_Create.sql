USE [ODL]
GO
/****** Object:  StoredProcedure [dbo].[fxodl_ignored_Create]    Script Date: 23/9/2026 4:05:05 μμ ******/
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
*/
ALTER PROCEDURE [dbo].[fxodl_ignored_Create]
	@messageType char(2),
	@appMsgId int,
	@msgSeqNum int,
	@AppID varchar(250),
	@msgSource tinyint,				/*0 = Administrator, 1 = Broker*/
	@DayOfYear smallint,
	@ATHEXServer tinyint			/*0 = ETS, 1 = ORA, 2 = DSS*/ 
as
set nocount on


	if exists(select * from IgnoredMessages where msgid=@appMsgId and [DayOfYear] = @DayOfYear and AppID=@AppID) 
		return

	insert into dbo.IgnoredMessages
		(msgid,DayOfYear, AppID)
	values 
		(@appMsgId, @DayOfYear, @AppID)


	/*
		Σε αυτο το σημείο αποθηκεύουμε το τελευταίο messageID που μας ήρθε
	*/
	if @ATHEXServer = /*ETS*/0 begin
		update [dbo].[PatioFIXClients_State] set ETS_LastAppMsgId = @appMsgId, ETS_LastMsgSeqNum = @msgSeqNum, LastUpdateDT = GETDATE() where AppID=@AppID and DayOfYear = @DayOfYear
	end
	else if @ATHEXServer = /*ORA*/1 begin
		update [dbo].[PatioFIXClients_State] set ORA_LastAppMsgId = @appMsgId, ORA_LastMsgSeqNum = @msgSeqNum,LastUpdateDT = GETDATE() where AppID=@AppID and DayOfYear = @DayOfYear
	end
