unit uDLLUtilsEx;

interface
uses
  Windows, SysUtils, Classes, Forms,  Dialogs,JvListView, ComCtrls;

const
          STATUS_REFRESHINGLISTVIEW =       'Refreshing';
          STATUS_LOADING            =       'Loading';
          STATUS_UNLOADING          =       'Unloading';
          STATUS_ADDING             =       'Adding';


function compareByHandle(aDLL1 : Pointer; aDLL2 : Pointer) : Integer;
function compareByFileName(aDLL1 : Pointer; aDLL2 : Pointer) : Integer;

// =============================================================================
// Responsible for Loading and Unloading a DLL File and providing basic events
Type    TDLLObject            =       class
        private
        // ---------------------------------------------------------------------
          // The data fields of the DLL class
          FFileName           : TFileName;
          FFilePath           : String;
          FHandle             : THandle;
        // ---------------------------------------------------------------------
          FOnBeforeLoadEvent  : TNotifyEvent;
          FOnAfterLoadEvent   : TNotifyEvent;
          FOnBeforeUnloadEvent: TNotifyEvent;
          FOnAfterUnloadEvent : TNotifyEvent;
          FOnErrorEvent       : TNotifyEvent;
        // ---------------------------------------------------------------------
        public
        // ---------------------------------------------------------------------
          procedure Load(); virtual;
          procedure Unload(); virtual;
          function IsLoaded() : boolean;
          function HasExportedFunction(aFunctionOrProcedureName : String) : boolean;
        // ---------------------------------------------------------------------
          // Properties to read these data values
          property FileName : TFileName   read FFileName;
          property Path     : string      read FFilePath;
          property Handle   : THandle     read FHandle;
        // ---------------------------------------------------------------------
          // Constructor
          constructor Create(const aFileName   : String;
                             const aFilePath   : String;
                             const aHandle     : THandle); overload;virtual;
          // Events
        // ---------------------------------------------------------------------
          PROPERTY OnBeforeLoadEvent : TNotifyEvent read FOnBeforeLoadEvent write FOnBeforeLoadEvent;
          PROPERTY OnAfterLoadEvent : TNotifyEvent read FOnAfterLoadEvent write FOnAfterLoadEvent;
          PROPERTY OnBeforeUnloadEvent : TNotifyEvent read FOnBeforeUnloadEvent write FOnBeforeUnloadEvent;
          PROPERTY OnAfterUnloadEvent : TNotifyEvent read FOnAfterUnloadEvent write FOnAfterUnloadEvent;
          PROPERTY OnErrorEvent : TNotifyEvent read FOnErrorEvent write FOnErrorEvent;
        end;
Type    PDLLObject            =      ^TDLLObject;
// =============================================================================

// =============================================================================
Type    TOnDllNotifyEvent   =       PROCEDURE(Sender : TObject; Index : Integer) of object;
Type    TOnDllProgressEvent =       PROCEDURE(Sender : TObject; Min, Max, Position : Integer;
                                              aMessage : String) of object;
// =============================================================================



Type    TOnUpdateListItemEvent  =     PROCEDURE(sender : TObject;
                                                var ListItem : TListItem;
                                                atIndex : integer) of object;

