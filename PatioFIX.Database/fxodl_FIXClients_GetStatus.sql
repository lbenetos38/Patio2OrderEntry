USE [ODL]
GO
/****** Object:  StoredProcedure [dbo].[fxodl_FIXClients_GetStatus]    Script Date: 23/9/2026 3:03:13 μμ ******/
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
ALTER PROCEDURE [dbo].[fxodl_FIXClients_GetStatus]
	@AppID varchar(250),
	@odlMesssageSource tinyint,		/*0 = Administrator, 1 = Broker*/
	@DayOfYear smallint
as
set nocount on



	/**/
	if not exists(select * from [dbo].[PatioFIXClients_State] where DayOfYear = @DayOfYear and AppID = @AppID and MesssageSource = @odlMesssageSource) begin
		insert into [dbo].[PatioFIXClients_State] (DayOfYear, AppID, MesssageSource) values (@DayOfYear, @AppID, @odlMesssageSource)
	end


	select
      [ETS_LastAppMsgId],
      [ETS_LastMsgSeqNum],
      [ORA_LastAppMsgId],
      [ORA_LastMsgSeqNum],
      [AppID],
      [DayOfYear],
      [ATHEXSessionID],
      [CreateDT]
	from [dbo].[PatioFIXClients_State] where [DayOfYear] = @DayOfYear and AppID = @AppID and MesssageSource = @odlMesssageSource