CREATE TABLE [dbo].[AdhocReports] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (50)  NOT NULL,
    [Group]       NVARCHAR (50)  NOT NULL,
    [Description] NVARCHAR (MAX) NULL,
    [SQL]         NVARCHAR (MAX) NOT NULL,
    [CreatedBy]   NVARCHAR (50)  NOT NULL,
    [CreatedDate] DATETIME       NOT NULL,
    [Hint]        NVARCHAR (250) NULL,
    [DivID]       INT            NULL,
    CONSTRAINT [PK_AdhocReports] PRIMARY KEY CLUSTERED ([Id] ASC)
);

