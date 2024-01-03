CREATE TABLE [job].[ExcludeStepsList] (
    [PK_ID]          INT            IDENTITY (1, 1) NOT NULL,
    [StepName]       NVARCHAR (128) NOT NULL,
    [Description]    NVARCHAR (512) NULL,
    [Date_Created]   DATETIME       CONSTRAINT [DF_ExcludeStepsList_Date_Created] DEFAULT (getdate()) NOT NULL,
    [ModifiedByUser] VARCHAR (100)  NULL,
    [ModifiedByDate] DATETIME       CONSTRAINT [DF_ExcludeStepsList_ModifiedByDate] DEFAULT (getdate()) NULL,
    [CreatedByUser]  VARCHAR (100)  NULL,
    CONSTRAINT [PK_ExcludeStepsList] PRIMARY KEY CLUSTERED ([PK_ID] ASC)
);

