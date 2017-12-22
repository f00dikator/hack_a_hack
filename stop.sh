#!/bin/sh

ps auxww | awk '/[p]serv/ {print "kill -TERM " $2}' | sh
