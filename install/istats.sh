#!/usr/bin/env bash
source ../shell/.function

if is-macos; then
  # install
  gem install iStats

  # sensors for cthulhu
  declare -a sensors=(TA0p TA0P TG0D TL0P TPCD TCGc TCXc TC0c TC1c TC2c TC3c TM0P TM1P TM2P TM3P TH0P)

  for i in "${sensors[@]}"
  do
    echo "Enabling '$i'"
    istats enable "$i"
  done
else
  echo "Uh-oh, you're not on a Mac! iStats is only for Macs."
fi
