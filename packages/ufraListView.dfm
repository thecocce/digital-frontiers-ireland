object fraListView: TfraListView
  Left = 0
  Top = 0
  Width = 770
  Height = 538
  TabOrder = 0
  OnClick = FrameClick
  OnEnter = FrameEnter
  OnExit = FrameExit
  object ListView: TJvListView
    Left = 0
    Top = 0
    Width = 770
    Height = 538
    Align = alClient
    Columns = <>
    TabOrder = 0
    ViewStyle = vsReport
    ExtendedColumns = <>
    ExplicitLeft = 264
    ExplicitTop = 192
    ExplicitWidth = 250
    ExplicitHeight = 150
  end
  object ActionList_ListView: TActionList
    Left = 48
    Top = 40
    object actClearListView: TAction
      Tag = 2
      Category = 'ListView.Items'
      Caption = '&Clear'
      OnExecute = actClearListViewExecute
    end
    object actRefreshListView: TAction
      Tag = 1
      Category = 'ListView.Items'
      Caption = '&Refresh'
      OnExecute = actRefreshListViewExecute
    end
    object actListViewList: TAction
      Tag = 1
      Category = 'ListView.ViewStyle'
      Caption = '&List'
      GroupIndex = 1
      OnExecute = actListViewListExecute
    end
    object actListViewReport: TAction
      Tag = 1
      Category = 'ListView.ViewStyle'
      Caption = '&Report'
      GroupIndex = 1
      OnExecute = actListViewReportExecute
    end
    object actListViewIcon: TAction
      Tag = 1
      Category = 'ListView.ViewStyle'
      Caption = '&Icon'
      GroupIndex = 1
      OnExecute = actListViewIconExecute
    end
    object actListViewTiled: TAction
      Tag = 1
      Category = 'ListView.ViewStyle'
      Caption = '&Tile'
      GroupIndex = 1
      OnExecute = actListViewTiledExecute
    end
    object actListViewSmallIcon: TAction
      Tag = 1
      Category = 'ListView.ViewStyle'
      Caption = '&Small Icon'
      GroupIndex = 1
      OnExecute = actListViewSmallIconExecute
    end
    object actSelectAll: TAction
      Tag = 2
      Category = 'ListView.Items'
      Caption = 'Select &All'
      OnExecute = actSelectAllExecute
    end
    object actSelectNone: TAction
      Tag = 2
      Category = 'ListView.Items'
      Caption = 'Select &None'
      OnExecute = actSelectNoneExecute
    end
    object actSelectInvert: TAction
      Tag = 2
      Category = 'ListView.Items'
      Caption = 'In&vert Selection'
      OnExecute = actSelectInvertExecute
    end
    object actSelectFirst: TAction
      Tag = 2
      Category = 'ListView.Navigation'
      Caption = '&First'
      OnExecute = actSelectFirstExecute
    end
    object actSelectLast: TAction
      Tag = 2
      Category = 'ListView.Navigation'
      Caption = '&Last'
      OnExecute = actSelectLastExecute
    end
    object actSelectPrevious: TAction
      Tag = 2
      Category = 'ListView.Navigation'
      Caption = '&Previous'
      OnExecute = actSelectPreviousExecute
    end
    object actSelectNext: TAction
      Tag = 2
      Category = 'ListView.Navigation'
      Caption = '&Next'
      OnExecute = actSelectNextExecute
    end
    object actListViewGrouped: TAction
      Tag = 1
      Category = 'ListView.ViewStyle'
      Caption = '&Group View'
      OnExecute = actListViewGroupedExecute
    end
    object actGroupCollapseAll: TAction
      Tag = 2
      Category = 'ListView.Groups'
      Caption = 'Collapse &All'
      OnExecute = actGroupCollapseAllExecute
    end
    object actGroupExpandAll: TAction
      Tag = 2
      Category = 'ListView.Groups'
      Caption = '&UnCollapse All'
      OnExecute = actGroupExpandAllExecute
    end
    object actFlatScrollBars: TAction
      Tag = 1
      Category = 'ListView.ViewStyle'
      Caption = '&Flat Scrollbars'
      OnExecute = actFlatScrollBarsExecute
    end
    object actGridLines: TAction
      Tag = 1
      Category = 'ListView.ViewStyle'
      Caption = '&Grid Lines'
      OnExecute = actGridLinesExecute
    end
    object actDotNetHighlight: TAction
      Tag = 1
      Category = 'ListView.ViewStyle'
      Caption = '.NET &Highlighting'
      OnExecute = actDotNetHighlightExecute
    end
    object actHotTrack: TAction
      Tag = 1
      Category = 'ListView.ViewStyle'
      Caption = '&Hot Tracking'
      OnExecute = actHotTrackExecute
    end
    object actFulldrag: TAction
      Tag = 1
      Category = 'ListView.ViewStyle'
      Caption = 'Ful&ldrag'
      OnExecute = actFulldragExecute
    end
    object actShowHint: TAction
      Tag = 1
      Category = 'ListView.ViewStyle'
      Caption = 'Show &Hint'
      OnExecute = actShowHintExecute
    end
    object actRowSelect: TAction
      Tag = 1
      Category = 'ListView.ViewStyle'
      Caption = '&Row Select'
      OnExecute = actRowSelectExecute
    end
    object actShowColHeaders: TAction
      Tag = 1
      Category = 'ListView.ViewStyle'
      Caption = 'Show Column &Headers'
      OnExecute = actShowColHeadersExecute
    end
  end
  object Menu_ListView: TJvPopupMenu
    OnPopup = Menu_ListViewPopup
    ImageMargin.Left = 0
    ImageMargin.Top = 0
    ImageMargin.Right = 0
    ImageMargin.Bottom = 0
    ImageSize.Height = 0
    ImageSize.Width = 0
    Left = 152
    Top = 40
    object Clear1: TMenuItem
      Action = actClearListView
    end
    object Refresh1: TMenuItem
      Action = actRefreshListView
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Items1: TMenuItem
      Caption = '&Items'
      object First1: TMenuItem
        Action = actSelectFirst
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Previous1: TMenuItem
        Action = actSelectPrevious
      end
      object Next1: TMenuItem
        Action = actSelectNext
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Last1: TMenuItem
        Action = actSelectLast
      end
    end
    object Groups1: TMenuItem
      Caption = '&Groups'
      object GroupView1: TMenuItem
        Action = actListViewGrouped
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object CollapseAll1: TMenuItem
        Action = actGroupCollapseAll
      end
      object UnCollapseAll1: TMenuItem
        Action = actGroupExpandAll
      end
    end
    object Select1: TMenuItem
      Caption = '&Select'
      object SelectAll1: TMenuItem
        Action = actSelectAll
      end
      object SelectNone1: TMenuItem
        Action = actSelectNone
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object InvertSelection1: TMenuItem
        Action = actSelectInvert
      end
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object ViewStyle1: TMenuItem
      Caption = '&View Style'
      object Icon1: TMenuItem
        Tag = 1
        Action = actListViewIcon
        GroupIndex = 1
        RadioItem = True
      end
      object List1: TMenuItem
        Tag = 1
        Action = actListViewList
        GroupIndex = 1
        RadioItem = True
      end
      object Report1: TMenuItem
        Tag = 1
        Action = actListViewReport
        GroupIndex = 1
        RadioItem = True
      end
      object SmallIcon1: TMenuItem
        Tag = 1
        Action = actListViewSmallIcon
        GroupIndex = 1
        RadioItem = True
      end
      object ile1: TMenuItem
        Tag = 1
        Action = actListViewTiled
        GroupIndex = 1
        RadioItem = True
      end
      object N5: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object GridLines1: TMenuItem
        Action = actGridLines
        GroupIndex = 1
      end
      object FlatScrollbars1: TMenuItem
        Action = actFlatScrollBars
        GroupIndex = 1
      end
      object ShowColumnHeaders1: TMenuItem
        Action = actShowColHeaders
        GroupIndex = 1
      end
      object ShowHint1: TMenuItem
        Action = actShowHint
        GroupIndex = 1
      end
    end
    object Behaviour1: TMenuItem
      Caption = '&Behavour'
      object HotTracking1: TMenuItem
        Tag = 1
        Action = actHotTrack
      end
      object NETHighlighting1: TMenuItem
        Action = actDotNetHighlight
      end
      object Fulldrag1: TMenuItem
        Action = actFulldrag
      end
      object RowSelect1: TMenuItem
        Action = actRowSelect
      end
    end
  end
end