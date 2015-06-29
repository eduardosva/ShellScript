#!/bin/bash
# Limpa o cache do sistema

sysctl -w vm.drop_caches=3 1> /dev/null 2> /dev/stdout
