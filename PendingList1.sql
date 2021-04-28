USE [dbNRO]
GO

/****** Object:  View [dbo].[K2CustomWorklist]    Script Date: 20-04-2021 23:22:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER VIEW [dbo].[K2CustomWorklist]
AS
SELECT ROW_NUMBER() OVER(ORDER BY slot.ID) AS ID,
ProcInst.Folio,
ProcSet.DisplayName AS WorkflowName,
wl.[Destination] AS [DestUserFQN],
Actioner.ActionerName AS OpenUser,
wl.[StartDate],
wl.[EndDate],
WLHeader.[Data] AS [TaskURL],
Act.DisplayName as ActivityName,
Act.Descr AS ActivityDesc,
CAST(wl.[ProcInstID] AS VARCHAR(10)) + '_' + CAST(wl.[ActInstDestID] AS VARCHAR(10)) AS [SN],
ProcInst.Originator,
WLHeader.ProcInstID,
WLHeader.ActID,
WLHeader.EventID,
WLHeader.ActInstID,
WLHeader.ActInstDestID,
WLHeader.[AIStartDate],
Slot.ID AS SlotID,
slot.Status AS SlotStatus,
CASE ProcInst.[Status] WHEN 0 Then 'Error' WHEN 1 THEN 'Running' WHEN '2' THEN 'Active' WHEN 3 THEN 'Completed' WHEN 4 THEN 'Stopped' WHEN 5 THEN 'Deleted' END AS Status 

FROM [K2_Dev].[Server].[ProcInst] AS ProcInst WITH(NOLOCK) 
JOIN [K2_Dev].[Server].[WorklistHeader]  AS WLHeader 
WITH(NOLOCK)    On ProcInst.ID = WLHeader.ProcInstID
JOIN [K2_Dev].[Server].[Proc] AS Procs WITH(NOLOCK) 
ON ProcInst.ProcID = Procs.ID 
JOIN [K2_Dev].[Server].[Procset] AS ProcSet WITH(NOLOCK) 
ON Procs.ProcSetID = ProcSet.ID 
JOIN [K2_Dev].[ServerLog].[Worklist] AS wl WITH(NOLOCK) 
ON wl.ProcInstID = WLHeader.ProcInstID AND wl.ActInstDestID = WLHeader.ActInstDestID  --AND wl.DestType = 2 --2 more records.
JOIN [K2_Dev].[Server].[WorklistSlot] AS slot WITH(NOLOCK) 
ON wl.ProcInstID = slot.ProcInstID AND slot.HeaderID = WLHeader.ID -- AND wl.DestType = 2 
JOIN [K2_Dev].[Server].[Act] AS Act WITH(NOLOCK) 
On Act.ID = WLHeader.ActID LEFT OUTER JOIN [K2_Dev].[Server].[Actioner] AS Actioner
WITH(NOLOCK) ON Actioner.ID = slot.ActionerID AND slot.ActionerID <> 0 AND slot.[Status] = 1




GO


