unit uPluginUtilsEx;

interface
uses uDLLUtilsEx, uStubCommon, Windows, Dialogs, SysUtils, Classes, ComCtrls;
// =============================================================================
// Responsible for implementing basic plugin functionality on top of a DLL Object




Type    TPluginObject         =       class(TDLLObject)
        private
        FInitData             :       TStub_InitObject;
        FGroupInfo            :       TGroupInfoRec;
        FListItemCaption      :       String;
        RFUNC_Initialize      :       TFUNC_Initialize;
        RFUNC_Deinitialize    :       TFUNC_Deinitalize;
        RFUNC_SendMessage     :       TFUNC_Message;
        RFUNC_SendMessageWithData :   TFUNC_MessageWithData;
        RFUNC_GetExportedFunctionNames :       TGetExportedFunctionNames;
        RFUNC_GetGroupDetails :       TFUNC_GetGroupDetails;
        RFUNC_GetListItemCaption :    TFUNC_GetListItemCaption;
        public
        // ---------------------------------------------------------------------
          procedure Load(); override;
          procedure Unload(); override;
        // ---------------------------------------------------------------------
          // Properties to read these data values
        // ---------------------------------------------------------------------
          // Events
        // ---------------------------------------------------------------------
        PROPERTY OwnerInitData : TStub_InitObject read FInitData;
        PROPERTY GroupInfo : TGroupInfoRec read FGroupInfo;
        PROPERTY ListItemCaption : String read FListItemCaption;
        PROPERTY Initialize : TFUNC_Initialize read RFUNC_Initialize;
        PROPERTY Deinitalize : TFUNC_Deinitalize read RFUNC_Deinitialize;
        PROPERTY SendMessage : TFUNC_Message read RFUNC_SendMessage;
        PROPERTY SendMessageWithData : TFUNC_MessageWithData read RFUNC_SendMessageWithData;
        PROPERTY GetExportedFunctionNames : TGetExportedFunctionNames read RFUNC_GetExportedFunctionNames;
        end;

// =============================================================================
Type    TOnUpdateListItemEvent  =     PROCEDURE(sender : TObject;
                                                Var ListItem : TListItem;
                                                Var DLLObject: TPluginObject) of object;

Type    TPluginManager      =       class(TDLLManager)
        Private
        FInitData           :       TStub_InitObject;
        FOnUpdateListItemEvent :    TOnUpdateListItemEvent;
        Public
        FUNCTION GetInfo(aIndex : integer) : TPluginObject; reintroduce; virtual;
        PROCEDURE AddDll(aFileName : TFileName); override;
        PROCEDURE AddDlls(var aFileNameList : TStringList); override;
        PROCEDURE RefreshListView(Var aListView : TListView; ClearListViewFirst : Boolean); override;
        Protected
        Published
        PROPERTY InitData : TStub_InitObject read FInitData write FInitData;
        PROPERTY OnUpdatingListItem : TOnUpdateListItemEvent read FOnUpdateListItemEvent write FOnUpdateListItemEvent;
end;


implementation

procedure TPluginObject.Load();
Var
  i         : integer;
  TempHook  : TNotifyEvent;
  FuncList  : TStringList;
Begin
// Temporarly disable event here, we want to delay its loading
TempHook := Self.OnAfterLoadEvent;
Self.OnAfterLoadEvent := nil;
// Call inherited load to actually load DLL
Inherited Load;
// put our event back in place
Self.OnAfterLoadEvent := TempHook;

