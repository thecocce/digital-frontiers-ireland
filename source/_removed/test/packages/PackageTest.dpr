program PackageTest;

uses
  Vcl.Forms,
  uPackageTestMain in 'uPackageTestMain.pas' {frmListView},
  ufraListView in '..\..\..\packages\ufraListView.pas' {fraListView: TFrame},
  udlgListView_AddGroup in '..\..\..\packages\udlgListView_AddGroup.pas' {dlgAddGroup},
  udlgListView_AddItem in '..\..\..\packages\udlgListView_AddItem.pas' {dlgAddItem},
  ufraListView_Groups in '..\..\..\packages\ufraListView_Groups.pas' {fraListView_Groups: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmListView, frmListView);
  Application.CreateForm(TdlgAddGroup, dlgAddGroup);
  Application.CreateForm(TdlgAddItem, dlgAddItem);
  Application.Run;
end.