// =============================================================================
Type    TDLLManager         =       class(TComponent)
        protected
        FDLLList            :       TList;
        FAutoLoad           :       boolean;
        FAutoUnload         :       boolean;
        FIsChanged          :       boolean;
        FOnBeforeLoadDllEvent:      TOnDllNotifyEvent;
        FOnAfterLoadDllEvent:       TOnDllNotifyEvent;
        FOnBeforeUnloadDllEvent :   TOnDllNotifyEvent;
        FOnAfterUnloadDllEvent  :   TOnDllNotifyEvent;
        FOnDllProgressEvent :       TOnDllProgressEvent;
        FOnListChangeEvent  :       TNotifyEvent;
        FOnUpdateListItemEvent :    TOnUpdateListItemEvent;
        FUNCTION FGetCount() : integer;
        private
        public
        // ---------------------------------------------------------------------
        constructor Create(AOwner : TComponent); override;
        destructor Destroy(); override;
        // ---------------------------------------------------------------------
        PROCEDURE AddDll          (aFileName : TFileName); virtual;
        PROCEDURE AddDlls         (var aFileNameList : TStringList); virtual;
        PROCEDURE Load            (aIndex : Integer); virtual;
        PROCEDURE Unload          (aIndex : Integer); virtual;
        PROCEDURE LoadAll         (); virtual;
        PROCEDURE UnloadAll       (); virtual;
        PROCEDURE RemoveDll(aIndex : integer);
        PROCEDURE ClearDlls       (); virtual;
        PROCEDURE RefreshListView (Var aListView : TjvListView; ClearListViewFirst : Boolean); virtual;
        // ---------------------------------------------------------------------
        published
        // ---------------------------------------------------------------------
        PROPERTY DLLList        : TList   read FDLLList         write FDLLList;
        PROPERTY Count          : integer read FGetCount;
        PROPERTY AutoLoadDll    : boolean read FAutoLoad        write FAutoLoad
                                          default False;
        PROPERTY AutoUnloadDll  : boolean read FAutoUnload      write FAutoUnload
                                          default True;
        PROPERTY OnBeforeUnloadDllEvent : TOnDllNotifyEvent
                                          read FOnBeforeUnLoadDllEvent
                                          write FOnBeforeUnLoadDllEvent;

        PROPERTY OnAfterUnloadDllEvent  : TOnDllNotifyEvent
                                          read FOnAfterUnLoadDllEvent
                                          write FOnAfterUnLoadDllEvent;

        PROPERTY OnBeforeLoadDllEvent   : TOnDllNotifyEvent
                                          read FOnBeforeLoadDllEvent
                                          write FOnBeforeLoadDllEvent;

        PROPERTY OnAfterLoadDllEvent    : TOnDllNotifyEvent
                                          read FOnAfterLoadDllEvent
                                          write FOnAfterLoadDllEvent;

        PROPERTY OnDllProgressEvent : TOnDllProgressEvent read FOnDllProgressEvent write FOnDllProgressEvent;
        PROPERTY OnListChangeEvent : TNotifyEvent read FOnListChangeEvent write FOnListChangeEvent;
        PROPERTY OnUpdatingListItem : TOnUpdateListItemEvent read FOnUpdateListItemEvent write FOnUpdateListItemEvent;
        // ---------------------------------------------------------------------
        end;
// =============================================================================


implementation




// =============================================================================
// TDLLObject constructor
// =============================================================================
constructor TDLLObject.Create(const aFileName   : String;
                              const aFilePath   : String;
                              const aHandle     : THandle);
begin
  // Save the passed parameters
  Self.FFileName  := aFileName;
  Self.FFilePath  := aFilePath;
  Self.FHandle    := aHandle;
end;
// -----------------------------------------------------------------------------
procedure TDLLObject.Load();
Begin
if FileExists(FFilePath + FFileName) then
   Begin
   Try
     Begin
     if assigned(FOnBeforeLoadEvent) then OnBeforeLoadEvent(Self);
     FHandle := LoadLibrary(PChar(FFilePath + FFileName));
     if assigned(FOnAfterLoadEvent) then OnAfterLoadEvent(Self);
     End;
   except
     Begin
     if Assigned(Self.FOnErrorEvent) then OnErrorEvent(Self);
     End;
   End; // end except

   End;
End;
// -----------------------------------------------------------------------------
procedure TDLLObject.Unload();
Begin
if FHandle > 0 then
   Begin
   Try
      Begin
       if assigned(FOnBeforeUnLoadEvent) then OnBeforeUnloadEvent(Self);
      Try
         FreeLibrary(FHandle);
         Except
         if Assigned(Self.FOnErrorEvent) then OnErrorEvent(Self);
         End; // end except
      End;
   Finally
      Begin
       FHandle := 0;
       if assigned(FOnAfterUnLoadEvent) then OnAfterUnloadEvent(Self);
      End;
   End;
   End;
