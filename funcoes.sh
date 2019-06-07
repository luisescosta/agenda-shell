#    _                        _         __ _          _ _ 
#   /_\   __ _  ___ _ __   __| | __ _  / _\ |__   ___| | |
#  //_\\ / _` |/ _ \ '_ \ / _` |/ _` | \ \| '_ \ / _ \ | |
# /  _  \ (_| |  __/ | | | (_| | (_| | _\ \ | | |  __/ | |
# \_/ \_/\__, |\___|_| |_|\__,_|\__,_| \__/_| |_|\___|_|_|
#        |___/                                            
#						By: LuisSilva - 06/06/2019

# MENU
function addAgenda(){
	nome=$(zenity --forms \
					--title="AGENDA" \
					--text "Contato" \
					--add-entry "Nome")
    case $? in
        0)
            if [ "$nome" != '' ] && [ "$nome" != ' ' ]
            then
                senha=$(zenity --password )
                case $? in
                    0)
                        nome=$(echo "$nome" | cut -d '|' -f 1 | tr [a-z] [A-Z] | sed "s, ,_,g")
                        if [ "$senha" != '' ] && [ "$senha" != ' ' ]
                        then 
                            $(mkdir agendas/$nome)
                            $(echo $senha >> agendas/$nome/senha.txt)
                        else $(zenity --info --title "AGENDA" --text "Senha nao eh valida!")
                        fi
                    ;;
                esac
            else $(zenity --info --title "AGENDA" --text "Nome nao eh valido!")
            fi
        ;;
    esac
}

# LISTAR AGENDAS
function listarAgendas() {
	items=()
    cont=0
	
    agendas=$(ls agendas | sed "s, ,\\n,g")

	for line in $agendas;
    do 
        cont=$(($cont+1))
        line=$(echo "$line" | sed "s,_, ,g" | tr [a-z] [A-Z])
        items+=( "$line" );
    done
    entrada="$(zenity 	--width=500 \
                        --height=300 \
                        --text 'Lista de Contatos' \
                        --list \
                        --column='Nome' "${items[@]}" \
                        --title="AGENDA SHELL SCRIPT")"
    case $? in
        0)
            senha=$(zenity --password --title="AGENDA")
            case $? in
                0)
                    entrada=$(echo $entrada | sed "s, ,_,g")
                    senhaA=$(cat agendas/$entrada/senha.txt)
                    if [ $senha = $senhaA ]
                    then
                        dirAgenda="agendas/$entrada/agenda.txt"
                        dirSenha="agendas/$entrada/senha.txt"
                        menuContatos
                    else
                        $(zenity    --info \
                                    --width=200 \
                                    --height=50 \
                                    --title="AGENDA" \
                                    --text "SENHA INCORRETA!")
                    fi
                ;;
            esac
        ;;
    esac    
}

# CONTATOS

function menuContatos () {
	# MENU
	vl=true
	while [ $vl != false ]; do
		removerLinhas
		form=$(zenity 	--width=300 \
						--height=300 \
						--list \
						--column "Menu" \
						--title="AGENDA SHELL SCRIPT" \
							"Adicionar Contato" \
							"Editar Contato" \
							"Listar Contatos" \
							"Remover Contato"\
							"Editar Senha")

		case $? in
			0)
			# MENU
			case $form in
				'Adicionar Contato')
					addContato;;
				'Editar Contato')
					editarContato;;
				'Listar Contatos')
					listarContatos;;
				'Remover Contato')
					removerContato;;
				'Editar Senha')
					editarSenha;;
			esac
			;;
			1)
				vl=false;;
			*)
				vl=false;;
		esac	
	done
}


