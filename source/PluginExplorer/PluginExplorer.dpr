// JCL_DEBUG_EXPERT_GENERATEJDBG ON
program PluginExplorer;

uses
  FastMM4,
  Vcl.Forms,
  uManager in 'uManager.pas' {Form2},
  ufraPluginListView in '..\..\packages\ufraPluginListView.pas' {fraPluginListView: TFrame};

{$R *.res}


begin

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
