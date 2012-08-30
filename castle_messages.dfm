object frmMessages: TfrmMessages
  Left = 404
  Top = 84
  Width = 503
  Height = 351
  Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1103
  Color = clBtnFace
  Constraints.MinHeight = 325
  Constraints.MinWidth = 350
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefaultPosOnly
  PrintScale = poNone
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 281
    Width = 495
    Height = 43
    Align = alBottom
    BevelOuter = bvNone
    Color = 1910335
    TabOrder = 0
    DesignSize = (
      495
      43)
    object k_send: TImage
      Left = 459
      Top = 7
      Width = 29
      Height = 30
      Cursor = crHandPoint
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1089#1086#1086#1073#1097#1077#1085#1080#1077
      Anchors = [akTop, akRight]
      AutoSize = True
      ParentShowHint = False
      ShowHint = True
      OnClick = k_sendClick
    end
    object k_obn: TImage
      Left = 423
      Top = 7
      Width = 29
      Height = 30
      Cursor = crHandPoint
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100
      Anchors = [akTop, akRight]
      AutoSize = True
      ParentShowHint = False
      ShowHint = True
      OnClick = k_obnClick
    end
    object cbUsers: TComboBox
      Left = 12
      Top = 12
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 0
    end
    object eMess: TEdit
      Left = 164
      Top = 12
      Width = 252
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      OnKeyDown = eMessKeyDown
    end
  end
  object WBPrivate: TEmbeddedWB
    Left = 0
    Top = 0
    Width = 495
    Height = 281
    Align = alClient
    TabOrder = 1
    OnDocumentComplete = WBPrivateDocumentComplete
    DownloadOptions = [DLCTL_DLIMAGES, DLCTL_VIDEOS, DLCTL_BGSOUNDS]
    UserInterfaceOptions = [NO3DBORDER, FLAT_SCROLLBAR, THEME, NO3DOUTERBORDER]
    OnShowContextMenu = WBPrivateShowContextMenu
    PrintOptions.Margins.Left = 5.503418000000000000
    PrintOptions.Margins.Right = 6.519418000000000000
    PrintOptions.Margins.Top = 6.350000000000000000
    PrintOptions.Margins.Bottom = 6.389878000000000000
    PrintOptions.HTMLHeader.Strings = (
      '<HTML></HTML>')
    PrintOptions.Orientation = poPortrait
    ReplaceCaption = False
    EnableDDE = False
    fpExceptions = True
    ControlData = {
      4C0000008E200000271700000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
end
