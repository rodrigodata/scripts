#!/bin/bash

file="example.csv"
total_number_lines=$(wc -l < $file)
json_file=""

echo "Total de linhas no arquivo: $total_number_lines"

# enquanto tivermos linhas para ler dentro do arquivo csv, iteramos sobre ele
# a variavel $line se refere a linha de iteracao atual
# a variavel $i se refere a linha atual sendo processada

while ((i++)); IFS= read -r line
do

    # aqui processamos os headers do arquivo csv e salvamos dentro da variavel %header_array
    if [ $i -eq 1 ]
    then

        echo "Processando header -> $line"
        IFS=',' read -ra header_array <<< "$line"

    else

        #echo "Processando linha -> $i -> $line"
        IFS=',' read -ra row_array <<< "$line"

        current_cell_index=0
        row_array_size="${#row_array[@]}"
        json=""

        # iteramos sobre todos os valores dentro do array $row_array
        for current_cell_value in "${row_array[@]}"
        do

            current_header_value=${header_array[$current_cell_index]}

            json+="'$current_header_value':'$current_cell_value'," 
            
            # acrescimo de contagem do index
            current_cell_index=$(( current_cell_index + 1 ))

            if [ $row_array_size -eq $current_cell_index ]
            then

                IFS=',' read -ra json_array <<< "$json"
                template_json=""
                template_json+="{"
                
                current_json_index=1

                for current_json_value in "${json_array[@]}"                
                do 
                    if [ $current_json_index -eq "${#json_array[@]}" ]
                    then 
                        template_json+="$current_json_value}"    

                    else
                        current_json_index=$(( current_json_index + 1 ))
                        template_json+="$current_json_value,"
                    fi 
                    
                done

                # TODO: ajustar problema ao inserir ultimo objeto dentro de array com virgula
                # TODO: separar melhorar logica de geracao de JSON dinamico

                json_file+="$template_json,"                
                
                
            fi
            
        done

    fi

done < "$file"

# output esperado -> {'id':'1','game':'destiny'},{'id':'2','game':'the surge 2'},{'id':'3','game':'lol'},
echo $json_file