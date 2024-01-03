CREATE TABLE [job].[FailureClassifications] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [Name]        VARCHAR (50)   NOT NULL,
    [Description] NVARCHAR (100) NULL,
    CONSTRAINT [PK_FailureClassifications] PRIMARY KEY CLUSTERED ([Id] ASC)
);

