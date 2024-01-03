CREATE TABLE [job].[OnDemand] (
    [PK_ID]          INT              IDENTITY (1, 1) NOT NULL,
    [ServerName]     VARCHAR (50)     NOT NULL,
    [ServerConn]     VARCHAR (125)    NOT NULL,
    [ModifiedByDate] DATETIME         CONSTRAINT [DF_job.OnDemand_ModifiedByDate] DEFAULT (getdate()) NULL,
    [ModifiedByUser] VARCHAR (100)    NOT NULL,
    [Job_id]         UNIQUEIDENTIFIER NOT NULL,
    [JobName]        NVARCHAR (128)   NOT NULL,
    [StepName]       VARCHAR (128)    NOT NULL,
    [StepID]         INT              NOT NULL,
    [Result]         VARCHAR (30)     NULL,
    CONSTRAINT [PK_job.OnDemand] PRIMARY KEY CLUSTERED ([PK_ID] ASC)
);

