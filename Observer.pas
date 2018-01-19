unit Observer;

interface
uses
  Winapi.Messages, System.Generics.Collections;

const
  WM_MyMsg = WM_USER + 1000;

type
  PSubject = ^TSubject;
  rWM_MsgType = packed record
    Msg: Cardinal;
    Sender: PSubject;
    Value1: LongInt;
    Value2: LongInt;
    Value3: string;
  end;
  TSubject = class
  strict private
    FObservers: TList<TObject>;
  strict protected
    function SetMsgDetail: rWM_MsgType; virtual;
  public
    constructor Create();
    destructor Destroy; override;

    procedure Attach(observer: TObject);
    procedure Detach(observer: TObject);
    procedure Notify;
  end;

  TMySubject = class(TSubject)
  strict private
    FValue: Integer;
  strict protected
    function SetMsgDetail: rWM_MsgType; override;
  public
    constructor Create();
    destructor Destroy; override;
    procedure IncValue;
    procedure DecValue;
  end;

implementation
uses
  System.SysUtils;

{ TSubject }

procedure TSubject.Attach(observer: TObject);
begin
  if FObservers.IndexOf(observer) <> -1 then
    Exit;
  FObservers.Add(observer);
end;

constructor TSubject.Create;
begin
  FObservers := TList<TObject>.Create;
end;

destructor TSubject.Destroy;
begin
  FreeAndNil(FObservers);
  inherited;
end;

procedure TSubject.Detach(observer: TObject);
begin
  if FObservers.IndexOf(observer) = -1 then
    Exit;
  FObservers.Remove(observer);
end;

procedure TSubject.Notify;
var
  aObserverObj: TObject;
  aMsg: rWM_MsgType;
begin
  aMsg := SetMsgDetail;
  for aObserverObj in FObservers do
  begin
    aObserverObj.Dispatch(aMsg);
  end;
end;

function TSubject.SetMsgDetail: rWM_MsgType;
begin
  Result.Msg := WM_MyMsg;
  Result.Sender := @Self;
  Result.Value1 := 0;
  Result.Value2 := 0;
  Result.Value3 := 'default';
end;

{ TMySubject }

constructor TMySubject.Create;
begin
  inherited;
  FValue := 0;
end;

procedure TMySubject.DecValue;
begin
  Dec(FValue);
  Notify;
end;

destructor TMySubject.Destroy;
begin

  inherited;
end;

procedure TMySubject.IncValue;
begin
  Inc(FValue);
  Notify;
end;

function TMySubject.SetMsgDetail: rWM_MsgType;
begin
  Result.Msg := WM_MyMsg;
  Result.Sender := @Self;
  Result.Value1 := 0;
  Result.Value2 := FValue;
  Result.Value3 := 'TMySubject';
end;

end.
