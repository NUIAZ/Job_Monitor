CREATE TABLE [dbo].[RunConfigurations] (
    [Id]           INT            IDENTITY (1, 1) NOT NULL,
    [Job_Name]     NVARCHAR (128) NOT NULL,
    [Step_Name]    VARCHAR (128)  NOT NULL,
    [Action]       INT            NOT NULL,
    [CheckPrimary] BIT            CONSTRAINT [DF_RunConfigurations_CheckPrimary] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_RunConfigurations] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_RunConfigurations_RunConfigurations] FOREIGN KEY ([Id]) REFERENCES [dbo].[RunConfigurations] ([Id])
);

