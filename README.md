Chatsweeper

A chat-controlled minesweeper game written in Gosu.

Set up your .env file:

IRC_SERVER=irc.twitch.tv
IRC_CHANNEL="#quantumproductions" < twitch username
IRC_NICK=quantumproductions < twich username
IRC_PASSWORD=oauth: your twitch oauth from http://twitchapps.com/tmi/

ruby chatsweeper.rb

In twitch chat, players type

sweep 5,5 to vote where to sweep mines
flag 2, 4 to vote to mark where a mine is with a flag

twitch delays streams by 10 seconds, so the voting results doesn't happen until -10 seconds on the timer, which stays at 0 for 10 seconds. This is to give the viewer the illusion the vote happens when their streamed timer shows 0.

@quantumpotato
@subdigital
