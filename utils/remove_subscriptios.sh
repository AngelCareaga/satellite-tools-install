#!/bin/bash

## REMOVE SUBSCRIPTION
echo " ======= REMOVING SUBSCRIPTION ========"
subscription-manager remove --all

echo " ======= UNREGISTER SUBSCRIPTION ========"
subscription-manager unregister
