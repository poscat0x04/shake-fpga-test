{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Adder where

import Clash.Prelude

createDomain vSystem {vName = "Dom", vPeriod = hzToPeriod 100e6}

wire :: Clock Dom -> Signal Dom (Unsigned 8) -> Signal Dom (Unsigned 8) -> Signal Dom (Unsigned 8)
wire clk a b = a + b
{-# ANN
  wire
  ( Synthesize
      { t_name = "wir",
        t_inputs = [PortName "clk", PortName "a", PortName "b"],
        t_output = PortName "o"
      }
  )
  #-}