# ADICIONAR NOVO CONTATO
function addContato(){
	entrada=`zenity --forms \
					--title="AGENDA" \
					--text "Contato" \
					--add-entry "Nome" \
					--add-entry "Telefone" `

	case $? in
		0)
			# NOME E TELEFONE LIMPO
			nome=$(echo "$entrada" | cut -d '|' -f 1 | tr [a-z] [A-Z])
			telefone=$(echo "$entrada"| cut -d '|' -f 2 )
			
			if [ ! -z "$nome" ] && [ "$nome" != ' ' ]
			then
				if [ ! -z "$telefone" ] && [ "$telefone" != ' ' ]
				then
					# NOME E TELEFONE COM _
					nome=$(echo "$entrada" | cut -d '|' -f 1 | tr [a-z] [A-Z] | sed "s, ,_,g")	
					telefone=$(echo "$entrada"| cut -d '|' -f 2 | sed "s, ,_,g")
				
					$(echo "$nome|$telefone" >> "$dirAgenda")
					# REMOVER _
					nome=$(echo $nome | sed "s,_, ,g")
					
					$(zenity 	--info \
								--width=300 \
								--height=50 \
								--title="AGENDA" \
								--text "$nome Cadastrado")

				else $(zenity 	--info \
								--title "AGENDA" \
								--width=300 \
								--height=100 \
								--text "Telefone nao eh valido!")
				fi
			else $(zenity 	--info \
							--title "AGENDA" \
							--width=300 \
							--height=100 \
							--text "Nome nao eh valido!")
			fi;;
	esac
}


# LISTAR TODOS OS CONTATOS
function listarContatos() {
	items=()
	# PEGAR TODOS OS CONATOS/LINHA
	entrada=$(grep '' $dirAgenda -n | tr [a-z] [A-Z])
	
	for line in $entrada;
	do 
		index=$(echo "$line"| cut -d ':' -f 1)
		
		nome=$(echo "$line"| cut -d '|' -f 1)
		nome=$(echo "$nome" | cut -d ':' -f 2 | sed "s,_, ,g")
		telefone="$(echo "$line"| cut -d '|' -f 2)"
		items+=( "$index" "$nome" "$telefone" );
		
	done
	
	vl=$(zenity --width=500 \
				--height=300 \
				--text 'Lista de Contatos' \
				--list --column='#' \
				--column='Nome' \
				--column='Telefone' "${items[@]}" \
				--title="AGENDA SHELL SCRIPT")
	

}


function removerContato () {
	items=()
	
	entrada=`zenity --forms \
					--text "Editar Contato" \
					--add-entry "Nome/Telefone"`
	
	case $? in
		0)
			entrada=$(echo $entrada | tr [a-z] [A-Z])
			entrada=$(grep "$entrada" $dirAgenda -n | tr [a-z] [A-Z])
			nome="$(echo "$entrada" | cut -d '|' -f 1)"
			nome="$(echo "$nome" | cut -d '|' -f 2)"
			
			for line in $entrada;
			do 
				index=$(echo "$line"| cut -d ':' -f 1)
				nome=$(echo "$line"| cut -d '|' -f 1)
				nome=$(echo "$nome" | cut -d ':' -f 2 | sed "s,_, ,g")
				telefone="$(echo "$line"| cut -d '|' -f 2)"
				items+=( "$index" "$nome" "$telefone" );
			done
			
			form="$(zenity 	--width=500 \
							--height=300 \
							--list --column='#' \
							--column='Nome' \
							--column='Telefone' "${items[@]}" \
							--title="AGENDA SHELL SCRIPT")"
			
			case $? in
				0)
					# CONTAR LINHAS
					linhas=$(wc -l $dirAgenda)
					linhas=$(echo "$linhas" | cut -d ' ' -f 1)
					linhas=$(($linhas))

					# PEGAR TODOS OS CONTATOS MENOS O ESCOLHIDO
					comeco=$(($form-1))
					fim=$(($form-$linhas))					
					
					# CONTATO ESCOLHIDO
					update=$(cat $dirAgenda | head -n $form | tail -n 1)
					updateNome=$(echo $update | cut -d '|' -f 1)
					updateTell=$(echo $update | cut -d '|' -f 2)
					
					# SALVAR TODOS OS CONTATOS
					comeco=$(cat $dirAgenda | head -n $comeco)
					fim=$(cat $dirAgenda | tail -n $fim)
					
					# APAGAR AGENDA
					$(> $dirAgenda | sed '/^$/d')

					# RETORNAR CONTATOS ANTIGOS
					$(echo $comeco | sed "s, ,\n,g" >> $dirAgenda)
					$(echo $fim | sed "s, ,\n,g" >> $dirAgenda)
				;;
			esac
		;;
	esac
}

