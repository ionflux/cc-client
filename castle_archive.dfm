object frmArchive: TfrmArchive
  Left = 406
  Top = 43
  Width = 555
  Height = 433
  Caption = #1040#1088#1093#1080#1074
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefaultPosOnly
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 153
    Top = 0
    Height = 406
  end
  object WBArchive: TEmbeddedWB
    Left = 156
    Top = 0
    Width = 391
    Height = 406
    Align = alClient
    TabOrder = 0
    OnDocumentComplete = WBArchiveDocumentComplete
    DownloadOptions = [DLCTL_DLIMAGES, DLCTL_VIDEOS, DLCTL_BGSOUNDS, DLCTL_PRAGMA_NO_CACHE]
    UserInterfaceOptions = [NO3DBORDER, FLAT_SCROLLBAR, URL_ENCODING_ENABLE_UTF8, ENABLE_FORMS_AUTOCOMPLETE, ENABLE_INPLACE_NAVIGATION, THEME, NO3DOUTERBORDER]
    OnShowContextMenu = WBArchiveShowContextMenu
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
      4C00000066340000582600000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 153
    Height = 406
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      153
      406)
    object vsLogs: TVirtualStringTree
      Left = 0
      Top = 23
      Width = 153
      Height = 383
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelKind = bkTile
      BorderStyle = bsNone
      Header.AutoSizeIndex = 0
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Sans Serif'
      Header.Font.Style = []
      Header.MainColumn = -1
      Header.Options = [hoColumnResize, hoDrag]
      TabOrder = 0
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnChange = vsLogsChange
      OnFreeNode = vsLogsFreeNode
      OnGetText = vsLogsGetText
      Columns = <>
    end
    object cbRooms: TComboBox
      Left = 0
      Top = 0
      Width = 152
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      TabOrder = 1
      OnChange = cbRoomsChange
    end
  end
end
