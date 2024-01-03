CREATE TABLE [job].[Settings] (
    [ID]         INT           IDENTITY (1, 1) NOT NULL,
    [Name]       VARCHAR (255) NOT NULL,
    [Value]      VARCHAR (255) NOT NULL,
    [Notes]      VARCHAR (150) NULL,
    [ServerName] VARCHAR (128) NULL,
    CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED ([ID] ASC)
);