# EDITAR UM CONTATO
function editarContato () {
	items=()
	
	entrada=`zenity --forms \
					--text "Editar Contato" \
					--add-entry "Nome/Telefone"`
	
	case $? in
		0)
			entrada=$(echo $entrada | tr [a-z] [A-Z])
			entrada=$(grep "$entrada" $dirAgenda -n | tr [a-z] [A-Z])
			nome="$(echo "$entrada" | cut -d '|' -f 1)"
			nome="$(echo "$nome" | cut -d '|' -f 2)"
			
			for line in $entrada;
			do 
				index=$(echo "$line"| cut -d ':' -f 1)
				nome=$(echo "$line"| cut -d '|' -f 1)
				nome=$(echo "$nome" | cut -d ':' -f 2 | sed "s,_, ,g")
				telefone="$(echo "$line"| cut -d '|' -f 2)"
				items+=( "$index" "$nome" "$telefone" );
			done
			
			form="$(zenity 	--width=500 \
							--height=300 \
							--list --column='#' \
							--column='Nome' \
							--column='Telefone' "${items[@]}" \
							--title="AGENDA SHELL SCRIPT")"
			
			case $? in
				0)
					# CONTAR LINHAS
					linhas=$(wc -l $dirAgenda)
					linhas=$(echo "$linhas" | cut -d ' ' -f 1)
					linhas=$(($linhas))

					# PEGAR TODOS OS CONTATOS MENOS O ESCOLHIDO
					comeco=$(($form-1))
					fim=$(($form-$linhas))					
					
					# CONTATO ESCOLHIDO
					update=$(cat $dirAgenda | head -n $form | tail -n 1)
					updateNome=$(echo $update | cut -d '|' -f 1 | sed "s,_, ,g")
					updateTell=$(echo $update | cut -d '|' -f 2 | sed "s,_, ,g")
					
					# SALVAR TODOS OS CONTATOS
					comeco=$(cat $dirAgenda | head -n $comeco)
					fim=$(cat $dirAgenda | tail -n $fim)
					
					# MODIFICAR CONTATO
					entrada=`zenity --forms \
									--title="AGENDA" \
									--text "Contato" \
									--add-entry "$updateNome" \
									--add-entry "$updateTell" `
					case $? in
						0)
							# ADICIONAR CONTATO EDITADO
							nome=$(echo $entrada | cut -d '|' -f 1 | tr [a-z] [A-Z] | sed "s, ,_,g")
							telefone=$(echo $entrada | cut -d '|' -f 2 | sed "s, ,_,g")
							if [ ! -z $nome ] && [ ! -z $telefone ] && [ ' ' != $nome ] && [ ' ' != $telefone ]
							
							then 
								# APAGAR AGENDA
								$(> $dirAgenda | sed '/^$/d')

								# RETORNAR CONTATOS ANTIGOS
								$(echo $comeco | sed "s, ,\n,g" >> $dirAgenda)
								$(echo $fim | sed "s, ,\n,g" >> $dirAgenda)				
								$(echo "$nome|$telefone" >> $dirAgenda)	
							else echo 'deu errado aqui viu!'
							fi
						;;
					esac
				;;
			esac
		;;
	esac
}


# EDITAR SENHA
function editarSenha () {
	senha=$(zenity 	--password \
					--title="AGENDA" \
					--text="Nova Senha:")
	
	case $? in
		0)
			if [ "$senha" != '' ] && [ "$senha" != ' ' ]
				then
					$(> $dirSenha | sed '/^$/d')
					echo $senha >> $dirSenha
				else $(zenity --info --title "AGENDA" --text "Senha nao eh valida!")
			fi
		;;
	esac
}

# REMOVER LINHAS EM BRANCO DA AGENDA.TXT
function removerLinhas () {
	agenda=$(sed '/^$/d' $dirAgenda )
	$(> $dirAgenda | sed '/^$/d')
	$(echo $agenda | sed "s, ,\\n,g" >> $dirAgenda)
}

