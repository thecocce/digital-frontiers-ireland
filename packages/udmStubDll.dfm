object dmStubDll: TdmStubDll
  OldCreateOrder = False
  Height = 150
  Width = 215
  object StubDllEventHandler: TStubDllEventHandler
    OnDllDeInit = StubDllEventHandlerDllDeInit
    OnMessageRecieved = StubDllEventHandlerMessageRecieved
    OnMessageDataRecieved = StubDllEventHandlerMessageDataRecieved
    OnGetExportedFunctions = StubDllEventHandlerGetExportedFunctions
    OnAskForGroupDetails = StubDllEventHandlerAskForGroupDetails
    OnAskForListItemCaption = StubDllEventHandlerAskForListItemCaption
    Left = 56
    Top = 24
  end
end
