unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus, Grids, ExtCtrls, StrUtils,windows,messages, Clipbrd;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    StringGrid1: TStringGrid;
    TrayIcon1: TTrayIcon;
    procedure Button1Click(Sender: TObject);
    procedure Button1KeyPress(Sender: TObject; var Key: char);
    procedure FormDestroy(Sender: TObject);
    procedure search;
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    function FindText(Strings: TStringList; const SubStr: string): Integer;
    procedure MenuItem3Click(Sender: TObject);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TrayIcon1Click(Sender: TObject);
    procedure WmHotkey(var Msg: TMessage); message WM_HOTKEY;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  woerter:TStringList;
  woerterdatei:TextFile;
  treffer:TStringList;
  tabteiler:TStringList;
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
   close;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
var inputstring:string;
begin
  if not OpenDialog1.Execute then exit;
  {AssignFile(woerterdatei,OpenDialog1.FileName);
  reset(woerterdatei);
  read(woerterdatei,inputstring);
  ShowMessage(inttostr(Length(inputstring)));}
  woerter.Clear;
  woerter.Delimiter:= chr(10);
  woerter.LoadFromFile(OpenDialog1.FileName);
  {woerter.DelimitedText := inputstring; }
  woerter.Sort;
  Label1.Caption:='Einträge: ' + inttostr(woerter.Count);
  ShowMessage('Geladen. Einträge: ' + inttostr(woerter.Count));

  //CloseFile(woerterdatei);

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  woerter := TStringList.Create;
  woerter.QuoteChar:=chr(34);
  treffer := TStringList.Create;
  treffer.QuoteChar:=chr(34);
  tabteiler := TStringList.Create;
  tabteiler.Delimiter:=chr(9);
  tabteiler.QuoteChar:=chr(34);

  RegisterHotKey(Handle,1,MOD_ALT,32);
  RegisterHotKey(Handle,2,MOD_CONTROL+MOD_ALT,86);
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin
  if ord(key) = 27 then self.hide;
end;

procedure TForm1.search;
var posi,i:integer;
  num:integer;
  searchstr:string;
  inputstr,leftout,rightout:string;
  ende:boolean;
begin
  ende := false;
  searchstr:= Edit1.Text;
  num := 0;
   //pos := FindText(woerter,Edit1.Text);
   treffer.Clear;
   for i :=0 to woerter.Count-1 do
     begin
        if ansiStartsText(searchstr,woerter[i]) then
          begin
            treffer.Append(woerter[i]);
            if treffer.count > 49 then
              begin
                ende := true;
                break;
              end;
          end;
     end;
     if not ende then
     begin


     for i :=0 to woerter.Count-1 do
     begin
        if AnsiContainstext(woerter[i],searchstr) then
          begin
            treffer.Append(woerter[i]);
            if treffer.count > 49 then break;
          end;
     end;
       end;
     StringGrid1.Clean;
     label1.Caption:='Treffer: ' + inttostr(treffer.Count);
     for i :=0 to treffer.Count-1 do
     begin
        //tabteiler.Clear;
        {tabteiler.Delimiter:=#9;
        //tabteiler.QuoteChar:=chr(9);
        ShowMessage(StringReplace(treffer[i],'~_~','e',[rfReplaceAll]));
        tabteiler.DelimitedText:=StringReplace(treffer[i],'~_~',#9,[rfReplaceAll]);
        StringGrid1.Cells[0,i] := tabteiler[0];
        StringGrid1.Cells[1,i] := tabteiler[1];  }
        inputstr:=treffer[i];
        posi := pos('~_~',inputstr);
        leftout:=Copy(inputstr,1,posi-1);
        rightout := copy(inputstr,posi+3,Length(inputstr));
        StringGrid1.Cells[0,i] := leftout;
        StringGrid1.Cells[1,i] := AnsiReplaceStr(rightout,'~_~',' ');

     end;
   //if pos = -1 then exit;
   //memo1.Text:=woerter[pos];

end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: char);
begin
     //ShowMessage(inttostr(ord(key)));
     if ord(key) = 27 then self.hide
     else if Ord(key) = 13 then search;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  self.Hide ;
end;

procedure TForm1.Button1KeyPress(Sender: TObject; var Key: char);
begin
  if ord(key) = 27 then self.hide;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  UnregisterHotKey(Handle, 1);
  UnregisterHotKey(Handle, 2);
end;

function TForm1.FindText(Strings: TStringList; const SubStr: string): Integer;
begin
  for Result := 0 to Strings.Count-1 do
    if ansiContainsText(Strings[Result], SubStr) then
      exit;
  Result := -1;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  self.Hide;
end;

procedure TForm1.StringGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ord(key) = 27 then self.hide;
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  self.Show;
  application.Restore;
  windows.SetForegroundWindow(self.Handle);
  self.BringToFront;
  edit1.SetFocus;
  edit1.SelectAll;
end;

procedure TForm1.WmHotkey(var Msg: TMessage);
var i:integer;
begin
  if (msg.wParam = 1) then begin
     TrayIcon1Click(TObject.newinstance);
  end else if (msg.wParam = 2) then begin
    TrayIcon1Click(TObject.newinstance);

    If Clipboard.HasFormat(CF_TEXT) then
       begin
          edit1.Text:=Clipboard.AsText;
          search;
       end;
  end;
end;


end.

