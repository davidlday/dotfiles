#!/usr/bin/env bash

# install
gem install iStats

# sensors for cthulhu
declare -a sensors=(TA0p TA0P TG0D TL0P TPCD TCGc TCXc TC0c TC1c TC2c TC3c TM0P TM1P TM2P TM3P)

for i in "${sensors[@]}"
do
  echo "Enabling '$i'"
  istats enable $i
done

