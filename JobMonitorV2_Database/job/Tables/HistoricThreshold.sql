CREATE TABLE [job].[HistoricThreshold] (
    [ID]                INT             IDENTITY (1, 1) NOT NULL,
    [JobName]           VARCHAR (128)   NOT NULL,
    [AverageSec]        INT             NOT NULL,
    [AverageMin]        INT             NOT NULL,
    [MaximumMin]        INT             NOT NULL,
    [MinimumMin]        INT             NOT NULL,
    [StandardDeviation] DECIMAL (18, 7) NOT NULL,
    [DateOfEntry]       DATETIME        CONSTRAINT [DF_Table_1_DateofEntry] DEFAULT (getdate()) NOT NULL,
    [ServerName]        VARCHAR (128)   NOT NULL,
    CONSTRAINT [PK_HistoricThreshold] PRIMARY KEY CLUSTERED ([ID] ASC)
);

