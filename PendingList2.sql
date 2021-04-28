USE [dbNRO]
GO

/****** Object:  View [dbo].[K2ActiveActionWorklist]    Script Date: 20-04-2021 23:22:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








ALTER VIEW [dbo].[K2ActiveActionWorklist]
AS
SELECT DISTINCT
       KSP.Folio,
       ProcSet.DisplayName AS WorkflowName,
       KSP.StartDate StartDate,
       KSW.[Data] eURL,
       CONVERT(varchar(10),KSW.ProcInstID) + '_' + CONVERT(varchar(10),KSW.ActInstDestID) SerialNo,
       [AS].ActionerName ActionerName,
       KSP.id ProcInstId,
       AIR.ActInstDestId,
       0 id
FROM   [K2_Dev].[Server].[ProcInst] KSP WITH(NOLOCK) 
INNER JOIN [K2_Dev].[Server].[Proc] AS Procs WITH(NOLOCK) 
	   ON KSP.ProcID = Procs.ID 
INNER JOIN [K2_Dev].[Server].[Procset] AS ProcSet WITH(NOLOCK) 
       ON Procs.ProcSetID = ProcSet.ID 
INNER JOIN [K2_Dev].[Server].[WorklistHeader] KSW WITH(NOLOCK) 
	   ON KSP.ID = KSW.procinstid
INNER JOIN [K2_Dev].[Server].[Act] KSA WITH(NOLOCK) 
	   ON KSW.ActID = KSA.ID
INNER JOIN [K2_Dev].[Server].[ActionActInstRights] AS AIR WITH (NOLOCK) 
	   ON KSW.ProcInstID = AIR.ProcInstID AND KSW.ActInstDestID = AIR.ActInstDestID
INNER JOIN [K2_Dev].[Server].[Actioner] AS [AS] WITH (NOLOCK) 
	   ON AIR.ActionerID = [AS].ID
INNER JOIN [K2_Dev].[ServerLog].ActInstDest AS AID WITH (NOLOCK) 
	   ON KSW.ActInstDestID = AID.ID
WHERE AID.Status = 0
      AND AIR.[Execute] = 1





GO


