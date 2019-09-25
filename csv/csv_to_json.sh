#!/bin/bash

file="example.csv"

# enquanto tivermos linhas para ler dentro do arquivo csv, iteramos sobre ele
while IFS= read -r line
do
    # a variavel $line se refere a linha de iteracao atual
    echo "$line"
done < "$file"