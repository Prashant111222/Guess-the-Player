#!/bin/bash

#initializing global variables
loginCount=4
password="coursework"
userName="default"
userID="default"

#main function from where script initiates
main(){
	#Checking if the number of arguments passed two or more
	if [ ! $# -gt 2 ]
	then
		#checking if two arguments with some value have provided
		if [[ -n $1 && -n $2 ]]
		then
			#assigning the arguments to the variables
			userName=$1
			userID=$2

			#loop for checking the correctness of the password
			until [ $loginCount -lt 0 ]
			do
				echo -n "Enter Password: "
				read -s pass #reading input by hiding the text
				if [ $pass == $password ]
				then
					#calling the functions for welcoming player and starting game
					welcomeUser
					startGame
				else
					#displaying error message by calling function
					incorrectPasswordMessage
					let "((loginCount--))"
				fi
			done
		else
			fileNameErrorMessage
		fi
	else
		fileNameErrorMessage
	fi
}

#function for starting game by displaying country code and rules
startGame(){
	gameRules
	countryName

	countryCodeFlag=1
	#running loop unless the correct team is selected
	while ((countryCodeFlag))
	do
		echo -ne "\nType Country Code for the Preferred Team: "
		read countryCode

		#Checking the user provided country code
		case $countryCode in
			"BRZ" | "brz")
				echo -e "\nBrazil didn't Play Well in the Last Tournament. TRY AGAIN!";;
			"ARG" | "arg")
				echo -e "\nArgentina didn't Play Well in the Last Tournament. TRY AGAIN!";;
			"NEP" | "nep")
				#calling function for displaying player details
				bestCountry
				bestPlayers
				choosingPlayers;;
			"CHI" | "chi")
				echo -e "\nChina didn't Play Well in the Last Tournament. TRY AGAIN!";;
			"ENG" | "eng")
				echo -e "\nEngland didn't Play Well in the Last Tournament. TRY AGAIN!";;
			*)
				#displaying error message if incorrect code is provided
				countryCodeErrorMessage;;
		esac
	done
}

#funciton for verifying the correctness of provided player codes
choosingPlayers(){
	playerFlag=1
	while ((playerFlag))
	do
		echo -n "Enter Your Favourite Players Codes: "
		read player1 player2 player3 playerX

		#coditional for checking if exactly 3 inputs are provided
		if [[ -z $player1 || -z $player2 || -z $player3 || -n $playerX ]]
		then
			invalidNumberOfPlayer
		else
			#calling function for validating provided inputs
			playersCodeValidating $player1 $player2 $player3
			playerSelectionHint

			#displaying choices from selected players to select any one
			PS3="Enter the Number of Player: "
			select starPlayer in ${player1^^} ${player2^^} ${player3^^} #for displaying text in uppercase
			do
				case $starPlayer in
					"LM")
						#opening text file and displaying option to play again
						cat 'LM.txt'
						playAgain;;
					"NJ")
						cat 'NJ.txt'
						playAgain;;
					"HK")
						#displayign error message and restarting game
						playerNotFound
						startGame;;
					"KC")
						cat 'KC.txt'
						playAgain;;
					"ZZ")
						playerNotFound
						startGame;;
					*)
						#displaying error when invalid input is provided
						invalidPlayer;;
				esac
			done
		fi
	done
}

#function for checking correct and unique player codes
playersCodeValidating(){
	for player in $player1 $player2 $player3
	do
		case $player in
			"LM" | "lm");;
			"NJ" | "nj");;
			"KC" | "kc");;
			"ZZ" | "zz");;
			"HK" | "hk");;
			*)
				#restarting selection process if invalid codes are provided
				incorrectPlayerCodeMessage
				choosingPlayers;;
		esac
	done

	#checking for the same player code and restarting selection if found any
	if [[ ${player1^^} == ${player2^^} || ${player1^^} == ${player3^^} || ${player2^^} == ${player3^^} ]]
	then
		similarPlayerError
		choosingPlayers
	fi
}

#function for continuing or exiting game
playAgain(){
	echo "
.----------------------.
| Want to Play Again ? |
'----------------------'"

	playAgainFlag=1
	#running until correct option is selected
	while ((playAgainFlag))
	do
		echo ""
		echo -n "Press [Y/y] to Continue OR [N/n] to Exit: "
		read playMore

		case $playMore in
			"Y" | "y")
				startGame;;
			"N" | "n")
				finalGreetings
				exit;;
			*);;
		esac
	done
}

#functions for decorating the texts for displaying to users
welcomeUser(){
	echo -e "\n
     Hello! ${userName^^}, Warm Greetings :)

.-----------------------------------------------.
|    Your Credentials are Mentioned Below:  	|
'-----------------------------------------------'

  User Name: ${userName^^}
  User ID: ${userID^^}
  Login Time: `date`

.×××××××××××××××××××××××××××××××××××××××××××××××.
|          Now, Let's Start the Game!        	|
'×××××××××××××××××××××××××××××××××××××××××××××××'
"
}

