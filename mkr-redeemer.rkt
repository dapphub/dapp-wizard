#lang s-exp dapp/wizard
(say "Welcome to the MKR redemption process.\n"
     "There is a new version of the MKR token.\n"
     "If you hold coins of the old version, you can redeem them.")

(say "Please choose the account which holds MKR.")

(say "Using " (choose-account))
