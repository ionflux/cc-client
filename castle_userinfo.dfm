object frmUserInfo: TfrmUserInfo
  Left = 373
  Top = 255
  Width = 360
  Height = 340
  BorderStyle = bsSizeToolWin
  Caption = #1051#1080#1095#1085#1086#1077' '#1076#1077#1083#1086
  Color = clBtnFace
  Constraints.MinHeight = 340
  Constraints.MinWidth = 360
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 43
    Width = 352
    Height = 236
    ActivePage = tsDelo
    Align = alClient
    TabOrder = 0
    OnChange = PageControlChange
    object tsDelo: TTabSheet
      Caption = #1044#1077#1083#1086
      DesignSize = (
        344
        208)
      object Label4: TLabel
        Left = 4
        Top = 4
        Width = 19
        Height = 13
        Caption = 'ICQ'
      end
      object Label5: TLabel
        Left = 4
        Top = 24
        Width = 151
        Height = 13
        Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103
      end
      object eICQ: TEdit
        Left = 32
        Top = 0
        Width = 311
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ReadOnly = True
        TabOrder = 0
      end
      object eInfo: TMemo
        Left = 0
        Top = 40
        Width = 344
        Height = 168
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        ReadOnly = True
        TabOrder = 1
      end
    end
    object tsMemo: TTabSheet
      Caption = #1047#1072#1084#1077#1090#1082#1080
      ImageIndex = 1
      object eMemo: TMemo
        Left = 0
        Top = 0
        Width = 347
        Height = 212
        Align = alClient
        TabOrder = 0
      end
    end
    object tsSetup: TTabSheet
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 3
      object Label1: TLabel
        Left = 4
        Top = 4
        Width = 53
        Height = 13
        Caption = #1062#1074#1077#1090' '#1085#1080#1082#1072
      end
      object Label6: TLabel
        Left = 4
        Top = 28
        Width = 64
        Height = 13
        Caption = #1062#1074#1077#1090' '#1090#1077#1082#1089#1090#1072
      end
      object cbRecvText: TCheckBox
        Left = 4
        Top = 52
        Width = 189
        Height = 17
        Caption = #1055#1086#1083#1091#1095#1072#1090#1100' '#1086#1090' '#1085#1077#1075#1086' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
        TabOrder = 0
      end
      object eNickColor: TEdit
        Left = 76
        Top = 0
        Width = 178
        Height = 21
        TabOrder = 1
      end
      object eTextColor: TEdit
        Left = 76
        Top = 24
        Width = 178
        Height = 21
        TabOrder = 2
      end
    end
    object TabSheet1: TTabSheet
      Caption = #1048#1089#1090#1086#1088#1080#1103
      ImageIndex = 4
      object lvHistory: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 344
        Height = 208
        Align = alClient
        DefaultNodeHeight = 15
        Header.AutoSizeIndex = 2
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
        PopupMenu = PopupMenu1
        TabOrder = 0
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
        OnGetText = lvHistoryGetText
        OnPaintText = lvHistoryPaintText
        Columns = <
          item
            Position = 0
            Width = 70
            WideText = #1054#1090
          end
          item
            Position = 1
            Width = 70
            WideText = #1044#1083#1103
          end
          item
            Position = 2
            Width = 204
            WideText = #1058#1077#1082#1089#1090
          end>
      end
    end
    object chat_irk_ru: TTabSheet
      Caption = 'chat.irk.ru'
      ImageIndex = 4
      OnShow = chat_irk_ruShow
      DesignSize = (
        344
        208)
      object Label7: TLabel
        Left = 172
        Top = 5
        Width = 46
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1053#1080#1082':'
      end
      object Label8: TLabel
        Left = 172
        Top = 21
        Width = 46
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'EMail:'
      end
      object Label9: TLabel
        Left = 172
        Top = 53
        Width = 46
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'ICQ:'
      end
      object Label10: TLabel
        Left = 172
        Top = 37
        Width = 46
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Web:'
      end
      object Label11: TLabel
        Left = 172
        Top = 69
        Width = 46
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1048#1084#1103':'
      end
      object Label14: TLabel
        Left = 172
        Top = 85
        Width = 46
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1043#1086#1088#1086#1076':'
      end
      object eNick: TEdit
        Left = 222
        Top = 6
        Width = 115
        Height = 15
        Anchors = [akLeft, akTop, akRight]
        BorderStyle = bsNone
        ParentColor = True
        ReadOnly = True
        TabOrder = 0
        Text = '???'
      end
      object eEmail: TEdit
        Left = 222
        Top = 22
        Width = 115
        Height = 15
        Cursor = crHandPoint
        Anchors = [akLeft, akTop, akRight]
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentColor = True
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
        Text = '???'
        OnDblClick = eEmailDblClick
      end
      object eWeb: TEdit
        Left = 222
        Top = 38
        Width = 115
        Height = 15
        Cursor = crHandPoint
        Anchors = [akLeft, akTop, akRight]
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentColor = True
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
        Text = '???'
        OnDblClick = eWebDblClick
      end
      object eCICQ: TEdit
        Left = 222
        Top = 54
        Width = 115
        Height = 15
        Anchors = [akLeft, akTop, akRight]
        BorderStyle = bsNone
        ParentColor = True
        ReadOnly = True
        TabOrder = 3
        Text = '???'
      end
      object eSity: TEdit
        Left = 222
        Top = 86
        Width = 115
        Height = 15
        Anchors = [akLeft, akTop, akRight]
        BorderStyle = bsNone
        ParentColor = True
        ReadOnly = True
        TabOrder = 4
        Text = '???'
      end
      object eName: TEdit
        Left = 222
        Top = 70
        Width = 115
        Height = 15
        Anchors = [akLeft, akTop, akRight]
        BorderStyle = bsNone
        ParentColor = True
        ReadOnly = True
        TabOrder = 5
        Text = '???'
      end
      object mInfo: TMemo
        Left = 164
        Top = 104
        Width = 174
        Height = 98
        Anchors = [akLeft, akTop, akRight, akBottom]
        Lines.Strings = (
          '???')
        ReadOnly = True
        TabOrder = 6
      end
      object Panel3: TPanel
        Left = 4
        Top = 4
        Width = 155
        Height = 198
        AutoSize = True
        BevelInner = bvLowered
        Caption = #1053#1045#1058' '#1060#1054#1058#1054
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        object ch_image: TImage
          Left = 2
          Top = 2
          Width = 151
          Height = 194
          AutoSize = True
          Center = True
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 279
    Width = 352
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      352
      34)
    object btnClose: TButton
      Left = 273
      Top = 5
      Width = 75
      Height = 25
      Hint = #1047#1072#1082#1088#1099#1090#1100' (ESC)'
      Anchors = [akTop, akRight]
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnCloseClick
    end
    object btnRefresh: TButton
      Left = 115
      Top = 5
      Width = 75
      Height = 25
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' (F5)'
      Anchors = [akRight, akBottom]
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnRefreshClick
    end
    object btnSave: TButton
      Left = 194
      Top = 5
      Width = 75
      Height = 25
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' (F2)'
      Anchors = [akRight, akBottom]
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnSaveClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 352
    Height = 43
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 2
    object Image1: TImage
      Left = 8
      Top = 8
      Width = 17
      Height = 24
      AutoSize = True
      Center = True
      Picture.Data = {
        07544269746D617096010000424D960100000000000076000000280000001100
        0000180000000100040000000000200100000000000000000000100000000000
        00006B6B6B000000800028282800FFFFFF00A5C8FF0000000000FFFFFF000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000555555555555555550000000555554444444555550000000555444444444
        4455500000005554444444444455500000005544441111144445500000005544
        4444444444455000000055444444444444455000000055444445554444455000
        0000555444444444445550000000545444444444445450000000545445544455
        4454500000005454455444554454500000005554455444554455500000005554
        4444444444555000000055545554445554555000000055544444444444555000
        0000555444444442005550000000555444440222555550000000555442203222
        2555500000005550222333222555500000005555222233225555500000005555
        5222355555555000000055555255555555555000000055555555555555555000
        0000}
    end
    object lName: TLabel
      Left = 40
      Top = 8
      Width = 77
      Height = 13
      Caption = #1056#1086#1076#1089#1090#1074#1077#1085#1085#1080#1082
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 28
      Top = 23
      Width = 233
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1083#1080#1095#1085#1086#1075#1086' '#1076#1077#1083#1072' '#1079#1072#1082#1083#1102#1095#1077#1085#1085#1086#1075#1086
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = TimerTimer
    Left = 252
    Top = 183
  end
  object PopupMenu1: TPopupMenu
    Left = 252
    Top = 215
    object N1: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      ShortCut = 16451
    end
  end
end
