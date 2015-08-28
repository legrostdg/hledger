module Hledger.UI.UITypes where

import Data.Time.Calendar (Day)
import qualified Graphics.Vty as V
import Brick
import Brick.Widgets.List (List)

import Hledger
import Hledger.UI.Options

----------------------------------------------------------------------

-- | hledger-ui's application state. This is part of, but distinct
-- from, brick's App.
data AppState = AppState {
   aopts :: UIOpts          -- ^ command-line options at startup
  -- ,aargs :: [String]        -- ^ command-line arguments at startup
  ,ajournal :: Journal      -- ^ the parsed journal
  ,aScreen :: Screen        -- ^ the currently active screen
  ,aPrevScreens :: [Screen] -- ^ previously visited screens
  } deriving (Show)

-- | Types of screen available within the app, along with their state.
-- Screen types are distinguished by their constructor and by the type
-- of their state (which must have unique accessor names).
data Screen =
    AccountsScreen {
     asState :: List BalanceReportItem                            -- ^ the screen's state (data being displayed and widget state)
    ,sInitFn :: Day -> AppState -> AppState                         -- ^ function to initialise the screen's state on entry
    ,sHandleFn :: AppState -> V.Event -> EventM (Next AppState) -- ^ brick event handler to use for this screen
    ,sDrawFn :: AppState -> [Widget]                                -- ^ brick renderer to use for this screen
    }
  | RegisterScreen {
     rsState :: List (String,String,String,String,String)
    ,rsAcct :: AccountName              -- ^ the account we are showing a register for
    ,sInitFn :: Day -> AppState -> AppState
    ,sHandleFn :: AppState -> V.Event -> EventM (Next AppState)
    ,sDrawFn :: AppState -> [Widget]
    }
  deriving (Show)

instance Show (List a) where show _ = "<List>"
