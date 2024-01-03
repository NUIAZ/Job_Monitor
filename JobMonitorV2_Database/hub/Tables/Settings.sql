CREATE TABLE [hub].[Settings] (
    [Id]                  INT            IDENTITY (1, 1) NOT NULL,
    [RefreshRate]         INT            CONSTRAINT [DF_Settings_RefreshRate] DEFAULT ((180)) NOT NULL,
    [MaxRecordsReturned]  INT            NOT NULL,
    [SharePointTraining]  NVARCHAR (100) NULL,
    [SharePointException] NVARCHAR (100) NULL,
    CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED ([Id] ASC)
);

