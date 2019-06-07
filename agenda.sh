#    _                        _         __ _          _ _ 
#   /_\   __ _  ___ _ __   __| | __ _  / _\ |__   ___| | |
#  //_\\ / _` |/ _ \ '_ \ / _` |/ _` | \ \| '_ \ / _ \ | |
# /  _  \ (_| |  __/ | | | (_| | (_| | _\ \ | | |  __/ | |
# \_/ \_/\__, |\___|_| |_|\__,_|\__,_| \__/_| |_|\___|_|_|
#        |___/                                            
#						By: LuisSilva - 06/06/2019

# FUNCOES
source funcoes.sh

# MENU
while [ true ]; do	
	form=$(zenity 	--width=300 \
					--height=300 \
					--list \
					--column "Menu" \
					--title="AGENDA SHELL SCRIPT" \
						"Selecionar Agenda" \
						"Criar Agenda" \
						"Sair")
	
	# Fechar no X ou Cancelar
	if [ $? -eq 1 ]
	then
		exit
	fi	
	
	# MENU
	case $form in
		'Criar Agenda')
			addAgenda;;
		'Selecionar Agenda')
			listarAgendas;;
		*)
			exit;;
	esac
done
