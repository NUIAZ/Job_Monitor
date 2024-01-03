CREATE TABLE [stg].[V3_FailedJobList] (
    [Id]                INT              IDENTITY (1, 1) NOT NULL,
    [Job_Id]            UNIQUEIDENTIFIER NOT NULL,
    [Name]              NVARCHAR (128)   NOT NULL,
    [Step_Id]           INT              NOT NULL,
    [Step_Name]         VARCHAR (128)    NOT NULL,
    [Date]              DATE             NOT NULL,
    [Time]              DATETIME         NOT NULL,
    [Run_Duration]      INT              NOT NULL,
    [Retries_Attempted] INT              NOT NULL,
    [Message]           VARCHAR (MAX)    NOT NULL,
    [ServerName]        NVARCHAR (128)   NOT NULL,
    CONSTRAINT [PK_V3_FailedJobList_stg] PRIMARY KEY CLUSTERED ([Id] ASC)
);

