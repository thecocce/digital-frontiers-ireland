unit ufraPluginListView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ufraListView, Vcl.ComCtrls,
  Vcl.ToolWin, JvExComCtrls, JvToolBar, Vcl.ActnList, Vcl.Menus, uDLLUtilsEx,
  uPluginUtilsEx;

type
  TfraPluginListView = class(TFrame)
    fraListView: TfraListView;
    OpenDialog: TOpenDialog;
    PluginManager: TPluginManager;
    ActionList_Plugins: TActionList;
    actAddPlugin: TAction;
    N1: TMenuItem;
    actLoadPlugin: TAction;
    actUnloadPlugin: TAction;
    actLoadAll: TAction;
    actUnloadAll: TAction;
    procedure actAddPluginExecute(Sender: TObject);
    procedure fraListViewactClearListViewExecute(Sender: TObject);
    procedure fraListViewactRefreshListViewExecute(Sender: TObject);
    procedure fraListViewactAddListviewItemExecute(Sender: TObject);
    procedure fraListViewactDeleteItemExecute(Sender: TObject);
    procedure fraListViewactSelectAllExecute(Sender: TObject);
    procedure fraListViewactSelectNoneExecute(Sender: TObject);
    procedure fraListViewactSelectInvertExecute(Sender: TObject);
    procedure PluginManagerAfterLoadDllEvent(Sender: TObject; Index: Integer);
    procedure PluginManagerAfterUnloadDllEvent(Sender: TObject; Index: Integer);
    procedure PluginManagerBeforeLoadDllEvent(Sender: TObject; Index: Integer);
    procedure PluginManagerBeforeUnloadDllEvent(Sender: TObject;
      Index: Integer);
    procedure actLoadPluginExecute(Sender: TObject);
    procedure actLoadAllExecute(Sender: TObject);
    procedure actUnloadAllExecute(Sender: TObject);
    procedure fraListViewactSelectFirstExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}


procedure TfraPluginListView.actLoadAllExecute(Sender: TObject);
begin
PluginManager.LoadAll;
end;

procedure TfraPluginListView.actLoadPluginExecute(Sender: TObject);
Var
  aPluginObject : TPluginObject;
begin
end;

procedure TfraPluginListView.actUnloadAllExecute(Sender: TObject);
begin
PluginManager.UnloadAll;
end;

procedure TfraPluginListView.fraListViewactAddListviewItemExecute(
  Sender: TObject);
begin
  fraListView.actAddListviewItemExecute(Sender);

end;

procedure TfraPluginListView.fraListViewactClearListViewExecute(
  Sender: TObject);
begin
  fraListView.actClearListViewExecute(Sender);
  PluginManager.ClearDlls;
end;

procedure TfraPluginListView.fraListViewactDeleteItemExecute(Sender: TObject);
begin
  fraListView.actDeleteItemExecute(Sender);

end;

procedure TfraPluginListView.fraListViewactRefreshListViewExecute(
  Sender: TObject);
Var
  aPluginObject : TPluginObject;
  i             : integer;
  aListItem     : TListItem;
begin

if (PluginManager.DLLList.Count > 0) AND
   (fraListView.ListView.Items.Count > 0) then
      Begin
      fraListView.ListView.Items.BeginUpdate;
      for i := 0 to PluginManager.DLLList.Count - 1 do
           Begin
             aPluginObject := PluginManager.GetInfo(i);

             aListItem := fraListView.ListView.FindCaption(0,aPluginObject.Path + aPluginObject.FileName,true,true,false);
             if aListItem <> nil then
                Begin
                aListItem.Caption := aPluginObject.Path + aPluginObject.FileName;
                aListItem.SubItems.Clear;
                aListItem.SubItems.Add(aPluginObject.Path);
                aListItem.SubItems.Add(IntToStr(aPluginObject.Handle));

                if aPluginObject.IsLoaded then
                   Begin
                   aListItem.SubItems.Add('Is Loaded');
                   End
                  ELSE
                   Begin
                   aListItem.SubItems.Add('Not Loaded');
                   End
                End;
           End;
      fraListView.ListView.Items.EndUpdate;
      End;

fraListView.actRefreshListViewExecute(Sender);

end;

procedure TfraPluginListView.fraListViewactSelectAllExecute(Sender: TObject);
begin
  fraListView.actSelectAllExecute(Sender);
end;

procedure TfraPluginListView.fraListViewactSelectFirstExecute(Sender: TObject);
begin
  fraListView.actSelectFirstExecute(Sender);


end;

procedure TfraPluginListView.fraListViewactSelectInvertExecute(Sender: TObject);
begin
  fraListView.actSelectInvertExecute(Sender);
end;

procedure TfraPluginListView.fraListViewactSelectNoneExecute(Sender: TObject);
begin
  fraListView.actSelectNoneExecute(Sender);
end;


procedure TfraPluginListView.PluginManagerAfterLoadDllEvent(Sender: TObject;
  Index: Integer);
begin
fraListView.UpdateStatusBarText('Loaded Plugin',-1);
end;

procedure TfraPluginListView.PluginManagerAfterUnloadDllEvent(Sender: TObject;
  Index: Integer);
begin
fraListView.UpdateStatusBarText('Unloaded Plugin',-1);
end;

procedure TfraPluginListView.PluginManagerBeforeLoadDllEvent(Sender: TObject;
  Index: Integer);
begin
fraListView.UpdateStatusBarText('Loading...',-1);
end;

procedure TfraPluginListView.PluginManagerBeforeUnloadDllEvent(Sender: TObject;
  Index: Integer);
begin
fraListView.UpdateStatusBarText('Unloading...',-1);
end;

procedure TfraPluginListView.actAddPluginExecute(Sender: TObject);
Var
  DefaultData : TListItemInfoRec;
  Files : TStringList;
begin
Files := TStringList.Create;

if OpenDialog.Execute(Self.Handle) then
   Begin
   DefaultData.Caption := 'Unknown';
   DefaultData.Checked := false;
   DefaultData.GroupID := -1;
   DefaultData.ImageIndex := -1;
   DefaultData.OverlayIndex := -1;

   Files.Text := OpenDialog.Files.Text;


   if OpenDialog.Files.Count > 0 then
      Begin
      fraListView.AddItems(Files, False, DefaultData);
      End;



   End;

PluginManager.AddDlls(Files);

fraListView.UpdateStatusBarText('Added: ' + IntToStr(Files.Count),-1);
Files.Free;
end;

end.