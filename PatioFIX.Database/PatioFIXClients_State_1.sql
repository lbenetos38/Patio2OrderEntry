/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
	SET QUOTED_IDENTIFIER ON
	SET ARITHABORT ON
	SET NUMERIC_ROUNDABORT OFF
	SET CONCAT_NULL_YIELDS_NULL ON
	SET ANSI_NULLS ON
	SET ANSI_PADDING ON
	SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
	GO
	ALTER TABLE dbo.PatioFIXClients_State
		DROP CONSTRAINT DF_Table_1_ETS_LastMsgId
	GO
	ALTER TABLE dbo.PatioFIXClients_State
		DROP CONSTRAINT DF_PatioFIXClients_State_ETS_LastMsgSeqNum
	GO
	ALTER TABLE dbo.PatioFIXClients_State
		DROP CONSTRAINT DF_Table_1_ORA_LastMsgId
	GO
	ALTER TABLE dbo.PatioFIXClients_State
		DROP CONSTRAINT DF_PatioFIXClients_State_ORA_LastMsgSeqNum
	GO
	ALTER TABLE dbo.PatioFIXClients_State
		DROP CONSTRAINT DF_PatioFIXClients_State_CreateDT
	GO
	ALTER TABLE dbo.PatioFIXClients_State
		DROP CONSTRAINT DF_PatioFIXClients_State_LastUpdateDT
	GO
	CREATE TABLE dbo.Tmp_PatioFIXClients_State
		(
		RawID int NOT NULL IDENTITY (1, 1),
		DayOfYear smallint NOT NULL,
		AppID varchar(50) NOT NULL,
		MesssageSource tinyint NOT NULL,
		ATHEXSessionID varchar(50) NULL,
		ETS_LastAppMsgId int NOT NULL,
		ETS_LastMsgSeqNum int NOT NULL,
		ORA_LastAppMsgId int NOT NULL,
		ORA_LastMsgSeqNum int NOT NULL,
		CreateDT datetime2(3) NOT NULL,
		LastUpdateDT datetime2(3) NOT NULL
		)  ON [PRIMARY]
	GO
	ALTER TABLE dbo.Tmp_PatioFIXClients_State SET (LOCK_ESCALATION = TABLE)
	GO
	ALTER TABLE dbo.Tmp_PatioFIXClients_State ADD CONSTRAINT
		DF_Table_1_ETS_LastMsgId DEFAULT ((0)) FOR ETS_LastAppMsgId
	GO
	ALTER TABLE dbo.Tmp_PatioFIXClients_State ADD CONSTRAINT
		DF_PatioFIXClients_State_ETS_LastMsgSeqNum DEFAULT ((0)) FOR ETS_LastMsgSeqNum
	GO
	ALTER TABLE dbo.Tmp_PatioFIXClients_State ADD CONSTRAINT
		DF_Table_1_ORA_LastMsgId DEFAULT ((0)) FOR ORA_LastAppMsgId
	GO
	ALTER TABLE dbo.Tmp_PatioFIXClients_State ADD CONSTRAINT
		DF_PatioFIXClients_State_ORA_LastMsgSeqNum DEFAULT ((0)) FOR ORA_LastMsgSeqNum
	GO
	ALTER TABLE dbo.Tmp_PatioFIXClients_State ADD CONSTRAINT
		DF_PatioFIXClients_State_CreateDT DEFAULT (getdate()) FOR CreateDT
	GO
	ALTER TABLE dbo.Tmp_PatioFIXClients_State ADD CONSTRAINT
		DF_PatioFIXClients_State_LastUpdateDT DEFAULT (getdate()) FOR LastUpdateDT
	GO
	SET IDENTITY_INSERT dbo.Tmp_PatioFIXClients_State ON
	GO
	IF EXISTS(SELECT * FROM dbo.PatioFIXClients_State)
		 EXEC('INSERT INTO dbo.Tmp_PatioFIXClients_State (RawID, DayOfYear, AppID, MesssageSource, ATHEXSessionID, ETS_LastAppMsgId, ETS_LastMsgSeqNum, ORA_LastAppMsgId, ORA_LastMsgSeqNum, CreateDT, LastUpdateDT)
			SELECT RawID, DayOfYear, CONVERT(varchar(50), AppID), MesssageSource, ATHEXSessionID, ETS_LastAppMsgId, ETS_LastMsgSeqNum, ORA_LastAppMsgId, ORA_LastMsgSeqNum, CreateDT, LastUpdateDT FROM dbo.PatioFIXClients_State WITH (HOLDLOCK TABLOCKX)')
	GO
	SET IDENTITY_INSERT dbo.Tmp_PatioFIXClients_State OFF
	GO
	DROP TABLE dbo.PatioFIXClients_State
	GO
	EXECUTE sp_rename N'dbo.Tmp_PatioFIXClients_State', N'PatioFIXClients_State', 'OBJECT' 
	GO
	ALTER TABLE dbo.PatioFIXClients_State ADD CONSTRAINT
		PK_PatioFIXClients_State PRIMARY KEY CLUSTERED 
		(
		RawID
		) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

	GO
	ALTER TABLE dbo.PatioFIXClients_State ADD CONSTRAINT
		IX_PatioFIXClients_State UNIQUE NONCLUSTERED 
		(
		AppID,
		MesssageSource,
		DayOfYear
		) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

	GO
COMMIT
