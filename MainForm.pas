unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Unit2, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    MySubject: TMySubject;
  public
    { Public declarations }
    procedure SubNotify(var Msg: rWM_MsgType); message WM_MyMsg;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  MySubject.IncValue;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  MySubject.DecValue;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  MySubject.Attach(Self);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MySubject := TMySubject.Create;
  Memo1.Clear;
end;

procedure TForm1.SubNotify(var Msg: rWM_MsgType);
var
  aStr: string;
begin
  aStr := Format('Value1: %d  Value2: %d Value3: %s', [Msg.Value1, Msg.Value2, Msg.Value3]);
  Memo1.Lines.Add(aStr);
end;

end.
