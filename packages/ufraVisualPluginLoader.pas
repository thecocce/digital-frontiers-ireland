unit ufraVisualPluginLoader;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uPluginUtilsEx,
  Vcl.ComCtrls, uStubCommon;

type
  TFrame1 = class(TFrame)
    OpenDialog: TOpenDialog;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ebPath: TEdit;
    Label1: TLabel;
    ebFilename: TEdit;
    Label2: TLabel;
    btnLoad: TButton;
    btnUnload: TButton;
    btnSelect: TButton;
    Label3: TLabel;
    ebHandle: TEdit;
    cbIsLoaded: TCheckBox;
    Label4: TLabel;
    ebCaption: TEdit;
    lbExports: TListBox;
    Label5: TLabel;
    Label6: TLabel;
    ebIPC: TEdit;
    GroupBox1: TGroupBox;
    procedure btnSelectClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnUnloadClick(Sender: TObject);
  private
    { Private declarations }
    PROCEDURE RefreshData();
  public
    { Public declarations }
    aPlugin : TPluginObject;
  end;

implementation

{$R *.dfm}

PROCEDURE TFrame1.RefreshData();
Var
  ExportList : TStringList;
Begin
ExportList := TStringList.Create;
if Assigned(aPlugin) then
   Begin
   if aPlugin.IsLoaded then
     Begin
     btnLoad.Enabled := false;
     btnUnload.Enabled := true;

     self.ebHandle.Text := IntToStr(aPlugin.Handle);
     ebCaption.Text := aPlugin.ListItemCaption;
     aPlugin.GetExportedFunctionNames(Self,ExportList);
     lbExports.Items.Text := ExportList.Text;
     End
   else
     begin
     btnLoad.Enabled := true;
     btnUnload.Enabled := False;
     self.ebHandle.TEXT := IntToStr(aPlugin.Handle);
     ebCaption.Text := '';
     lbExports.Clear;
     end;
   End
ELSE
   BEGIN
     btnLoad.Enabled := true;
     btnUnload.Enabled := False;
     self.ebHandle.TEXT := '0';
     ebCaption.Text := '';
     lbExports.Clear;

   END;
ExportList.Free;
End;

procedure TFrame1.btnLoadClick(Sender: TObject);
begin
if assigned(aPlugin) then
   Begin
   if NOT aPlugin.IsLoaded then
      begin
      aPlugin.Load;
      end;
   End;
RefreshData;
end;

procedure TFrame1.btnSelectClick(Sender: TObject);
begin
if OpenDialog.Execute(self.Handle) then
   begin
   ebPath.Text := ExtractFilePath(OpenDialog.FileName);
   ebFilename.Text := ExtractFileName(OpenDialog.FileName);

   if assigned(aPlugin) then
      Begin
      if aPlugin.IsLoaded then
         Begin
         aPlugin.Unload;
         End;
      btnLoad.Enabled := false;
      btnUnload.Enabled := false;
      cbIsLoaded.Checked := aPlugin.IsLoaded;
      ebHandle.Text := intToStr(aPlugin.Handle);
      FreeAndNil(aPlugin);
      End
   ELSE
      Begin
        aPlugin := TPluginObject.Create(ebFilename.Text,ebPath.Text,0);

        btnLoad.Enabled := True;
        btnUnload.Enabled := false;

        cbIsLoaded.Checked := aPlugin.IsLoaded;
        ebHandle.Text := intToStr(aPlugin.Handle);
      End;
   RefreshData;
   end;
end;

procedure TFrame1.btnUnloadClick(Sender: TObject);
begin
if assigned(aPlugin) then
   Begin
   if aPlugin.IsLoaded then
      begin
      aPlugin.Unload;
      end;
   End;
RefreshData;
end;

end.
