module Main where

import Verilated

main :: IO ()
main = do
  m <- c_startModel
  c_stopModel m
  pure ()