End;
// -----------------------------------------------------------------------------
function TDLLObject.IsLoaded() : boolean;
Begin
if FHandle > 0 then Result := True else Result := False;
End;
// -----------------------------------------------------------------------------
FUNCTION TDLLObject.HasExportedFunction(aFunctionOrProcedureName : String) : boolean;
Begin
if IsLoaded then
   Begin
   if GetProcAddress(FHandle,PChar(aFunctionOrProcedureName)) <> nil then
      Begin
        Result := True
      End
   ELSE
     Begin
       Result := False;
     End;
   End
else
   begin
     result := false;
   end;
End;

// =============================================================================





// =============================================================================
function compareByHandle(aDLL1 : Pointer; aDLL2 : Pointer) : Integer;
var
  DLL1, DLL2 : TDLLObject;
begin
  // We start by viewing the object pointers as TDLLObject objects
  DLL1 := TDLLObject(aDLL1);
  DLL2 := TDLLObject(aDLL2);

  if DLL1.Handle > DLL2.Handle then
     Begin
       Result := 1;
     End
  ELSE if DLL1.Handle = DLL2.Handle then
       Begin
         Result := 0;
       End
  ELSE
      Begin
        Result := -1;
      End;
end;
// -----------------------------------------------------------------------------
function compareByFileName(aDLL1 : Pointer; aDLL2 : Pointer) : Integer;
var
  DLL1, DLL2 : TDLLObject;
begin
  // We start by viewing the object pointers as TCustomer objects
  DLL1 := TDLLObject(aDLL1);
  DLL2 := TDLLObject(aDLL2);

  if DLL1.FileName > DLL2.FileName then
     Begin
       Result := 1;
     End
  ELSE if DLL1.FileName = DLL2.FileName then
       Begin
         Result := 0;
       End
  ELSE
      Begin
        Result := -1;
      End;
end;
// =============================================================================




// =============================================================================
// TDLLManager constructor
// =============================================================================
constructor TDLLManager.Create(AOwner : TComponent);
Begin
Inherited Create(AOWNER);
FDLLList := TList.Create;
FIsChanged := True;

End;
// -----------------------------------------------------------------------------
destructor TDLLManager.Destroy();
Begin
if self.FAutoUnload then UnloadAll;
FDLLList.Clear;
FreeAndNil(FDLLList);
Inherited Destroy();
End;
// -----------------------------------------------------------------------------
FUNCTION TDLLManager.FGetCount() : integer;
begin
result := self.FDLLList.Count;
end;
// -----------------------------------------------------------------------------
PROCEDURE TDLLManager.AddDll(aFileName : TFileName);
Begin
FDLLList.Add(TDLLObject.Create(ExtractFileName(aFileName),ExtractFilePath(aFileName),0));

FIsChanged := True;

if Assigned(FOnListChangeEvent) then OnListChangeEvent(Self);

if AutoLoadDll then
   begin
   TDLLObject(FDLLList[FDLLList.Count - 1]).Load;
   end;
End;
// -----------------------------------------------------------------------------
PROCEDURE TDLLManager.AddDlls(var aFileNameList : TStringList);
Var
  i           :     integer;
Begin
if Assigned(aFileNameList) then
   Begin
    for i := 0 to aFileNameList.Count - 1 do
      Begin
      AddDll(aFileNameList.Strings[i]);
      if Assigned(FOnDllProgressEvent) then OnDllProgressEvent(Self, 0, FDLLList.Count - 1, i, STATUS_ADDING + aFileNameList.Strings[i]);
      End;
   End;
End;
// -----------------------------------------------------------------------------
PROCEDURE TDLLManager.RefreshListView(Var aListView : TjvListView; ClearListViewFirst : Boolean);
Var
    i         :     integer;
    ListItem  :     TListItem;
//    DLLObject :     TDLLObject;
Begin
if (Assigned(aListView) = true) AND
   (aListView <> nil) and (FDLLList <> nil) then
      Begin
        aListView.Items.BeginUpdate;
        if ClearlistViewFirst then
            Begin
            // if we clear the list view, we have to update all items
            aListView.Items.Clear;
            for i := 0 to FDLLList.Count - 1 do
                Begin
