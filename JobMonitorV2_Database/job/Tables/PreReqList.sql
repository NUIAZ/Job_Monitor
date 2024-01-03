CREATE TABLE [job].[PreReqList] (
    [PK_ID]          INT            IDENTITY (1, 1) NOT NULL,
    [JobName]        NVARCHAR (128) NOT NULL,
    [Description]    NVARCHAR (512) NULL,
    [Date_Created]   DATETIME       CONSTRAINT [DF_PreReqList_Date_Created] DEFAULT (getdate()) NOT NULL,
    [Date_modified]  DATETIME       NULL,
    [ModifiedByUser] VARCHAR (100)  NULL,
    [ModifiedByDate] DATETIME       CONSTRAINT [DF_PreReqList_ModifiedByDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_PreReqList] PRIMARY KEY CLUSTERED ([PK_ID] ASC)
);

