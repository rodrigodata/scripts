#!/bin/bash

file_input=$1
file_output=$2
is_double_quote=$3

total_number_lines=$(wc -l < $file_input)
json_file=""
# quote string (double ou single)
q=false

echo "Total de linhas no arquivo: $total_number_lines"
echo "Caminho do arquivo informado: $1"

# gerar json com double ou single quotes
if [ "$is_double_quote" = false ]
then 
    q="'"
else 
    q="\""
fi 

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

        # abertura header json
        header_json=""    

        # caso seja a linha apos imediatamente a primeira, ou seja, apos a linha do header
        # identificamos que seja a primeira linha com dados do csv, com isso, abrimos nosso json
        # corretamente
        if [ $i -eq 2 ]
        then
            json_file+="["
        fi

        #echo "Processando linha -> $i -> $line"
        IFS=',' read -ra row_array <<< "$line"

        current_cell_index=0
        row_array_size="${#row_array[@]}"
        

        # iteramos sobre todos os valores dentro do array $row_array
        for current_cell_value in "${row_array[@]}"
        do
            

            current_header_value=${header_array[$current_cell_index]}

            header_json+="$q$current_header_value$q:$q$current_cell_value$q," 
            
            # acrescimo de contagem do index
            current_cell_index=$(( current_cell_index + 1 ))

            if [ $row_array_size -eq $current_cell_index ]
            then

                IFS=',' read -ra json_array <<< "$header_json"
                template_json=""
                template_json+="{"
                
                current_json_index=1

                for current_json_value in "${json_array[@]}"                
                do 
                
                    if [ $current_json_index -eq "${#json_array[@]}" ]
                    then 

                        template_json+="$current_json_value}"

                        # caso o numero total de linhas seja igual ao index atual de iteracao
                        # identificamos que este e o ultimo item a ser lido do csv. Com isso,
                        # conseguimos fechar o json corretamente
                        if [ $i -eq $((total_number_lines)) ]
                        then 
                            template_json+="]"              
                        else 
                            template_json+=","              
                        fi 

                    else
                        current_json_index=$(( current_json_index + 1 ))
                        template_json+="$current_json_value,"
                    fi 
                    
                done

                json_file+="$template_json"                
                
            fi
            
        done

    fi

done < "$file_input"

# output esperado -> [{'id':'1','game':'destiny'},{'id':'2','game':'the surge 2'},{'id':'3','game':'lol'}]
echo $json_file > $file_output