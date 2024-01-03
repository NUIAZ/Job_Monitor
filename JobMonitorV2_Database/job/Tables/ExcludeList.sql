CREATE TABLE [job].[ExcludeList] (
    [PK_ID]          INT            IDENTITY (1, 1) NOT NULL,
    [JobName]        NVARCHAR (128) NOT NULL,
    [Description]    NVARCHAR (512) NULL,
    [Date_Created]   DATETIME       CONSTRAINT [DF_ExcludeList_Date_Created] DEFAULT (getdate()) NOT NULL,
    [ModifiedByUser] VARCHAR (100)  NULL,
    [ModifiedByDate] DATETIME       CONSTRAINT [DF_ExcludeList_ModifiedByDate] DEFAULT (getdate()) NULL,
    [CreatedByUser]  VARCHAR (100)  NULL,
    CONSTRAINT [PK_ExcludeList] PRIMARY KEY CLUSTERED ([PK_ID] ASC)
);

