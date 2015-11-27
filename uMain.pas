unit uMain;

interface

  uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Buttons, IniFiles;

  type
    TForm1 = class(TForm)
      btn1: TSpeedButton;
      OpenDialog1: TOpenDialog;
      procedure btn1Click(Sender: TObject);
      procedure FormShow(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      private
        { Private declarations }
      public
        { Public declarations }
    end;

    TConfig = class(TObject)
      FNameIn: string;
      FNameOut: string;
      Comm: integer;
      TamLinha: integer;
      pCampoIni: array [1 .. 16] of integer;
      pCampoTam: array [1 .. 16] of integer;
      Mask: string;
      Separador: String end;

      var
        Form1  : TForm1;
        vConfig: TConfig;

implementation

  {$R *.dfm}

  procedure TForm1.btn1Click(Sender: TObject);
    var
      FileIn       : TextFile;
      axStr, axStr2: string;
      axChar       : Char;
      j, i         : integer;
      axTStr       : TStringList;
    begin
      axTStr := TStringList.Create;
      axTStr.Clear;
      // if not OpenDialog1.Execute then     { Display Open dialog box }
      // Exit;
      // fName := OpenDialog1.FileName;

      i     := 0;
      axStr := '';
      // Try to open the Test.txt file for writing to
      AssignFile(FileIn, vConfig.FNameIn);
      try
        try
          Reset(FileIn);

        except
          on E: Exception do
            Raise Exception.Create(E.Message);
        end;

        try
          while not Eof(FileIn) do
            begin
              Read(FileIn, axChar);
              Inc(i);
              if not(axChar in [#10, #13]) then  // Ignora CR(#13) e LF(#10)
                axStr := axStr + axChar;

              with vConfig do
                begin
                  if (i = TamLinha) then
                    begin

                      axStr2 := Copy(axStr, pCampoIni[1], pCampoTam[1]);
                      for j  := 2 to 16 do
                        begin
                          if pCampoTam[j] <= 0 then
                            break;
                          axStr2 := axStr2 + Separador + Copy(axStr, pCampoIni[j], pCampoTam[j]);
                        end;
                      axTStr.Add(axStr2);
                      i     := 0;
                      axStr := '';
                    end;
                end;
            end;
          // axTStr.Add(axStr);
          axTStr.Sort;
          axTStr.SaveToFile(vConfig.FNameOut);
        except
          on E: Exception do
            ShowMessage(E.Message);
        end;
        // Close the file for the last time
      finally
        FreeAndNil(axTStr);
        CloseFile(FileIn);
      end;
    end;

  procedure TForm1.FormShow(Sender: TObject);
    begin
      // ShowMessage(ParamStr(1));
      btn1Click(Sender);
      Close;

    end;

  procedure TForm1.FormCreate(Sender: TObject);
    var
      IniFile: TIniFile;
      xStr   : string;
      i      : integer;
    begin
      // IniFile := TIniFile.Create('Exporta.ini');
      IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
      vConfig := TConfig.Create;
      with vConfig do
        begin
          FNameIn  := IniFile.ReadString('Exporta', 'ArquivoColetor', 'PRODUTO');
          FNameOut := IniFile.ReadString('Exporta', 'ArquivoSaida', 'COLETA.TXT');
          Comm     := IniFile.ReadInteger('Exporta', 'Comm', 1);
          TamLinha := IniFile.ReadInteger('Exporta', 'TamLinha', 1);
          for i    := 1 to 16 do
            begin
              pCampoIni[i] := IniFile.ReadInteger('Exporta', 'Campo' + IntToStr(i), 0);
            end;
          for i := 2 to 16 do
            begin
              if pCampoIni[i] = 0 then
                begin
                  pCampoTam[i - 1] := TamLinha - pCampoIni[i - 1] + 1;
                  break;
                end;
              pCampoTam[i - 1] := pCampoIni[i] - pCampoIni[i - 1];
            end;
          Mask      := IniFile.ReadString('Exporta', 'Mascara', '');
          Separador := IniFile.ReadString('Exporta', 'Separador', '');
        end;

    end;

  procedure TForm1.FormDestroy(Sender: TObject);
    begin
      FreeAndNil(vConfig);
    end;

end.
