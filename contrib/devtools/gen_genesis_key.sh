#!/bin/sh
# 
# File:   gen_genesis_key.sh
# Author: chrootlogin
#
openssl ecparam -genkey -name secp256k1 -out genesiscoinbase.pem
openssl ec -in genesiscoinbase.pem -text > genesiscoinbase.hex