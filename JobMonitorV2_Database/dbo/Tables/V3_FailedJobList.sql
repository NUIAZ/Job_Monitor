CREATE TABLE [dbo].[V3_FailedJobList] (
    [Id]                      INT              IDENTITY (1, 1) NOT NULL,
    [Job_Id]                  UNIQUEIDENTIFIER NOT NULL,
    [Name]                    NVARCHAR (128)   NOT NULL,
    [Step_Id]                 INT              NOT NULL,
    [Step_Name]               VARCHAR (128)    NOT NULL,
    [Date]                    DATE             NOT NULL,
    [Time]                    DATETIME         NOT NULL,
    [Run_Duration]            INT              NOT NULL,
    [Retries_Attempted]       INT              NOT NULL,
    [Message]                 VARCHAR (MAX)    NOT NULL,
    [ServerName]              NVARCHAR (128)   NOT NULL,
    [FailureClassificationId] INT              CONSTRAINT [DF_V3_FailedJobList_FailureClassificationId] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_V3_FailedJobList] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_V3_FailedJobList_FailureClassifications] FOREIGN KEY ([FailureClassificationId]) REFERENCES [job].[FailureClassifications] ([Id])
);

