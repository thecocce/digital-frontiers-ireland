unit uWinPlayerMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw, Vcl.ComCtrls,
  Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.Ribbon,
  Vcl.RibbonLunaStyleActnCtrls, Vcl.ActnList;

type
  TForm1 = class(TForm)
    Ribbon: TRibbon;
    RibbonPage1: TRibbonPage;
    RibbonGroup1: TRibbonGroup;
    RibbonPage2: TRibbonPage;
    RibbonPage3: TRibbonPage;
    RibbonGroup2: TRibbonGroup;
    StatusBar: TStatusBar;
    WebBrowser: TWebBrowser;
    ActionManager: TActionManager;
    actViewPlayer: TAction;
    actExtraInfo: TAction;
    actCentovaCast: TAction;
    RibbonGroup3: TRibbonGroup;
    Action1: TAction;
    Photos: TAction;
    RibbonGroup4: TRibbonGroup;
    RibbonGroup5: TRibbonGroup;
    procedure actViewPlayerExecute(Sender: TObject);
    procedure actExtraInfoExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.actExtraInfoExecute(Sender: TObject);
begin
WebBrowser.Navigate('http://panel4.serverhostingcenter.com/start/daylnjjr/');
end;

procedure TForm1.actViewPlayerExecute(Sender: TObject);
begin
Self.WebBrowser.Navigate('http://www.digitalfrontiersireland.com/site/custom/navigator/wordpress/?p=9');
end;

end.