// if is loaded
if IsLoaded then
   Begin
   // Check plugin has required exported functions
   if (HasExportedFunction(FUNC_PREFIX_STUB + FUNC_Init) = true) AND
      (HasExportedFunction(FUNC_PREFIX_STUB + FUNC_DeInit) = true) AND
      (HasExportedFunction(FUNC_PREFIX_STUB + FUNC_Message) = true) AND
      (HasExportedFunction(FUNC_PREFIX_STUB + FUNC_MessageData) = true) AND
      (HasExportedFunction(FUNC_PREFIX_STUB + FUNC_GetExportedFunctionNames) = true) then
        Begin
        // it does, safe to attach initialize
        RFUNC_Initialize := GetProcAddress(Handle, FUNC_PREFIX_STUB + FUNC_Init);

         // if init is assigned
         if @RFUNC_Initialize <> nil then
            Begin
              // Call it
              if Initialize(fInitData) = False then
                 Begin
                 // INIT Fail
                 // DONE: Rewrite for an event to get triggered
                 // returns false if there was an error, if so, show message
                 if Assigned(OnErrorEvent) then OnErrorEvent(self);
                 End
              else
                 Begin
                   // Init sucess
                   // attach other functions
                   @RFUNC_SendMessage         := GetProcAddress(Handle, FUNC_PREFIX_STUB + FUNC_Message);
                   @RFUNC_SendMessageWithData := GetProcAddress(Handle, FUNC_PREFIX_STUB + FUNC_MessageData);
                   @RFUNC_Deinitialize        := GetProcAddress(Handle, FUNC_PREFIX_STUB + FUNC_deinit);
                   @RFUNC_GetExportedFunctionNames := GetProcAddress(Handle, FUNC_PREFIX_STUB + FUNC_GetExportedFunctionNames);

                   // DONE: Rewrite to test exported functions dynacily
                   // This routine will check the DLL against the names of functions provided by the plugin
                   // to make sure they are exported.

                   FuncList := TStringList.Create;
                   if (@RFUNC_GetExportedFunctionNames <> nil) then
                      Begin
                      RFUNC_GetExportedFunctionNames(Self,FuncList);
                      for i := 0 to FuncList.Count - 1 do
                        Begin
                        if HasExportedFunction(FuncList.Strings[i]) = False then
                           Begin
                           // DONE: Trigger an event / Unload
                             ShowMessage(ERROR_MISSINGEXPORTEDFUNC + FuncList.Strings[i]);
                             if Assigned(OnErrorEvent) then OnErrorEvent(self);
                             Self.Unload;
                           End;
                        End;
                      End;
                   FuncList.Free;

                 // its assumed that all functions required below are correctly exported

                 // Get Group Info for ListView
                 @RFUNC_GetGroupDetails := GetProcAddresS(Handle, FUNC_PREFIX_STUB + FUNC_AskForGroupDetails);
                 if @RFUNC_GetGroupDetails <> nil then
                    begin
                    FGroupInfo := RFUNC_getGroupDetails(Self);
                    end;

                 @RFUNC_GetListItemCaption := GetProcAddress(Handle, FUNC_PREFIX_STUB + FUNC_AskForListItemCaption);
                 if @RFUNC_GetListItemCaption <> nil then
                    begin
                    self.FListItemCaption := RFUNC_GetListItemCaption(Self);
                    end
                 else
                    begin
                      Self.FListItemCaption := 'Unknown or Invalid Plugin';
                    end;



                 End;
            End;
        End;
   End;
TempHook := nil;
End;



procedure TPluginObject.Unload();
Begin
if IsLoaded then
   Begin
     // Call deinit if possible
   if @RFUNC_deinitialize <> nil then
      Begin
      RFUNC_Deinitialize;
      End;
   End;

Inherited Unload;

// make sure functions are deattached
@RFUNC_Initialize          := nil;
@RFUNC_DeInitialize        := nil;
@RFUNC_SendMessage         := nil;
@RFUNC_SendMessageWithData := nil;
@RFUNC_GetExportedFunctionNames := nil;
@RFUNC_GetGroupDetails := nil;
@RFUNC_GetListItemCaption := nil;
End;


FUNCTION TPluginManager.GetInfo(aIndex : integer) : TPluginObject;
Begin
// NOTE: This method hides virtual method in ancester TDLLManager
// This is intentional
Result := nil;
if (aIndex >= 0) and (aIndex < FDLLList.Count) and (FDLLList.Count > 0) then
   Begin
   Result := Self.FDLLList.Items[aIndex];
   End;
End;

PROCEDURE TPluginManager.AddDll(aFileName : TFileName);
Var
  DLLObject : TPluginObject;
  i         : integer;
Begin
DLLObject := TPluginObject.Create(ExtractFileName(aFileName),ExtractFilePath(aFileName),0);

if FDLLList.Count > 0 then
   Begin
   // See if this object exists already
   for i := 0 to FDLLList.Count - 1 do
     Begin
     if CompareByFilename(DLLObject,FDLLList.Items[i]) = 0 then
        Begin
        // Filename already exists
        Exit;
        End
     End;
   End;

DLLObject.FInitData := SELF.FInitData;
FDLLList.Add(DLLObject);
if Assigned(FOnListChangeEvent) then OnListChangeEvent(Self);
if AutoLoadDll then DLLObject.Load;
//DLLObject := nil;
End;

PROCEDURE TPluginManager.AddDlls(var aFileNameList : TStringList);
Var
  i           :     integer;
Begin
if Assigned(aFileNameList) then
   Begin
    for i := 0 to aFileNameList.Count - 1 do
      Begin
      AddDll(aFileNameList.Strings[i]);
      if Assigned(FOnDllProgressEvent) then OnDllProgressEvent(Self, 0, FDLLList.Count - 1, i, 'Adding DLLs...');
      End;
   End;
End;



