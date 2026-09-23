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
ALTER TABLE dbo.IgnoredMessages
	DROP CONSTRAINT DF_IgnoredMessages_WorkingDate
GO
CREATE TABLE dbo.Tmp_IgnoredMessages
	(
	IgnoredMessageID int NOT NULL IDENTITY (1, 1),
	msgid int NOT NULL,
	DayOfYear smallint NOT NULL,
	AppID varchar(250) NOT NULL,
	WorkingDate datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_IgnoredMessages SET (LOCK_ESCALATION = TABLE)
GO
GRANT DELETE ON dbo.Tmp_IgnoredMessages TO PatioODLClientIT5  AS dbo
GO
GRANT INSERT ON dbo.Tmp_IgnoredMessages TO PatioODLClientIT5  AS dbo
GO
GRANT SELECT ON dbo.Tmp_IgnoredMessages TO PatioODLClientIT5  AS dbo
GO
GRANT UPDATE ON dbo.Tmp_IgnoredMessages TO PatioODLClientIT5  AS dbo
GO
ALTER TABLE dbo.Tmp_IgnoredMessages ADD CONSTRAINT
	DF_IgnoredMessages_WorkingDate DEFAULT (getdate()) FOR WorkingDate
GO
SET IDENTITY_INSERT dbo.Tmp_IgnoredMessages ON
GO
IF EXISTS(SELECT * FROM dbo.IgnoredMessages)
	 EXEC('INSERT INTO dbo.Tmp_IgnoredMessages (IgnoredMessageID, msgid, DayOfYear, AppID, WorkingDate)
		SELECT IgnoredMessageID, msgid, DayOfYear, CONVERT(varchar(250), AppID), WorkingDate FROM dbo.IgnoredMessages WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_IgnoredMessages OFF
GO
DROP TABLE dbo.IgnoredMessages
GO
EXECUTE sp_rename N'dbo.Tmp_IgnoredMessages', N'IgnoredMessages', 'OBJECT' 
GO
ALTER TABLE dbo.IgnoredMessages ADD CONSTRAINT
	PK_IgnoredMessages PRIMARY KEY CLUSTERED 
	(
	IgnoredMessageID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE UNIQUE NONCLUSTERED INDEX IDXODL_IgnoredMessages ON dbo.IgnoredMessages
	(
	msgid,
	DayOfYear,
	AppID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
COMMIT