//                DLLObject := FDLLList.Items[i];
                ListItem := aListView.Items.Add;

                ListItem.GroupID := 0; // assign default group ID

                // DLL Filename to Caption
                ListItem.Caption := TDLLObject(FDLLList.Items[i]).FileName;
                // Path as first subitem
                ListItem.SubItems.Add(TDLLObject(FDLLList.Items[i]).Path);
                // DLL Handle as 2nd sub item
                ListItem.SubItems.Add(IntToStr(TDLLObject(FDLLList.Items[i]).Handle));
                // ListItems Data gets pointer to DLLObject
                ListItem.Data := TDLLObject(FDLLList.Items[i]);


                if assigned(OnUpdatingListItem) then self.FOnUpdateListItemEvent(Self,ListItem,i);

                if Assigned(FOnDllProgressEvent) then OnDllProgressEvent(Self, 0, FDLLList.Count - 1, i, STATUS_REFRESHINGLISTVIEW + ListItem.Caption);
                End;
             End
            ELSE
             Begin
             // TODO: This is not done yet, recalling this method but with ClearListViewFirst set so something happens
             // and it doesn't break our code, for now, effect is clearlistview is always true
            RefreshListView(aListView,True);
             End;
        aListView.Items.EndUpdate;
        FIsChanged := False;
      End;
//DLLObject := nil;
End;
// -----------------------------------------------------------------------------

PROCEDURE TDLLManager.Load(aIndex : Integer);
Begin
if (aIndex >= 0) and (aIndex < FDLLList.Count) and (FDLLList.Count > 0) then
   Begin
   if Assigned(FOnBeforeLoadDllEvent) then OnBeforeLoadDllEvent(Self, aIndex);

   if NOT TDLLObject(FDLLList[aIndex]).IsLoaded then
      Begin
        TDLLObject(FDLLList[aIndex]).Load;
        FIsChanged := True;
      End;


   if (assigned(FOnAfterLoadDllEvent)) AND (TDLLObject(FDLLList[aIndex]).IsLoaded) then
      Begin
      OnAfterLoadDllEvent(Self, aIndex);
      End;
   End;

End;
// -----------------------------------------------------------------------------
PROCEDURE TDLLManager.Unload(aIndex : Integer);
Begin

if (aIndex >= 0) and (aIndex < FDLLList.Count) and (FDLLList.Count > 0) then
   Begin
   if Assigned(FOnBeforeUnloadDllEvent) then OnBeforeUnloadDllEvent(Self,aIndex);

   TDLLObject(FDLLList[aIndex]).Unload;
   FIsChanged := True;

   if Assigned(Self.FOnAfterUnloadDllEvent) then OnAfterUnloadDllEvent(Self,aIndex);
   End;
End;
// -----------------------------------------------------------------------------
PROCEDURE TDLLManager.LoadAll();
Var
  i           : integer;
Begin
for i := 0 to FDLLList.Count - 1 do
  Begin
  Load(i);
  if Assigned(FOnDllProgressEvent) then OnDllProgressEvent(Self, 0, FDLLList.Count - 1, i, STATUS_LOADING)
  End;
End;
// -----------------------------------------------------------------------------
PROCEDURE TDLLManager.UnloadAll();
Var
  i           : integer;
Begin
for i := 0 to FDLLList.Count - 1 do
  Begin
   Unload(i);
   if Assigned(FOnDllProgressEvent) then OnDllProgressEvent(Self, 0, FDLLList.Count - 1, i,STATUS_UNLOADING);
  End;
End;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
PROCEDURE TDLLManager.ClearDlls();
Begin
FDLLList.Clear;
FreeAndNil(FDLLList);
FDLLlist := TList.Create;
End;



PROCEDURE TDLLManager.RemoveDll(aIndex: Integer);
begin
if (aIndex >= 0) and (aIndex < FDLLList.Count) and (FDLLList.Count > 0) then
   Begin
   FDLLList.Delete(aIndex);
   FIsChanged := True;
   End;
end;
// =============================================================================

end.