PROCEDURE TPluginManager.RefreshListView(Var aListView : TListView; ClearListViewFirst : Boolean);
// TODO: Something up with this function causing probs when isloaded is false. consider tidying up the
// code and make it more clear whats going on
Var
    i         :     integer;
    ListItem  :     TListItem;
    DLLObject :     TPluginObject;
    GroupItem :     TListGroup;
    FUNCTION GroupHeaderExists(aGroupHeader : String; Var inListView : TListView) : integer;
    Var
      i : integer;
    Begin
    Result := -1;
    // Case In-sensitive search og a grouplist for a group header
     for i := 0 to inListView.Groups.Count - 1 do
        Begin
        if LowerCase(inListView.Groups.Items[i].Header) = LowerCase(aGroupHeader) then
           Begin
             Result := i;
             Break;
           End
        End;
    End;
Begin
// DONE: Performance: Make it possible to update a single item in the listview, or items that have
// changed as opposed to update the entire listview with a full refresh
// EDIT: ListItem.Data now gets TPluginObject, so this can be achieved through Item.Data in one
// of the listviews event handlers
if (Assigned(aListView) = true) AND
   (aListView <> nil) then
      Begin
        aListView.Items.BeginUpdate;
        if ClearlistViewFirst then
            Begin
            // if we clear the list view, we have to update all items
            aListView.Items.Clear;
            for i := 0 to FDLLList.Count - 1 do
                Begin
                DLLObject := FDLLList.Items[i];
                // assign group based on DataStore
                if GroupHeaderExists(DLLObject.GroupInfo.Header.Text, aListView) = -1 then
                   Begin
                   // Create a new group
                   GroupItem := aListView.Groups.Add;

                   GroupItem.Header := DLLObject.GroupInfo.Header.Text;
                   GroupItem.HeaderAlign := DLLObject.GroupInfo.Header.Align;

                   GroupItem.Footer := DLLObject.GroupInfo.Footer.Text;
                   GroupItem.FooterAlign := DLLObject.GroupInfo.Footer.Align;

                   GroupItem.Subtitle := DLLObject.GroupInfo.Subtitle;
                    // TODO: Were certain groupitem properties removed in Delphi XE2?
//                   GroupItem.SubsetTitle := DLLObject.GroupInfo.SubsetTitle;

//                   GroupItem.TopDescription := DLLObject.GroupInfo.Description.Top;
//                   GroupItem.BottomDescription := DLLObject.GroupInfo.Description.Bottom;

                   GroupItem.TitleImage := DLLObject.GroupInfo.TitleImage;
//                   GroupItem.ExtendedImage := DLLObject.GroupInfo.ExtendedImage;

                   GroupItem.State := [lgsNormal,lgsCollapsible];
                   End;
                // TODO: BUG: Solve where IsLoaded is False causes an exception during the below block of code OR
                // fails to update listviewcorrectly
                if DLLObject.IsLoaded then
                   Begin
                   // assign ListItem
                   ListItem := aListView.Items.Add;
                   if assigned(DLLObject) then
                      Begin
                      // Assign this listitem to group
                      ListItem.GroupID := GroupHeaderExists(DLLObject.GroupInfo.Header.Text, aListView);

                      // ListItem.Caption is reserered for assignment in FOnUpdateListItemEvent event.
                      ListItem.SubItems.add(DLLObject.FileName);
                      ListItem.SubItems.Add(DLLObject.Path);
                      ListItem.SubItems.Add(IntToStr(DLLObject.Handle));
                      ListItem.Data := DLLObject;

                      // DONE: Replace this event with some sort of status event instead
                      if Assigned(FOnDllProgressEvent) then OnDllProgressEvent(Self, 0, FDLLList.Count - 1, i, STATUS_REFRESHINGLISTVIEW);

                       // If its not assigned after the event is called, then it gets SubItems[0]
                      ListItem.Caption := DLLObject.ListItemCaption;

                      if Assigned(FOnUpdateListItemEvent) then OnUpdatingListItem(Self,ListItem,DLLObject);
                      End;
                   End
                else
                   begin
                   // isn't loaded
                   ListItem.Caption := 'Unknown';

//                   if Assigned(FOnDllProgressEvent) then OnDllProgressEvent(Self, 0, FDLLList.Count - 1, i, STATUS_REFRESHINGLISTVIEW);
                   end;
                End;
             End
            ELSE
             Begin
             // TODO: This is not done yet, recalling this method but with ClearListViewFirst set so something happens
             // and it doesn't break out code, for now
            RefreshListView(aListView,True);
             End;
        aListView.Items.EndUpdate;
      End;
DLLObject := nil;
End;
// -----------------------------------------------------------------------------


end.