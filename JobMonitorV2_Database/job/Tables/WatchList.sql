CREATE TABLE [job].[WatchList] (
    [ID]                   INT           IDENTITY (1, 1) NOT NULL,
    [Name]                 VARCHAR (128) NOT NULL,
    [Threshold]            INT           NOT NULL,
    [AvgDuration]          INT           NULL,
    [AvgUsingNumberOfRuns] INT           NOT NULL,
    [ServerName]           VARCHAR (128) NOT NULL,
    CONSTRAINT [PK_WatchList] PRIMARY KEY CLUSTERED ([ID] ASC)
);

