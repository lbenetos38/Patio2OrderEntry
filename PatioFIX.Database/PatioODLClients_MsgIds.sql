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
CREATE TABLE dbo.Tmp_PatioODLClients_MsgIds
	(
	ATHEXServer tinyint NOT NULL,
	MsgId int NOT NULL,
	DayOfYear smallint NOT NULL,
	AppID varchar(250) NOT NULL,
	MesssageSource tinyint NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_PatioODLClients_MsgIds SET (LOCK_ESCALATION = TABLE)
GO
GRANT DELETE ON dbo.Tmp_PatioODLClients_MsgIds TO PatioODLClientIT5  AS dbo
GO
GRANT INSERT ON dbo.Tmp_PatioODLClients_MsgIds TO PatioODLClientIT5  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_PatioODLClients_MsgIds TO PatioODLClientIT5  AS dbo
GO
GRANT SELECT ON dbo.Tmp_PatioODLClients_MsgIds TO PatioODLClientIT5  AS dbo
GO
GRANT UPDATE ON dbo.Tmp_PatioODLClients_MsgIds TO PatioODLClientIT5  AS dbo
GO
IF EXISTS(SELECT * FROM dbo.PatioODLClients_MsgIds)
	 EXEC('INSERT INTO dbo.Tmp_PatioODLClients_MsgIds (ATHEXServer, MsgId, DayOfYear, AppID, MesssageSource)
		SELECT ATHEXServer, MsgId, DayOfYear, CONVERT(varchar(250), AppID), MesssageSource FROM dbo.PatioODLClients_MsgIds WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.PatioODLClients_MsgIds
GO
EXECUTE sp_rename N'dbo.Tmp_PatioODLClients_MsgIds', N'PatioODLClients_MsgIds', 'OBJECT' 
GO
ALTER TABLE dbo.PatioODLClients_MsgIds ADD CONSTRAINT
	PK_PatioODLClients_MsgIds PRIMARY KEY CLUSTERED 
	(
	ATHEXServer,
	MsgId,
	DayOfYear
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
