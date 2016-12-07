#!/bin/bash

export SECRET_KEY_BASE="721b030e05930db30fd7a0d7e3cb0e1f0159d1e37e22461b620eb7e12c555006ae1f88fbc7c9ac6f753807032a75b6e9f35ecdeb13fd012919190e10e49f9b24"
bundle exec unicorn -c config/unicorn.rb -E production -D