gameRules(){
	echo "
.-------------------------------------------------------.
|    		       GAME RULES	    		|
|-------------------------------------------------------|
| ♠ Player should predict the best football team among  |
|   the teams mentioned below.				|
| ♠ The country code of the preferred team is required  |
|   to provide.						|
| ♠ If appropriate team is selected, the player will be |
|   able to view details of five-star players.          |
|-------------------------------------------------------|
|    		     Best of Luck ☻			|
'-------------------------------------------------------'
"
}

countryName(){
	echo "
.------------------------------------.
|	 Countries    |	   Codes     |
|---------------------|--------------|
|	 Brazil       |	    BRZ      |
|	 Argentina    |	    ARG	     |
|	 Nepal	      |	    NEP	     |
|	 China	      |	    CHI	     |
|	 England      |     ENG      |
'------------------------------------'
"
}

bestCountry(){
	echo "
.----------------------------------------------------.
|      Congratulations! Best Team Selected ♪ ♫	     |
|----------------------------------------------------|
| ♣ The Nepal football team governed by All Nepal    |
|   Football Association (ANFA), represents Nepal    |
|   in Internaitonal men's football.                 |
| ♣ The head coach of the team is Bal Gopal Maharjan |
|   where as the current captain is Kiran Chemjong.  |
| ♣ During their tenure Nepal national team has been |
|   able to win many international tournaments incl- |
|   uding the last one.                              |
|----------------------------------------------------|
|         ♦ Some more Insight of the Team ♦          |
|----------------------------------------------------|
| ♦ President: Karma Tsering Sherpa                  |
| ♦ AFC Affiliation: 1954                            |
| ♦ FIFA Affiliation: 1972                           |
| ♦ SAFF Affiliation: 1997                           |
'----------------------------------------------------'
"
}

bestPlayers(){
	echo "
.----------------------------------------------------.
|                ♪ Picking Players ♪                 |
|----------------------------------------------------|
| ♠ Below are the top 5 players from Nepal's         |
|   National football team.                          |
| ♠ You must select 3 players among 5 of them.	     |
| ♠ After selecting the players, provide their codes |
|   by separating with the spaces.                   |
'----------------------------------------------------'

.-----------------------------------.
|      Players       |	  Codes     |
|--------------------|--------------|
|    Lionel Messi    |	    LM      |
|    Neymar Junior   |	    NJ	    |
|    Kiran Chemjong  |      KC      |
|    Zheng Zhi       |	    ZZ	    |
|    Harry Kane      |      HK      |
'-----------------------------------'
"
}

finalGreetings(){
	echo "
.---------------------------------------------------.
| Thank You♥ For Playing the Game! See You Around☻. |
'---------------------------------------------------'
"
}

playerNotFound(){
	echo "
.××××××××××××××××××××××××××××××××××××××××.
| ERROR-402! Player Not Found, TRY AGAIN |
'××××××××××××××××××××××××××××××××××××××××'
"	
}

invalidPlayer(){
	echo "
.××××××××××××××××××××××××××××××××××.
| ERROR-403! Bad Choice, TRY AGAIN |
'××××××××××××××××××××××××××××××××××'
"
}

playerSelectionHint(){
	echo "
.----------------------------------------------------.
| Now, Feel Free to Choose Any One of These Players. |
'----------------------------------------------------'
"
}

similarPlayerError(){
	echo "
.×××××××××××××××××××××××××××××××××××××××××××××××××××××××××.
| ERROR-409! Cann't Select Two Similar Players, TRY AGAIN |
'×××××××××××××××××××××××××××××××××××××××××××××××××××××××××'
"
}

incorrectPlayerCodeMessage(){
	echo "
.×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××.
|		     ERROR-408! Bad Player Code                         |
|-----------------------------------------------------------------------|
|     If Your 3 Favourite Players are Messi, Neymar, and Harry then:    |
|                   Type: LM NJ HK (OR) lm nj hk                        |
'×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××'
"
}

invalidNumberOfPlayer(){
	echo "
.×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××.
|                  ERROR-407! Invalid Number of Input                   |
|-----------------------------------------------------------------------|
|     If Your 3 Favourite Players are Messi, Neymar, and Harry then:    |
|                   Type: LM NJ HK (OR) lm nj hk                        |
'×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××'
"
}

countryCodeErrorMessage(){
	echo "
.×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××.
|		     ERROR-406! Bad Country Code                        |
|-----------------------------------------------------------------------|
|     If Your Preferred Team is 'China' Then Type 'CHI' or 'chi'        |
'×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××'
"
}

fileNameErrorMessage(){
	echo "
.×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××.
|				ERROR-404!                                      |
|-------------------------------------------------------------------------------|
|Please, Provide FILE_NAME Followded by USER_NAME & USER_ID Separated By Spaces:|
|			FILE_NAME USER_NAME USER_ID				|
'×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××'
"
}

incorrectPasswordMessage(){
	echo -e "\n
.×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××.
|				ERROR-405!                              |
|-----------------------------------------------------------------------|
|             Incorrect Credentials, $loginCount Attempts Remaining.              |
'×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××'
"
}

#calling the main function by passing the arguments
main $1 $2 $3