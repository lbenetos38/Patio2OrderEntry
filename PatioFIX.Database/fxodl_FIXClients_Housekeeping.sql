USE [ODL]
GO
/****** Object:  StoredProcedure [dbo].[fxodl_FIXClients_Housekeeping]    Script Date: 23/9/2026 1:10:27 μμ ******/
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
ALTER PROCEDURE [dbo].[fxodl_FIXClients_Housekeeping]
	@AppID varchar(50),
	@odlMesssageSource tinyint,		/*0 = Administrator, 1 = Broker*/
	@DayOfYear smallint
as
set nocount on


	/*we delete old rows (older than 3 days) from the PatioFIXClients_State table*/
	if @DayOfYear = /*πρωτη ημερα του χρονου*/1
		delete from [dbo].[PatioFIXClients_State] where [DayOfYear] not in (365, 366, 1)  and AppID = @AppID
	else if @DayOfYear = /*δευτερη ημερα του χρονου*/2
		delete from [dbo].[PatioFIXClients_State] where [DayOfYear] not in (366, 1, 2)  and AppID = @AppID
	else
		delete from  [dbo].[PatioFIXClients_State] where [DayOfYear] not in (@DayOfYear - 2, @DayOfYear - 1, @DayOfYear) and AppID = @AppID


	/*we make sure that we have a row inside PatioFIXClients_State for the @DayOfYear*/
	if not exists(select * from [dbo].[PatioFIXClients_State] where DayOfYear = @DayOfYear and AppID = @AppID and MesssageSource = @odlMesssageSource) begin

		insert into [dbo].[PatioFIXClients_State] (DayOfYear, AppID, MesssageSource) values (@DayOfYear, @AppID, @odlMesssageSource)
	
	end

	/*also we delete old PatioFIXClients_MsgIds*/
	delete from  [dbo].[PatioFIXClients_MsgIds] where [DayOfYear] != @DayOfYear and AppID = @AppID
	
	/*also we delete old IgnoredMessages*/
	delete from  [dbo].[IgnoredMessages] where [DayOfYear] != @DayOfYear and AppID = @AppID
