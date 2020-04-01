{-# LANGUAGE QuasiQuotes, RecordWildCards #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
{-|

The @balancesheetequity@ command prints a simple balance sheet.

-}

module Hledger.Cli.Commands.Balancesheetequity (
  balancesheetequitymode
 ,balancesheetequity
) where

import System.Console.CmdArgs.Explicit
import Data.Map as M
import Data.Text as T

import Hledger
import Hledger.Cli.CliOptions
import Hledger.Cli.CompoundBalanceCommand
import Hledger.Data.Types

balancesheetequitySpec j = CompoundBalanceCommandSpec {
  cbcdoc      = $(embedFileRelative "Hledger/Cli/Commands/Balancesheetequity.txt"),
  cbctitle    = "Balance Sheet With Equity",
  cbcqueries  = [
     CBCSubreportSpec{
      cbcsubreporttitle=T.unpack $ maybe "Assets" (Prelude.head . accountNameComponents . Prelude.head) (M.lookup Asset (jdeclaredaccounttypes j))
     ,cbcsubreportquery=journalAssetAccountQuery
     ,cbcsubreportnormalsign=NormallyPositive
     ,cbcsubreportincreasestotal=True
     }
    ,CBCSubreportSpec{
      cbcsubreporttitle=T.unpack $ maybe "Liabilities" (Prelude.head . accountNameComponents . Prelude.head) (M.lookup Liability (jdeclaredaccounttypes j))
     ,cbcsubreportquery=journalLiabilityAccountQuery
     ,cbcsubreportnormalsign=NormallyNegative
     ,cbcsubreportincreasestotal=False
     }
    ,CBCSubreportSpec{
      cbcsubreporttitle=T.unpack $ maybe "Equity" (Prelude.head . accountNameComponents . Prelude.head) (M.lookup Equity (jdeclaredaccounttypes j))
     ,cbcsubreportquery=journalEquityAccountQuery
     ,cbcsubreportnormalsign=NormallyNegative
     ,cbcsubreportincreasestotal=False
     }
    ],
  cbctype     = HistoricalBalance
}

balancesheetequitymode :: Mode RawOpts
balancesheetequitymode = compoundBalanceCommandMode $ balancesheetequitySpec nulljournal

balancesheetequity :: CliOpts -> Journal -> IO ()
balancesheetequity opts j = compoundBalanceCommand (balancesheetequitySpec j) opts j
